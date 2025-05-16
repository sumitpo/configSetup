#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>

#define THREAD_POOL_SIZE 4
#define MAX_REQUESTS 100
#define BUFFER_SIZE 1024

/* 共享资源：请求计数器 */
typedef struct {
	int count;
	pthread_mutex_t lock;
} RequestCounter;

/* 线程参数 */
typedef struct {
	int thread_id;
	int client_sock;
	RequestCounter *counter;
} ThreadArgs;

/* 全局线程池和计数器 */
pthread_t thread_pool[THREAD_POOL_SIZE];
RequestCounter counter = { 0, PTHREAD_MUTEX_INITIALIZER };

/* 内存泄漏示例 */
void *leak_memory()
{
	char *buffer = malloc(256); // 故意不释放
	snprintf(buffer, 256, "Memory leak at %ld", time(NULL));
	return NULL;
}

/* 竞态条件示例 */
void *race_condition(ThreadArgs *args)
{
	// 忘记加锁的共享资源访问
	args->counter->count++; // 这里应该加锁

	// 模拟处理延迟
	usleep(10000);
	return NULL;
}

/* 空指针解引用示例 */
void crash_server(int *ptr)
{
	printf("Crash incoming...\n");
	*ptr = 42; // 故意解引用空指针
}

/* 线程处理函数 */
void *handle_client(void *arg)
{
	ThreadArgs *args = (ThreadArgs *)arg;
	char buffer[BUFFER_SIZE];

	// 1. 读取客户端请求
	ssize_t bytes_read = read(args->client_sock, buffer, BUFFER_SIZE - 1);
	if (bytes_read < 0) {
		perror("read failed");
		close(args->client_sock);
		free(args);
		return NULL;
	}
	buffer[bytes_read] = '\0';

	// 2. 模拟不同类型的错误
	if (strstr(buffer, "LEAK")) {
		leak_memory();
		snprintf(buffer, BUFFER_SIZE, "Memory leaked!");
	} else if (strstr(buffer, "RACE")) {
		race_condition(args);
		snprintf(buffer, BUFFER_SIZE, "Race condition triggered!");
	} else if (strstr(buffer, "CRASH")) {
		crash_server(NULL); // 触发崩溃
	} else {
		snprintf(buffer, BUFFER_SIZE,
			 "OK: Thread %d handled request %d", args->thread_id,
			 args->counter->count);
	}

	// 3. 返回响应
	write(args->client_sock, buffer, strlen(buffer));
	close(args->client_sock);
	free(args);
	return NULL;
}

/* 初始化服务器 */
int init_server(int port)
{
	int server_fd;
	struct sockaddr_in address;

	if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
		perror("socket failed");
		exit(EXIT_FAILURE);
	}

	address.sin_family = AF_INET;
	address.sin_addr.s_addr = INADDR_ANY;
	address.sin_port = htons(port);

	if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
		perror("bind failed");
		exit(EXIT_FAILURE);
	}

	if (listen(server_fd, 10) < 0) {
		perror("listen failed");
		exit(EXIT_FAILURE);
	}

	return server_fd;
}

int main(int argc, char *argv[])
{
	if (argc != 2) {
		fprintf(stderr, "Usage: %s <port>\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	int port = atoi(argv[1]);
	int server_fd = init_server(port);
	printf("Server started on port %d (PID: %d)\n", port, getpid());

	// 初始化线程池
	for (int i = 0; i < THREAD_POOL_SIZE; i++) {
		pthread_create(&thread_pool[i], NULL,
			       (void *(*)(void *))handle_client, NULL);
	}

	// 主循环
	while (1) {
		struct sockaddr_in client_addr;
		socklen_t addr_len = sizeof(client_addr);
		int client_sock;

		if ((client_sock = accept(server_fd,
					  (struct sockaddr *)&client_addr,
					  &addr_len)) < 0) {
			perror("accept failed");
			continue;
		}

		// 创建线程参数
		ThreadArgs *args = malloc(sizeof(ThreadArgs));
		args->thread_id = (int)pthread_self();
		args->client_sock = client_sock;
		args->counter = &counter;

		// 提交任务到线程池
		pthread_t temp_thread;
		pthread_create(&temp_thread, NULL,
			       (void *(*)(void *))handle_client, args);
		pthread_detach(temp_thread);

		// 限制最大请求数（用于测试）
		if (counter.count++ > MAX_REQUESTS)
			break;
	}

	close(server_fd);
	return 0;
}
