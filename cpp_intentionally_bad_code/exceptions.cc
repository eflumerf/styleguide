
// This actually isn't compilable, but is used to test dunecpplint

try {

  // pretend there's code here which can throw a variety of exceptions...

 } catch (...) {

  std::cout << "I swallowed an exception" << std::endl;
 }


try {

  // pretend there's code here which throws a polymorphic reference

 } catch (std::exception exception) {

  std::cout << "I sliced an exception" << std::endl;
 }
