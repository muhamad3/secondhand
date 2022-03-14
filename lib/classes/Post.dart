// ignore_for_file: file_names
class Post {
  String? price;
  String? name;
  String? description;
  String? email;
  String? catagory;

  Post({this.description, this.name, this.price,this.email,this.catagory});

      static Post fromJson(Map<String,dynamic>json) => Post(
        name:json['Name'],
        price:json['Price'],
        description:json['Description'],
        email:json['Email'],
        catagory:json['catagory'],
      );
}
