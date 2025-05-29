#include <vector>
#include <queue>
#include <thread>
#include <mutex>
#include <condition_variable>
#include <functional>
#include <future>
#include <stdexcept>

class ThreadPool {
    public:
	// Constructor: create N worker threads
	explicit ThreadPool(size_t num_threads)
		: stop(false)
	{
		workers.reserve(num_threads);
		for (size_t i = 0; i < num_threads; ++i) {
			workers.emplace_back(&ThreadPool::worker_main, this);
		}
	}

	// Destructor: join all threads
	~ThreadPool()
	{
		{
			std::lock_guard<std::mutex> lock(queue_mutex);
			stop = true;
		}
		condition.notify_all();
		for (std::thread &worker : workers)
			if (worker.joinable())
				worker.join();
	}

	// Submit a task and get a future for result
	template <typename T>
	auto enqueue(T task) -> std::future<decltype(task())>
	{
		using return_type = decltype(task());

		auto *packaged_task =
			new std::packaged_task<return_type()>(std::move(task));

		std::future<return_type> res = packaged_task->get_future();
		{
			std::unique_lock<std::mutex> lock(queue_mutex);

			tasks.emplace(
				[packaged_task]() { (*packaged_task)(); });
		}
		condition.notify_one();

		return res;
	}

    private:
	// This is the main function each thread runs
	void worker_main()
	{
		while (true) {
			std::function<void()> task;

			{
				std::unique_lock<std::mutex> lock(
					this->queue_mutex);
				condition.wait(lock, [this] {
					return this->stop ||
					       !this->tasks.empty();
				});

				if (this->stop && this->tasks.empty())
					return;

				task = std::move(this->tasks.front());
				this->tasks.pop();
			}

			task();
		}
	}

	// Worker threads
	std::vector<std::thread> workers;

	// Task queue
	std::queue<std::function<void()> > tasks;

	// Synchronization
	std::mutex queue_mutex;
	std::condition_variable condition;
	bool stop;
};
