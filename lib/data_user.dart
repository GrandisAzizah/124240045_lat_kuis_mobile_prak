class User {
  String email;
  String password;

  User({required this.email, required this.password});
}

final List<User> users = [
  User(email: 'adorable_capy@gmail.com', password: 'verysiriusbizofcapy'),
  User(email: 'this.user@gmail.com', password: 'forgetthepassword'),
  User(email: 'user@gmail.com', password: '1234'),
];
