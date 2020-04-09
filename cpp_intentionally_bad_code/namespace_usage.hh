#ifndef CPP_INTENTIONALLY_BAD_CODE_NAMESPACE_USAGE_HH_
#define CPP_INTENTIONALLY_BAD_CODE_NAMESPACE_USAGE_HH_

namespace {
  const int my_static_storage_int1 = 89;
}

int MyFunc() {
  static int myvar = 1;
  myvar++;

  return myvar;

}

static const int my_static_storage_int2 = 90;

class MyClass {

public:
  static const int freeman = 42;
};


// Should be a complaint that this namespace isn't closed with a comment
namespace mynamespace {

  const int mynamespacevar = 76;

}

using namespace mynamespace;

#endif //  CPP_INTENTIONALLY_BAD_CODE_NAMESPACE_USAGE_HH_
