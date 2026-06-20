import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers numerik
  final _accountLength = TextEditingController(text: '128');
  final _numberVmailMessages = TextEditingController(text: '25');
  final _totalDayMinutes = TextEditingController(text: '265.1');
  final _totalDayCalls = TextEditingController(text: '110');
  final _totalDayCharge = TextEditingController(text: '45.07');
  final _totalEveMinutes = TextEditingController(text: '197.4');
  final _totalEveCalls = TextEditingController(text: '99');
  final _totalEveCharge = TextEditingController(text: '16.78');
  final _totalNightMinutes = TextEditingController(text: '244.7');
  final _totalNightCalls = TextEditingController(text: '91');
  final _totalNightCharge = TextEditingController(text: '11.01');
  final _totalIntlMinutes = TextEditingController(text: '10.0');
  final _totalIntlCalls = TextEditingController(text: '3');
  final _totalIntlCharge = TextEditingController(text: '2.70');
  final _customerServiceCalls = TextEditingController(text: '1');

  // Dropdown
  String _internationalPlan = 'No';
  String _voiceMailPlan = 'Yes';

  @override
  void dispose() {
    _accountLength.dispose();
    _numberVmailMessages.dispose();
    _totalDayMinutes.dispose();
    _totalDayCalls.dispose();
    _totalDayCharge.dispose();
    _totalEveMinutes.dispose();
    _totalEveCalls.dispose();
    _totalEveCharge.dispose();
    _totalNightMinutes.dispose();
    _totalNightCalls.dispose();
    _totalNightCharge.dispose();
    _totalIntlMinutes.dispose();
    _totalIntlCalls.dispose();
    _totalIntlCharge.dispose();
    _customerServiceCalls.dispose();
    super.dispose();
  }

  Future<void> _predict() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final input = {
        'account_length': int.parse(_accountLength.text),
        'number_vmail_messages': int.parse(_numberVmailMessages.text),
        'total_day_minutes': double.parse(_totalDayMinutes.text),
        'total_day_calls': int.parse(_totalDayCalls.text),
        'total_day_charge': double.parse(_totalDayCharge.text),
        'total_eve_minutes': double.parse(_totalEveMinutes.text),
        'total_eve_calls': int.parse(_totalEveCalls.text),
        'total_eve_charge': double.parse(_totalEveCharge.text),
        'total_night_minutes': double.parse(_totalNightMinutes.text),
        'total_night_calls': int.parse(_totalNightCalls.text),
        'total_night_charge': double.parse(_totalNightCharge.text),
        'total_intl_minutes': double.parse(_totalIntlMinutes.text),
        'total_intl_calls': int.parse(_totalIntlCalls.text),
        'total_intl_charge': double.parse(_totalIntlCharge.text),
        'customer_service_calls': int.parse(_customerServiceCalls.text),
        'international_plan': _internationalPlan,
        'voice_mail_plan': _voiceMailPlan,
      };

      final result = await ApiService.predict(input);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(data: result['data']),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isDouble = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF1565C0)),
          ),
        ),
        validator: (v) {
          if (v == null || v.isEmpty) return 'Required';
          if (isDouble) {
            if (double.tryParse(v) == null) return 'Enter valid number';
          } else {
            if (int.tryParse(v) == null) return 'Enter valid integer';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> options,
      void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        dropdownColor: const Color(0xFF1A1A1A),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
        items: options
            .map((o) => DropdownMenuItem(value: o, child: Text(o)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Churn Prediction',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF111111),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Customer Data',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 16),

              _buildTextField('Account Length', _accountLength),
              _buildTextField('Number Vmail Messages', _numberVmailMessages),
              _buildTextField('Customer Service Calls', _customerServiceCalls),

              const Divider(color: Colors.grey),
              const Text('Day Calls',
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 8),
              _buildTextField('Total Day Minutes', _totalDayMinutes, isDouble: true),
              _buildTextField('Total Day Calls', _totalDayCalls),
              _buildTextField('Total Day Charge', _totalDayCharge, isDouble: true),

              const Divider(color: Colors.grey),
              const Text('Evening Calls',
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 8),
              _buildTextField('Total Eve Minutes', _totalEveMinutes, isDouble: true),
              _buildTextField('Total Eve Calls', _totalEveCalls),
              _buildTextField('Total Eve Charge', _totalEveCharge, isDouble: true),

              const Divider(color: Colors.grey),
              const Text('Night Calls',
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 8),
              _buildTextField('Total Night Minutes', _totalNightMinutes, isDouble: true),
              _buildTextField('Total Night Calls', _totalNightCalls),
              _buildTextField('Total Night Charge', _totalNightCharge, isDouble: true),

              const Divider(color: Colors.grey),
              const Text('International Calls',
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 8),
              _buildTextField('Total Intl Minutes', _totalIntlMinutes, isDouble: true),
              _buildTextField('Total Intl Calls', _totalIntlCalls),
              _buildTextField('Total Intl Charge', _totalIntlCharge, isDouble: true),

              const Divider(color: Colors.grey),
              const Text('Plans',
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 8),
              _buildDropdown('International Plan', _internationalPlan, ['Yes', 'No'],
                  (v) => setState(() => _internationalPlan = v!)),
              _buildDropdown('Voice Mail Plan', _voiceMailPlan, ['Yes', 'No'],
                  (v) => setState(() => _voiceMailPlan = v!)),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _predict,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.bolt),
                  label: Text(_isLoading ? 'Predicting...' : 'RUN PREDICTION'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}