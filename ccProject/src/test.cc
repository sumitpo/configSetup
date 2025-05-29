#include <gtest/gtest.h>
#include "single.h"
#include "io_worker.h"
#include "thread_pool.h"

// Simple test case
TEST(ExampleTest, SimpleAssertion)
{
	EXPECT_EQ(1 + 1, 2); // Simple test
}

// Another test case
TEST(ExampleTest, AnotherTest)
{
	EXPECT_TRUE(5 > 3); // Another simple assertion
}

TEST(SingletonTest, Init)
{
	SingleTeon *obj = SingleTeon::getInstance();
	EXPECT_NE(obj, nullptr);
}

TEST(SingletonTest, Single)
{
	SingleTeon *obj = SingleTeon::getInstance();
	SingleTeon *obja = SingleTeon::getInstance();
	EXPECT_EQ(obja, obj);
}

// Test basic push/pop functionality
TEST(SafeQueueTest, BasicPushPop)
{
	SafeQueue<std::string> q;
	q.push("Task-1");
	std::string task;
	EXPECT_TRUE(q.pop(task));
	EXPECT_EQ(task, "Task-1");
}

// Test that pop blocks when queue is empty
TEST(SafeQueueTest, PopBlocksWhenEmpty)
{
	SafeQueue<std::string> q;
	std::string task;
	bool popped = false;

	std::thread t([&] {
		popped = q.pop(task); // Will block until something is pushed
	});

	std::this_thread::sleep_for(std::chrono::milliseconds(100));
	EXPECT_FALSE(popped); // Should still be blocked

	q.push("Delayed Task");
	t.join();

	EXPECT_TRUE(popped);
	EXPECT_EQ(task, "Delayed Task");
}

// Test multiple producers
TEST(SafeQueueTest, MultipleProducers)
{
	SafeQueue<std::string> q;

	std::thread t1([&] { q.push("T1"); });
	std::thread t2([&] { q.push("T2"); });
	t1.join();
	t2.join();

	std::string task1, task2;
	EXPECT_TRUE(q.pop(task1));
	EXPECT_TRUE(q.pop(task2));

	// Order is not guaranteed
	EXPECT_TRUE((task1 == "T1" && task2 == "T2") ||
		    (task1 == "T2" && task2 == "T1"));
}

// Test worker/io interaction
TEST(ThreadInteractionTest, WorkerProcessesTasksFromIO)
{
	const int NUM_WORKERS = 5;
	std::vector<std::thread> workers;
	std::thread io(io_thread);

	for (int i = 0; i < NUM_WORKERS; ++i) {
		workers.emplace_back(worker, i + 1);
	}

	io.join();
	for (auto &t : workers) {
		if (t.joinable())
			t.join();
	}

	// If we reach here without deadlock, test passes
	SUCCEED();
}


// 测试任务提交和返回值
TEST(ThreadPoolTest, SubmitTaskAndGetResult)
{
	ThreadPool pool(4);

	std::future<int> result = pool.enqueue([]() -> int { return 42; });

	EXPECT_EQ(result.get(), 42);
}

// 测试多个任务并发执行
TEST(ThreadPoolTest, MultipleTasksConcurrentExecution)
{
	ThreadPool pool(4);

	std::vector<std::future<int> > results;

	for (int i = 0; i < 10; ++i) {
		results.push_back(pool.enqueue([i]() -> int {
			std::this_thread::sleep_for(
				std::chrono::milliseconds(100));
			return i * i;
		}));
	}

	std::vector<int> actual;
	for (auto &f : results)
		actual.push_back(f.get());

	std::vector<int> expected = { 0, 1, 4, 9, 16, 25, 36, 49, 64, 81 };
	EXPECT_EQ(actual, expected);
}

// 测试任务抛出异常
TEST(ThreadPoolTest, TaskThrowsException)
{
	ThreadPool pool(2);

	auto future = pool.enqueue([]() -> int {
		throw std::runtime_error("Oops!");
		return 0;
	});

	EXPECT_THROW(future.get(), std::runtime_error);
}

// 测试线程池析构是否正常
TEST(ThreadPoolTest, PoolDestructorJoinsThreads)
{
	std::thread::id worker_id;

	{
		ThreadPool pool(1);
		pool.enqueue([&worker_id]() {
			worker_id = std::this_thread::get_id();
		});
		// Let the thread run
		std::this_thread::sleep_for(std::chrono::milliseconds(100));
	}

	// The thread should have exited, so we can't join again
	// Just test that destructor doesn't crash
	EXPECT_NE(worker_id, std::thread::id());
}

// 测试大量任务处理性能（可选）
TEST(ThreadPoolTest, LargeNumberOfTasks)
{
	ThreadPool pool(4);

	const int task_count = 1000;
	std::vector<std::future<int> > results;

	for (int i = 0; i < task_count; ++i) {
		results.push_back(pool.enqueue([i]() -> int { return i + 1; }));
	}

	int sum = 0;
	for (auto &f : results)
		sum += f.get();

	EXPECT_EQ(sum, (task_count * (task_count + 1)) / 2);
}
