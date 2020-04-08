
// This is a comment to change the lines

#include <cstdint>

int main() {

  int myint = 7;
  int myint2 = static_cast<int>(myint); // Casting to the same type
  auto mydouble = double(myint); // Should use static_cast

  auto myptr = reinterpret_cast<uint64_t*>(&myint); // Should get a warning 

}
