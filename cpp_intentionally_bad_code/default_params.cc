
#include <iostream>
#include <memory>

class BaseClass {

public:
  
  virtual void PrintAValue(int value = 27);

};

void BaseClass::PrintAValue(int value) {
  std::cout << "BaseClass: The value is " << value << std::endl;
}

class DerivedClass : public BaseClass {

public:

  void PrintAValue(int value = 49) override {
    std::cout << "DerivedClass: The value is " << value << std::endl;
  }

};

int main() {
  
  auto bc = std::make_unique<BaseClass>();
  auto dc = std::make_unique<DerivedClass>();

  bc->PrintAValue();
  dc->PrintAValue();

}
