#ifndef SINGLE_H
#define SINGLE_H
#include <mutex>
class SingleTeon {
    private:
	SingleTeon() {};
	SingleTeon(SingleTeon &) = delete;
	SingleTeon operator=(SingleTeon &) = delete;

    public:
	static std::mutex mutex_;
	static SingleTeon *ptr;
	static SingleTeon *getInstance();
};

#endif
