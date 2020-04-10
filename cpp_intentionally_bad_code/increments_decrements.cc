
#include <iostream>

int main() {

  int var1 = 0;

  if (++var1 == 1) {
    std::cout << "Math works" << std::endl;
  }

  for (int var2 = 0; var2 < 5; ++var2) {
    std::cout << "OK to increment with other code in a loop construct (for)" << std::endl;
  }

  int var3 = 0;
  var3++;
  while (++var3 < 5) {
    std::cout << "OK to increment with other code in a loop construct (while)" << std::endl;
  }

  int var4 = 0;
  --var4;  // This is a comment that the linter should be fine with

  return 0;
}
