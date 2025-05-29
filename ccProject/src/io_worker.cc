#include <iostream>
#include <thread>
#include <sstream>
#include "io_worker.h"


// 全局队列
SafeQueue<std::string> task_queue;

// 工人线程函数
void worker(int id)
{
	std::string task;
	while (task_queue.pop(task)) {
		std::ostringstream oss;
		oss << "Worker " << id << " processing: " << task;
		std::cout << oss.str() << std::endl;
	}
	std::cout << "Worker " << id << " exiting." << std::endl;
}

// I/O 线程函数
void io_thread()
{
	for (int i = 1; i <= 200; ++i) {
		std::ostringstream oss;
		oss << "Task-" << i;
		std::string task = oss.str();
		std::cout << "[I/O] New task: " << task << std::endl;
		task_queue.push(task);
		std::this_thread::sleep_for(
			std::chrono::milliseconds(50)); // 模拟延迟
	}
	std::cout << "[I/O] All tasks sent. Stopping..." << std::endl;
	task_queue.stop(); // 停止队列，唤醒所有线程
}
