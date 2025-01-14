import 'package:flutter/material.dart';

class ModifirePage extends StatefulWidget {
  const ModifirePage({super.key});

  @override
  State<ModifirePage> createState() => _ModifirePageState();
}

class _ModifirePageState extends State<ModifirePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("MENU PAGE"),
      ),
    );
  }
}
