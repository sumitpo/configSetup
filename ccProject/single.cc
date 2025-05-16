#include "single.h"
SingleTeon *SingleTeon::ptr = nullptr;
std::mutex SingleTeon::mutex_;
SingleTeon *SingleTeon::getInstance()
{
  mutex_.lock();
  if (ptr == nullptr) {
    ptr = new SingleTeon();
  }
  mutex_.unlock();
  return ptr;
}
