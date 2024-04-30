import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InferencePage extends StatefulWidget {
  final String requestId;

  const InferencePage({Key? key, required this.requestId}) : super(key: key);

  @override
  _InferencePageState createState() => _InferencePageState();
}

class _InferencePageState extends State<InferencePage> {
  String _output = '';
  bool _isLoading = false;

  Future<void> generateLetter(String requestId) async {
    setState(() {
      _isLoading = true;
    });

    final url = 'https://us-central1-referency-79556.cloudfunctions.net/hackathon?request_id=$requestId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        _output = response.body;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to generate Letter');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated Inference'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          generateLetter(widget.requestId);
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Generate Letter'),
                ),
                const SizedBox(height: 20),
                Text('Output: $_output'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
