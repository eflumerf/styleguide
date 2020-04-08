
#include <iostream>

auto MyFunc1() -> int {

  return 1;
}

template<typename T>
auto MyFunc2() -> T {

  T val = 2.718;
  return val;
}

namespace {

  double important_number = 3.1415;

}  // namespace ""

auto MyFunc3 = []() { return important_number; } ; // Returns by value, implicit " -> auto" here

// MyFunc4 is an example of when you'd NEED trailing return syntax to accomplish the desired behavior
auto MyFunc4 = []() -> auto& { return important_number; } ;

int main() {

  std::cout << MyFunc1() << std::endl;
  std::cout << MyFunc2<double>() << std::endl;

  std::cout << MyFunc3() << std::endl;

  // Next line commented out because without explicit reference (&)
  // from trailing return syntax like in MyFunc4, the lambda returns
  // by value rather than by reference and MyFunc3() is consequently
  // an rvalue - i.e., assignment won't compile

  // MyFunc3() *= 2;  
  std::cout << important_number << std::endl;

  std::cout << MyFunc4() << std::endl;
  MyFunc4() *= 2;  
  std::cout << important_number << std::endl;

}
