class HomeController {
  String get welcomeMessage => 'Welcome to Skanida Teacher';

  // Example of a simple action the controller could perform.
  String fetchGreeting() {
    // In real apps this might call services/repositories.
    return welcomeMessage;
  }
}
