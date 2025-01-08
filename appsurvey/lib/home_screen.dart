import 'package:flutter/material.dart';
import 'question_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '📝',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Text(
              'KHẢO SÁT',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onPrimaryFixedVariant),
            ),
            ElevatedButton(
              onPressed: () {
                // Show the question screen to start the game
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return QuestionScreen();
                    },
                  ),
                );
              },
              child: Text('Bắt đầu'),
            ),
          ],
        ),
      ),
    );
  }
}
