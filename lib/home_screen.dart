import 'package:flutter/material.dart';

enum HeightType { cm, feetInch }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HeightType heightType = HeightType.cm;

  final weightCtr = TextEditingController();
  final cmCtr = TextEditingController();
  final feetCtr = TextEditingController();
  final inchCtr = TextEditingController();

  //1m = 100 cm
  double? cmToM() {
    final cm = double.tryParse(cmCtr.text.trim());
    if (cm == null || cm <= 0) return null;

    return cm / 100.0;
  }

  //1 inch= 0.0254m
  double? feetInchToM() {
    final feet = double.tryParse(feetCtr.text.trim());
    final inch = double.tryParse(inchCtr.text.trim());
    if (feet == null || feet <= 0 || inch == null || inch <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid Value')));
      return null;
    }
    final totalInch = feet * 12 + inch;
    if (totalInch <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid Value')));
      return null;
    }
    return totalInch * 0.0254;
  }

  void _calculate() {
    final weight = double.tryParse(weightCtr.text.trim());
  }

  @override
  void dispose() {
    weightCtr.dispose();
    cmCtr.dispose();
    feetCtr.dispose();
    inchCtr.dispose();
  }

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
            onSelectionChanged:
                (value) => setState(() => heightType = value.first),
          ),
          if (heightType == HeightType.cm) ...[
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Height (cm)',
                border: OutlineInputBorder(),
              ),
            ),
          ] else ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Feet(')",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Inch (")',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),

          TextFormField(
            decoration: InputDecoration(
              labelText: 'Weight (KG)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          ElevatedButton(onPressed: () {}, child: Text('Show Result')),
          const SizedBox(height: 16),
          Text('Result'),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
