import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(CropYieldApp());
}

class CropYieldApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crop Yield Prediction',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: CropYieldScreen(),
    );
  }
}

class CropYieldScreen extends StatefulWidget {
  const CropYieldScreen({super.key});

  @override
  _CropYieldScreenState createState() => _CropYieldScreenState();
}

class _CropYieldScreenState extends State<CropYieldScreen> {
  // Define variables to store input data
  double? rainfall;
  double? fertilizer;
  double? temperature;
  double? nitrogen;
  double? phosphorus;
  double? potassium;

  // Function to submit the data
  Future<void> submitData() async {
    final response = await http.post(
      Uri.parse('https://crop-yield-prediction-backend.onrender.com/predict'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'rainfall': rainfall,
        'fertilizer': fertilizer,
        'temperature': temperature,
        'nitrogen': nitrogen,
        'phosphorus': phosphorus,
        'potassium': potassium,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final predictedYield = jsonResponse['predicted_yield'];

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Predicted Crop Yield'),
            content: Text('Q/acre: $predictedYield'),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to get the prediction'),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crop Yield Prediction',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Enter Crop'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter Rain Fall (mm)'),
              onChanged: (value) {
                setState(() {
                  rainfall = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Enter Fertilizer (Kg)'),
              onChanged: (value) {
                setState(() {
                  fertilizer = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Enter Temperatue (in ℃)'),
              onChanged: (value) {
                setState(() {
                  temperature = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Enter Nitrogen (in mEq/L)'),
              onChanged: (value) {
                setState(() {
                  nitrogen = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Enter Phosphorus (in mEq/L)'),
              onChanged: (value) {
                setState(() {
                  phosphorus = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Enter Potassium (in mEq/L)'),
              onChanged: (value) {
                setState(() {
                  potassium = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: submitData,
              child: const Text('Predict'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('rainfall', rainfall));
  }
}
