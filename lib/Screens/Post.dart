class Post {
  String? price;
  String? name;
  String? description;
  String? email;

  Post({this.description, this.name, this.price,this.email});

  

      static Post fromJson(Map<String,dynamic>json) => Post(
        name:json['Name'],
        price:json['Price'],
        description:json['Description'],
        email:json['Email'],
      );


}
