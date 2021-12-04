
import 'package:finalexam/Models/token.dart';
import 'package:finalexam/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';



class HomeScreen extends StatefulWidget {
  final Token token;

  HomeScreen({required this.token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ENCUESTA',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.purple.shade200
      ),
      body: _getBody(), 
      drawer: widget.token.user.userType == 0 
      ?  _getUserMenu() : _getCustomerMenu(),
      backgroundColor: Colors.pink.shade50,
    );
  }

Widget _getBody() {
  final TextStyle headline4 = Theme.of(context).textTheme.headline4!;
   return  SingleChildScrollView(
   child: Container(
  margin: EdgeInsets.all(30),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
         borderRadius: BorderRadius.circular(150),
         child:  FadeInImage(
          placeholder: AssetImage('assets/logo.png'), 
          image: NetworkImage(widget.token.user.imageFullPath),
          height: 300,
          fit: BoxFit.cover,
         ),
       ),
         SizedBox(height: 30,),
      Center(
   child: Text( 'Bienvenid@ ${widget.token.user.fullName}',

 style: GoogleFonts.lato(
        textStyle: Theme.of(context).textTheme.headline4,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.italic,
      ),),
 ),

 SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Llamar',
            //  style: GoogleFonts.oswald(textStyle: headline4),),
           style: GoogleFonts.lato(
        textStyle: Theme.of(context).textTheme.headline4,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.italic,
      ),),
              SizedBox(width: 10,),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 40,
                  width: 40,
                  color: Colors.blue,
                  child: IconButton(
                    icon: Icon(Icons.call, color: Colors.white,),
                    onPressed: () => launch("tel://+573148795829"), 
                  ),
                ),
              )
            ],
          ), 

           SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Enviar mensaje',
              style: GoogleFonts.lato(
              textStyle: Theme.of(context).textTheme.headline4,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
      ),
              ),
              SizedBox(width: 10,),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 40,
                  width: 40,
                  color: Colors.green,
                  child: IconButton(
                    icon: Icon(Icons.insert_comment, color: Colors.white,),
                    onPressed: () => _sendMessage(), 
                  ),
                ),
              )
            ],
          ), 
      ],
    ),
  )
   );
}

  Widget _getUserMenu() {
    return Drawer(
    child: Container(
      color: Colors.pink.shade50,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Image(
              image: AssetImage('assets/logo.png'),
              
            ),

            ),

     ListTile(
            leading: Icon(Icons.logout),
            title: Text("Encuesta",
               style: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),),
            onTap: () { 
               Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                builder: (context) => LoginScreen()
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Cerrar Sesión",
               style: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),),
            onTap: () { 
               Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                builder: (context) => LoginScreen()
                ),
              );
            },
          ),
        ],
        
      ),
    ),
    );
    
  }
Widget _getCustomerMenu() {
     return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Image(
              image: AssetImage('assets/logo.png'),
            ),
            ),
            ListTile(
              leading: Icon(Icons.store),
              title: Text("Encuesta",
               style: GoogleFonts.lato(
              textStyle: Theme.of(context).textTheme.headline4,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
             ),),
              onTap: () {},
            ),
              Divider(
            color: Colors.black, 
            height: 2,
          ),
                ListTile(
            leading: Icon(Icons.logout),
            title: Text("Encuesta",
               style: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),),
            onTap: () { 
               Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                builder: (context) => LoginScreen()
                ),
              );
            },
          ),
            ListTile(
            leading: Icon(Icons.logout),
            title: Text("Cerrar Sesión",
               style: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),),
            onTap: () { 
               Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                builder: (context) => LoginScreen()
                ),
              );
            },
          ),
        ],
      ),
    );
  }
   void _sendMessage() async {
    final link = WhatsAppUnilink(
      phoneNumber: '+573148795829',
      text: 'Hola soy ${widget.token.user.fullName} cliente',
    );
    await launch('$link');
  }
}