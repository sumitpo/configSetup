#include <gtest/gtest.h>
#include "single.h"

// Simple test case
TEST(ExampleTest, SimpleAssertion) {
  EXPECT_EQ(1 + 1, 2);  // Simple test
}

// Another test case
TEST(ExampleTest, AnotherTest) {
  EXPECT_TRUE(5 > 3);   // Another simple assertion
}

TEST(SingletonTest, Init) {
  SingleTeon *obj = SingleTeon::getInstance();
  EXPECT_NE(obj, nullptr);
}

TEST(SingletonTest, Single){
  SingleTeon *obj = SingleTeon::getInstance();
  SingleTeon *obja = SingleTeon::getInstance();
  EXPECT_EQ(obja, obj);
}
