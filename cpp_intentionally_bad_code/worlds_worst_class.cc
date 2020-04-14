#include <iostream>

class BaseClass1 {

public:

  BaseClass1(int val) : val1_(val) {
    PrintPrivateThings();
  }
  int val1_;

private:

  virtual void PrintPrivateThings() {
    std::cout << "BaseClass1 printing to screen" << std::endl;
  }


};

class BaseClass2 {

public:

  BaseClass2(int val) : val2_(val) {}
  int val2_;

};

class DerivedClass : private BaseClass1, private BaseClass2 {

public:
  DerivedClass(int val1, int val2, int val3) :
    BaseClass1(val1),
    BaseClass2(val2),
    val3_(val3) 
  {
    PrintPrivateThings();
  }

  ~DerivedClass() {}
  
private:

  void PrintPrivateThings() override {
    std::cout << "DerivedClass printing to screen" << std::endl;
  }

public:

  void PrintThings() {
    std::cout << val1_ << " " << val2_ << " " << val3_ << std::endl;
  }

  int val3_;


};

int main() {

  DerivedClass myclass(1, 4, 9);
  myclass.PrintThings();
}
