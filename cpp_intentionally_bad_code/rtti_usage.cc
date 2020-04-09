
#include <iostream>
#include <memory>
#include <regex>
#include <typeinfo>

class BaseClass {

 public:
  virtual void print() const { std::cout << "I'm the base class" << std::endl; }

};

class DerivedClass : public BaseClass {

 public:
  void print() const override { std::cout << "I'm the derived class" << std::endl; }

};

void Print(const BaseClass& printclass) {

  printclass.print();
}

void PrintOnlyDerived1(const BaseClass& printclass) {

  try {
    
    auto dc = dynamic_cast<const DerivedClass&>( printclass );
    dc.print();

  } catch (const std::bad_cast& err) {
    std::cerr << "Unable to dynamically cast the printclass: " << err.what() << std::endl;
  }

}

void PrintOnlyDerived2(const BaseClass& printclass) {

  //  std::cout << "typeid is " << typeid(printclass).name() << std::endl;

  if (std::regex_match (typeid(printclass).name(), std::regex(".*DerivedClass.*"))) {
    printclass.print();
  } else {
    std::cerr << "Object passed to PrintOnlyDerived2 doesn't appear to be a member of DerivedClass" << std::endl;
  }

}

int main() {

  BaseClass bc;
  DerivedClass dc;

  Print(bc);
  Print(dc);

  PrintOnlyDerived1(bc);
  PrintOnlyDerived1(dc);

  PrintOnlyDerived2(bc);
  PrintOnlyDerived2(dc);

  return 0;
}
