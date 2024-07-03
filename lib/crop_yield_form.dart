import 'package:flutter/material.dart';

class CropYieldForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit; // Callback for user input

  const CropYieldForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<CropYieldForm> createState() => _CropYieldFormState();
}

class _CropYieldFormState extends State<CropYieldForm> {
  final _formKey = GlobalKey<FormState>();
  String _cropType = '';
  double _temperature = 0.0;
  double _rainfall = 0.0;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: _cropType,
            items: const [
              DropdownMenuItem(
                value: 'Wheat',
                child: Text('Wheat'),
              ),
              DropdownMenuItem(
                value: 'Corn',
                child: Text('Corn'),
              ),
              // Add more crop options
            ],
            onChanged: (value) => setState(() => _cropType = value!),
            validator: (value) => value == null ? 'Please select a crop' : null,
            decoration: const InputDecoration(labelText: 'Crop Type'),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Temperature (°C)'),
            keyboardType: TextInputType.number,
            validator: (value) => (value == null || value.isEmpty)
                ? 'Please enter temperature'
                : null,
            onSaved: (value) =>
                setState(() => _temperature = double.parse(value!)),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Rainfall (mm)'),
            keyboardType: TextInputType.number,
            validator: (value) => (value == null || value.isEmpty)
                ? 'Please enter rainfall'
                : null,
            onSaved: (value) =>
                setState(() => _rainfall = double.parse(value!)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                final userInput = {
                  'cropType': _cropType,
                  'temperature': _temperature,
                  'rainfall': _rainfall,
                  // Add more user input fields if needed
                };
                widget.onSubmit(userInput); // Call the callback with user input
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
