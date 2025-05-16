#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

// 会崩溃的函数
void crash_me(int *ptr)
{
	*ptr = 42; // 故意解引用空指针
}

// 递归函数（用于展示调用栈）
int factorial(int n)
{
	if (n <= 1) {
		int *bad_ptr = NULL;
		crash_me(bad_ptr); // 这里会段错误
		return 1;
	}
	return n * factorial(n - 1);
}

int main()
{
	printf("Demo started (PID: %d)\n", getpid());

	// 1. 正常逻辑
	printf("5! = %d\n", factorial(5));

	// 2. 触发崩溃

	return 0;
}
