class User{
  late String name;
  late var email;
  late var id;
  late int phone;

  User({
    required this.name,
    required this.email,
    required this.id,
    required this.phone,
});

    getName<String>(){
    return name;
  }

  getEmail(){
      return email;
  }
  getID(){
      return id;
  }
  getPhone<int>(){
      return phone;
  }
}