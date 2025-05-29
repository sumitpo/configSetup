#include <iostream>
#include <thread>
#include <mutex>
#include <condition_variable>
#include <queue>
#include <sstream>

// 线程安全队列
template <typename T> class SafeQueue {
    public:
	void push(T value)
	{
		{
			std::lock_guard<std::mutex> lock(mtx_);
			queue_.push(std::move(value));
		}
		cv_.notify_one(); // 唤醒一个等待的线程
	}

	bool pop(T &value)
	{
		std::unique_lock<std::mutex> lock(mtx_);
		cv_.wait(lock, [this] { return !queue_.empty() || stop_; });
		if (queue_.empty())
			return false;
		value = std::move(queue_.front());
		queue_.pop();
		return true;
	}

	void stop()
	{
		std::lock_guard<std::mutex> lock(mtx_);
		stop_ = true;
		cv_.notify_all(); // 唤醒所有线程以便退出
	}

    private:
	std::queue<T> queue_;
	std::mutex mtx_;
	std::condition_variable cv_;
	bool stop_ = false;
};

void io_thread();
void worker(int);
