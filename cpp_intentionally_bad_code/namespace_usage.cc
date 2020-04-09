
#include "namespace_usage.hh"

#include <iostream>

namespace {

  const int another_var = 34;

}

namespace labeled_namespace {

  const int another_var2 = 34;

}

static int var_using_classic_storage_specifier = 56;

using namespace labeled_namespace;

int main() {

  std::cout << "my_static_storage_int1 == " << my_static_storage_int1 << std::endl;
  std::cout << "labeled_namespace::another_var2 == " << another_var2 << std::endl;
}
