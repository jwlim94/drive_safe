import 'package:flutter/material.dart';

class AppStartupLoadingStateWidget extends StatelessWidget {
  const AppStartupLoadingStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
