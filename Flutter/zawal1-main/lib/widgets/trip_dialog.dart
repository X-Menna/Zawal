import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../constants/app_textstyles.dart';
import '../widgets/custom_button.dart';
import '../cubits/trip_cubit.dart';
import '../models/trip_model.dart';

class TripDialog extends StatefulWidget {
  const TripDialog({super.key});

  @override
  State<TripDialog> createState() => _TripDialogState();
}

class _TripDialogState extends State<TripDialog> {
  final _formKey = GlobalKey<FormState>();
  final _destinationController = TextEditingController();
  final _budgetController = TextEditingController();
  bool _isSolo = false;
  DateTime? _startDate, _endDate;
  String _tripType = 'Relaxation';
  List<String> _feelings = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Trip Details', style: AppTextStyles.heading),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_destinationController, 'Destination'),
              _buildSwitch(),
              _buildDatePickers(),
              _buildTextField(_budgetController, 'Budget', isNumber: true),
              _buildDropdown(),
              _buildFeelings(),
            ],
          ),
        ),
      ),
      actions: [
        CustomButton(
          text: 'Generate',
          onPressed: () {
            if (_formKey.currentState!.validate() &&
                _startDate != null &&
                _endDate != null) {
              final model = TripModel(
                destination: _destinationController.text,
                isSolo: _isSolo,
                startDate: _startDate!,
                endDate: _endDate!,
                budget: double.parse(_budgetController.text),
                tripType: _tripType,
                feelings: _feelings,
              );
              context.read<TripCubit>().submitTrip(model);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) => value!.isEmpty ? 'Required' : null,
    );
  }

  Widget _buildSwitch() {
    return SwitchListTile(
      value: _isSolo,
      title: const Text('Traveling Solo?'),
      onChanged: (val) => setState(() => _isSolo = val),
    );
  }

  Widget _buildDatePickers() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: () => _pickDate(isStart: true),
          child: Text(
            _startDate == null
                ? 'Start Date'
                : _startDate!.toString().split(' ')[0],
          ),
        ),
        TextButton(
          onPressed: () => _pickDate(isStart: false),
          child: Text(
            _endDate == null ? 'End Date' : _endDate!.toString().split(' ')[0],
          ),
        ),
      ],
    );
  }

  void _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        isStart ? _startDate = picked : _endDate = picked;
      });
    }
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _tripType,
      items:
          ['Relaxation', 'Adventure', 'Cultural', 'Romantic']
              .map((type) => DropdownMenuItem(value: type, child: Text(type)))
              .toList(),
      onChanged: (val) => setState(() => _tripType = val!),
    );
  }

  Widget _buildFeelings() {
    return Column(
      children:
          ['Relaxed', 'Adventurous', 'Inspired']
              .map(
                (feeling) => CheckboxListTile(
                  value: _feelings.contains(feeling),
                  title: Text(feeling),
                  onChanged: (val) {
                    setState(() {
                      val! ? _feelings.add(feeling) : _feelings.remove(feeling);
                    });
                  },
                ),
              )
              .toList(),
    );
  }
}
