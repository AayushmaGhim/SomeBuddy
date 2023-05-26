import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MLIntegrationApp extends StatefulWidget {
  @override
  _MLIntegrationAppState createState() => _MLIntegrationAppState();
}

class _MLIntegrationAppState extends State<MLIntegrationApp> {
  String predictionResult = '';

  Future<void> makePrediction() async {
    final apiUrl = '';
    
    // Example data to send for prediction
    final data = {'input': 'example_input_data'};

    final response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data));

    if (response.statusCode == 200) {
      final prediction = json.decode(response.body)['predictions'];
      setState(() {
        predictionResult = prediction.toString();
      });
    } else {
      setState(() {
        predictionResult = 'Prediction failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('ML Integration App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: makePrediction,
                child: Text('Make Prediction'),
              ),
              SizedBox(height: 20),
              Text('Prediction Result: $predictionResult'),
            ],
          ),
        ),
      ),
    );
  }
}
