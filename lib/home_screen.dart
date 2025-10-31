import 'package:flutter/material.dart';

enum HeightType { cm, m, feetInch }

enum WeightType { kg, lb }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HeightType heightType = HeightType.cm;
  WeightType weightType = WeightType.kg;

  final kgCtr = TextEditingController();
  final lbCtr = TextEditingController();
  final cmCtr = TextEditingController();
  final mCtr = TextEditingController();
  final feetCtr = TextEditingController();
  final inchCtr = TextEditingController();

  String _bmiResult = "";
  String? category;

  String categoryResult(double bmi) {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Normal";
    if (bmi < 30) return "Overweight";
    return "Obese";
  }

  double? lbToKg() {
    final lb = double.tryParse(lbCtr.text.trim());
    if (lb == null || lb <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide valid pound value')),
      );
      return null;
    }
    return lb * 0.453592;
  }

  //1m = 100 cm
  double? cmToM() {
    final cm = double.tryParse(cmCtr.text.trim());
    if (cm == null || cm <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please provide valid cm value')));
      return null;
    }

    return cm / 100.0;
  }

  //1 inch= 0.0254m
  double? feetInchToM() {
    var feet = double.tryParse(feetCtr.text.trim());
    var inch = double.tryParse(inchCtr.text.trim());

    if (feet == null || feet <= 0 || inch == null || inch <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid Value')));
      return null;
    }
    if (inch >= 12) {
      feet += 1;
      inch = inch - 12;
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
    final weight =
        weightType == WeightType.kg
            ? double.tryParse(kgCtr.text.trim())
            : lbToKg();

    if (weight == null || weight <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid Value')));
      return;
    }

    final height =
        heightType == HeightType.cm
            ? cmToM()
            : heightType == HeightType.m
            ? double.tryParse(mCtr.text.trim())
            : feetInchToM();
    if (height == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid Value')));
      return;
    }
    final bmi = weight / (height * height);
    final cat = categoryResult(bmi);

    setState(() {
      _bmiResult = bmi.toStringAsFixed(1);
      category = cat;
    });
    cmCtr.clear();
    mCtr.clear();
    feetCtr.clear();
    inchCtr.clear();
    kgCtr.clear();
    lbCtr.clear();
  }

  @override
  void dispose() {
    kgCtr.dispose();
    lbCtr.dispose();
    cmCtr.dispose();
    mCtr.dispose();
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
          Text(
            'Weight Unit',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SegmentedButton<WeightType>(
            segments: [
              const ButtonSegment<WeightType>(
                value: WeightType.kg,
                label: Text("KG"),
              ),
              const ButtonSegment<WeightType>(
                value: WeightType.lb,
                label: Text("LB"),
              ),
            ],
            selected: {weightType},
            onSelectionChanged:
                (value) => setState(() => weightType = value.first),
          ),
          if (weightType == WeightType.kg) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: kgCtr,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'KG',
                border: OutlineInputBorder(),
              ),
            ),
          ] else ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: lbCtr,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: "LB",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ],
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
                value: HeightType.m,
                label: Text("M"),
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
              controller: cmCtr,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Height (cm)',
                border: OutlineInputBorder(),
              ),
            ),
          ] else if (heightType == HeightType.m) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: mCtr,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Height (m)',
                border: OutlineInputBorder(),
              ),
            ),
          ] else ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: feetCtr,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: "Feet(')",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: inchCtr,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
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

          // TextFormField(
          //   controller: weightCtr,
          //   decoration: InputDecoration(
          //     labelText: 'Weight (KG)',
          //     border: OutlineInputBorder(),
          //   ),
          // ),
          // const SizedBox(height: 16),
          ElevatedButton(onPressed: _calculate, child: Text('Show Result')),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                Text('Result: $_bmiResult'),
                const SizedBox(height: 16),
                Text(
                  'Category: $category',
                  style: TextStyle(
                    backgroundColor:
                        category == 'Underweight'
                            ? Colors.blue
                            : category == 'Normal'
                            ? Colors.green
                            : category == 'Overweight'
                            ? Colors.orange
                            : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
