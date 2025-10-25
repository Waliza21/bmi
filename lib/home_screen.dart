import 'package:flutter/material.dart';

enum HeightType { cm, feetInch }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HeightType heightType = HeightType.cm;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BMI Calculator')),

      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Weight (KG)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Height Unit',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SegmentedButton<HeightType>(
            segments: [
              const ButtonSegment<HeightType>(
                value: HeightType.cm,
                label: Text("CM"),
              ),
              const ButtonSegment<HeightType>(
                value: HeightType.feetInch,
                label: Text("Feet/Inch"),
              ),
            ],
            selected: {heightType},
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Weight (KG)',
              border: OutlineInputBorder(),
            ),
          ),
          ElevatedButton(onPressed: () {}, child: Text('Show Result')),
        ],
      ),
    );
  }
}
