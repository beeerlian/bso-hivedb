import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hivedb/model/task.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  Box<dynamic>? box;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    openMyBox().then((value) => widget.box = value);
    super.initState();
  }

  Future<Box<dynamic>> openMyBox() async {
    return await Hive.openBox("TasksBox");
  }

  @override
  Widget build(BuildContext context) {
    log("All widget build");
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          widget.box!.add(Task.toJson(
              Task("Belajar", "Belajar menstore data dengan hive")));
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<Box<dynamic>>(
        future: Hive.openBox("TasksBox"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          } else {
            widget.box = snapshot.data;
            // ignore: deprecated_member_use
            return WatchBoxBuilder(
                box: widget.box as dynamic,
                builder: (context, mybox) {
                  log("WatchBox build");
                  return mybox.isEmpty
                      ? const Center(child: Text("Data kosong"))
                      : ListView.builder(
                          itemCount: mybox.length,
                          itemBuilder: (context, index) =>
                              _buildTask(index, mybox.getAt(index)));
                });
          }
        });
  }

  Widget _buildTask(int index, var box) {
    log(box.toString());

    Task task = Task.fromJson(
        {"title": box['title'], "desc": box['desc'], "isDone": box['isDone']});
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListTile(
          title: Text(task.title),
          subtitle: Text(task.desc),
          leading: Checkbox(
            value: task.isDone,
            onChanged: (value) {
              task.isDone = !task.isDone;
              widget.box!.putAt(index, Task.toJson(task));
            },
          ),
          trailing: IconButton(
              onPressed: () {
                widget.box!.deleteAt(index);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              )),
        ));
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("myAgenda"),
    );
  }
}
