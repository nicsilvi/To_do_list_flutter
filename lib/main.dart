import 'package:flutter/material.dart';
import 'package:primera_app/text_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Primera app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Home Page'), //llamamos a MyH.. con title
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title}); //required title

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Map<String, dynamic>> tasks = []; //lista de map con clave-valor
  //map clave: string y valor: sin especificar, llamando a tasks.add({c:c, v:v}) puedo añadir los parametros que quiera

  void _saveTextInput() {
    showDialog(
      context: context,
      builder: (context) {
        return TextDialog(
          onPressedOnSubmt: (text) {
            setState(() {
              tasks.add({'task': text, 'completed': false});
            });
          },
        );
      },
    );
  }

  void _deleteTextInput() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Choose a task: "),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                tasks.asMap().entries.map((entry) {
                  //itera añadiendo un index, devuelde en entries clave:valor y se itera en map(entry)
                  int index =
                      entry.key; //extrae index y taskName por cada map(entry)
                  String taskName = entry.value['task'];

                  return ListTile(
                    //esto es lo que se verá, con el texto de la lista
                    trailing: Icon(Icons.delete, color: Colors.red),
                    title: Text(taskName),
                    onTap: () {
                      Navigator.pop(
                        context,
                      ); // Cierra el primer pop-up y llama a confirmDelete
                      _confirmDelete(index);
                    },
                  );
                }).toList(),
          ),
        );
      },
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Do you want to delete '${tasks[index]['task']}'?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancelar
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  tasks.removeAt(index);
                  _updateCounter();
                });
                Navigator.pop(context); // Cierra el diálogo de confirmación
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _updateCounter() {
    //puedo acceder a _counter pq forma parte de la clase donde esta mi función
    //estructura para iterar en Dart (.where cuenta las ocurrencias)
    _counter = tasks.where((task) => task['completed'] == true).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.amber, title: Text(widget.title)),
      body: Container(
        color: Colors.blueGrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'To do list:',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      backgroundColor: Colors.black26,
                      color: Colors.amber,
                      fontSize: 30,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _saveTextInput();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                  ),
                  child: Text("Add task"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _deleteTextInput();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                  ),
                  child: Text("Delete task"),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text(
                    'Tasks done: $_counter',
                    style: TextStyle(
                      fontSize: 24, // Tamaño del texto
                      fontWeight: FontWeight.bold, // Negrita
                      color: Colors.amber, // Color del texto
                      letterSpacing: 2.0, // Espaciado entre letras
                      shadows: [
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 3.0,
                          color: Colors.black,
                        ),
                      ], // Sombra en el texto
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
              child: Container(
                padding: EdgeInsets.all(90.0),
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black), // Borde negro
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value:
                                tasks[index]['completed'], //guardo en value lo que tenia en taskX
                            onChanged: (bool? value) {
                              setState(() {
                                tasks[index]['completed'] =
                                    value ?? false; // Actualiza el estado
                                _updateCounter();
                              });
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ), // Espacio entre el checkbox y el texto
                          Text(
                            tasks[index]['task'],
                          ), // Muestra el nombre de la tarea
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
