class Chatsdata {
  String? email;
  String? name;
  Chatsdata({
    this.email,
    this.name,
  });
  
    static Chatsdata fromJson(Map<String,dynamic>json) => Chatsdata(
        name:json['name'],
        email:json['email']
      );
}
