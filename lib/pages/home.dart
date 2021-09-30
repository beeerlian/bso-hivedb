import 'package:flutter_hivedb/model/task.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  Box<dynamic>? homebox;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    Hive.openBox('TaskBox').then((value) => widget.homebox = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          widget.homebox!.add(Task.toJson(Task("Belajar", "Belajar flutter")));
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder(
        future: Hive.openBox('TaskBox'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error Bos"),
            );
          } else {
            return WatchBoxBuilder(
                box: widget.homebox as dynamic,
                builder: (context, myBox) {
                  return ListView.builder(
                      itemCount: myBox.length,
                      itemBuilder: (context, index) {
                        return _buildTask(index, myBox.getAt(index));
                      });
                });
          }
        });
  }

  Widget _buildTask(int index, var box) {
    Task task = Task.fromJson(
        {"title": box['title'], "desc": box['desc'], "isDone": box['isDone']});
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListTile(
          title: Text(task.title),
          subtitle: Text(task.desc),
          leading: Checkbox(value: task.isDone, onChanged: (value) {
            task.isDone = !task.isDone;
            widget.homebox!.putAt(index, Task.toJson(task));
          },),
          trailing: IconButton(icon: Icon(Icons.delete),onPressed:(){
            widget.homebox!.deleteAt(index);
          } ,),
        ));
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("myAgenda"),
    );
  }
}
