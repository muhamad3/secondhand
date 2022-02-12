import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 1) {
      Navigator.popAndPushNamed(context, '/post');
    }
    if (_selectedIndex == 2) {
      Navigator.popAndPushNamed(context, '/profile');
    }
  }

  File? image;
  Future pickimage() async {

   final image= await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    
    final imageTemporary = File(image.path);
    setState(()=> this.image = imageTemporary );
  }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('home'),
        ),
        body: Center(
            child: Column(
            children:[ ElevatedButton(
                onPressed: () => pickimage(),
                child: Text('pick an image from gallery')
                ),
                 Container(
                   child:  image !=null ? ClipOval( child: Image.file(image!,width: 160,height: 160,fit: BoxFit.cover,),
                   )
                    :FlutterLogo()
                 ),
                 ]
                ),
                
               
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              label: 'posting',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.cyan,
          onTap: _onItemTapped,
        ),
      );
    }
  }

 

