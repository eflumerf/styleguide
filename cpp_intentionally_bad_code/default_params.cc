
#include <iostream>
#include <memory>

class BaseClass {

public:
  
  virtual void VirtualPrintAValue(int value = 27);
  
  void NonVirtualPrintAValue(int value = 127);
};

void BaseClass::VirtualPrintAValue(int value) {
  std::cout << "BaseClass: The value is " << value << std::endl;
}

void BaseClass::NonVirtualPrintAValue(int value) {
  std::cout << "BaseClass: The value is " << value << std::endl;
}

class DerivedClass : public BaseClass {

public:

  void VirtualPrintAValue(int value = 49) override {
    std::cout << "DerivedClass: The value is " << value << std::endl;
  }

};

int main() {
  
  auto bc = std::make_unique<BaseClass>();
  auto dc = std::make_unique<DerivedClass>();

  bc->VirtualPrintAValue();
  dc->VirtualPrintAValue();
  
  bc->NonVirtualPrintAValue();
  dc->NonVirtualPrintAValue();
}
