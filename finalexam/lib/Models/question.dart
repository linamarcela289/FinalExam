import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:finalexam/Models/finals.dart';
import 'package:finalexam/Models/response.dart';
import 'package:finalexam/Models/token.dart';
import 'package:finalexam/components/loader_component.dart';
import 'package:finalexam/helpers/api_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionScreen extends StatefulWidget {
  
final Token token;

  QuestionScreen({required this.token});

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  @override
bool _showLoader = false;

late Finals _final = Finals(id: 0, date: '', email: '', 
qualification: 0, remarks: '', 
theBest: '', theWorst: '',  );
  int _id = 0;
  String _date = '';
  String _email = '';
  int _qualification = 0;
  String _theBest = '';
  String _theWorst = '';
  String _remarks = '';

  String _dateError = '';
  bool _dateShowError = false;

  String _emailError = '';
  bool _emailShowError = false;

  String _qualificationtError = '';
  bool _qualificationShowError = false;

   String _theBestError = '';
  bool _theBestShowError = false;

     String _theWorsttError = '';
  bool _theWorstShowError = false;

   String _remaskError = '';
  bool _remaskShowError = false;

  String _IdError = '';
  bool _IdShowError = false;

 
  TextEditingController _remaskController = TextEditingController();
  TextEditingController _theWorsttController = TextEditingController();
  TextEditingController _theBestController = TextEditingController();
  TextEditingController _qualificationtController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

   @override
  void initState() {
    super.initState();
    _getFinals();
    _id = _final.id;
   
    _remarks = _final.remarks;
   _remaskController.text = _remarks;

    _theBest = _final.theBest;
    _theBestController.text = _theBest;

      _theWorst= _final.theWorst;
    _theWorsttController.text = _theWorst;

    _email = _final.email;
    _emailController.text = _email;

     _date = _final.date;
    _dateController.text = _date;

    _qualification = _final.qualification;

  }

  @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade200,
        title: Text(
          _final.id == 0 
            ? 'Nuevo ' 
            : _final.email,
          style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child : 
          Column(
            children: <Widget>[
              _showRemask(),
              _showemail(),
              _showqualification(),
              _showtheBest(),
              _showtheWorst(),
              _showButtons(),

            ],
          ),
          ),
          _showLoader ? LoaderComponent(text: 'Por favor espere...',) : Container(),
        ],
      ),
      backgroundColor: Colors.pink.shade50,
    );
  }
   
   Widget _showRemask() {
    return Container(
      padding: EdgeInsets.all(30),
      child: TextField(
        controller: _remaskController,
        decoration: InputDecoration(
          hintText: 'Ingresar Comentarios generales...',
          labelText: 'Comentarios',
          errorText: _remaskShowError ? _remaskError : null,
          suffixIcon: Icon(Icons.description),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _remarks = value;
        },
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

      Future<Null> _getFinals() async {
      setState(() {
      _showLoader = true;
      });
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
      setState(() {
      _showLoader = false;
      });
      await showAlertDialog(
      context: context,
      title: 'Error',
      message: 'Verifica que estes conectado a internet.',
      actions: <AlertDialogAction>[
      AlertDialogAction(key: null, label: 'Aceptar'),
      ]
      );
      return;
      }
      Response response = await ApiHelper.getFinals(widget.token);
      setState(() {
      _showLoader = false;
      });
      if (!response.isSuccess) {
      await showAlertDialog(
      context: context,
      title: 'Error',
      message: response.message,
      actions: <AlertDialogAction>[
      AlertDialogAction(key: null, label: 'Aceptar'),
      ]
      );
      return;
      }

setState(() {
 _final = response.result;
});
}

 Widget _showButtons() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              
              child: Text('Guardar'),
              
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Colors.blue.shade800;
                  }
                ),
              ),
              onPressed: () => _save(), 
            ),
          ),
          _final.id == 0 
            ? Container() 
            : SizedBox(width: 20,),
        ],
      ),
    );
  }

  void _save() {
    if (!_validateFields()) {
      return;
    }

    _addRecord();
  }
_addRecord() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: 'Verifica que estes conectado a internet.',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    Map<String, dynamic> request = {
    'email': _email,
    'qualification': _qualification,
    'theBest': _theBest,
    'theWorst': _theWorst,
    'remarks': _remarks
    };

    Response response = await ApiHelper.post(
      '/api/Finals/', 
      request, 
      widget.token
    );

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: response.message,
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    Navigator.pop(context, 'yes');
  }

 
    bool _validateFields() {
    bool isValid = true;

    if (_remarks.isEmpty) {
      isValid = false;
      _remaskShowError = true;
      _remaskError = 'Debes ingresar una descripción.';
    } else {
      _remaskShowError = false;
    }
    setState(() { });
    return isValid;
  }

  _showemail() {
 return Container(
      padding: EdgeInsets.all(30),
      child: TextField(
        controller: _emailController,
        decoration: InputDecoration(
          hintText: 'Ingresa un email...',
          labelText: 'Email',
          errorText: _emailShowError ? _emailError : null,
          suffixIcon: Icon(Icons.description),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _email = value;
        },
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      ),
    );

  }

  _showqualification() {
    return Container(
      padding: EdgeInsets.all(30),
      child: TextField(
        controller: _qualificationtController,
        decoration: InputDecoration(
          hintText: 'Ingresa una calificación...',
          labelText: 'Calificación',
          errorText: _qualificationShowError ? _qualificationtError : null,
          suffixIcon: Icon(Icons.description),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _remarks = value;
        },
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  _showtheBest() {
    return Container(
      padding: EdgeInsets.all(30),
      child: TextField(
        controller: _theBestController,
        decoration: InputDecoration(
          hintText: 'Ingrese Lo que más te gustó del curso',
          labelText: 'Lo que me gusto',
          errorText: _theBestShowError ? _theBestError : null,
          suffixIcon: Icon(Icons.description),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _theBest = value;
        },
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  _showtheWorst() {
    return Container(
      padding: EdgeInsets.all(30),
      child: TextField(
        controller: _theWorsttController,
        decoration: InputDecoration(
          hintText: 'Ingresa Lo que menos me gustó del curso..',
          labelText: 'Lo que no me gusto ',
          errorText: _theWorstShowError ? _theWorsttError : null,
          suffixIcon: Icon(Icons.description),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _theWorst = value;
        },
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

}