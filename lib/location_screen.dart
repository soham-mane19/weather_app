import 'package:flutter/material.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:Stack(
        children: [
         Container(
             height: MediaQuery.of(context).size.height,
             decoration:  const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/Image.png'),fit: BoxFit.cover)
             ),

         ),
          
Column(
        children: [
Padding(
  padding: const EdgeInsets.only(top: 30),
  child: Row(
    children: [
    IconButton(
      onPressed: (){
            Navigator.of(context).pop();
      },
      icon:  const Icon(Icons.arrow_back,color: Colors.white,),
      ),
      const SizedBox(
        width: 15,
      ),
      TextFormField(
        
      )
  ],),
)
        ],
      ),
        ],
      ) 
      
      
      
    );
  }
}