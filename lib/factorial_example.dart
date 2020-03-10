void main() {
  int factorial(int n) {
    if (n == 0) {
      return 1;
    } else {
      int result = (n * factorial(n - 1));
      return result;
    }
  }

  int result = factorial(5);
  print(result);
}