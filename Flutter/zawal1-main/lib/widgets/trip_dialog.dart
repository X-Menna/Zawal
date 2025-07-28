import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawal/screens/reccomendation_screen.dart';
import '../constants/app_textstyles.dart';
import '../cubits/trip_cubit.dart';
import '../models/trip_model.dart';

class TripDialog extends StatefulWidget {
  const TripDialog({super.key});

  @override
  State<TripDialog> createState() => _TripDialogState();
}

class _TripDialogState extends State<TripDialog> {
  final _formKey = GlobalKey<FormState>();
  final _countryController = TextEditingController();
  final _budgetController = TextEditingController();
  final _ageController = TextEditingController();

  String _language = 'English';
  bool _isSolo = true;
  String? _groupType;
  String _season = 'Spring';
  String _activity = '';

  final Map<String, List<String>> _seasonActivities = {
    'Spring': ['Hiking', 'Ballooning', 'Gardens', 'Yoga', 'Festivals'],
    'Summer': ['Island Hopping', 'Snorkeling', 'Cruises', 'Concerts', 'Markets'],
    'Fall': ['Retreats', 'Cycling', 'Pumpkin Farms', 'Workshops', 'City Tours'],
    'Winter': ['Auroras', 'Spas', 'Snow Villages', 'Safaris', 'Christmas Markets'],
  };

  @override
  void initState() {
    super.initState();
    _activity = _seasonActivities[_season]!.first;
  }

  @override
  void dispose() {
    _countryController.dispose();
    _budgetController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TripCubit, TripState>(
      listener: (context, state) {
        if (state is TripSuccess) {
          Navigator.of(context).pop(); // close the dialog
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecommendationScreen(response: state.responseData!),
            ),
          );
        } else if (state is TripFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${state.error}")),
          );
        }
      },
      child: AlertDialog(
        title: Text('Trip Details', style: AppTextStyles.heading),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(_countryController, 'Country'),
                _buildLanguageDropdown(),
                _buildSoloSwitch(),
                if (!_isSolo) _buildGroupTypeDropdown(),
                _buildSeasonDropdown(),
                _buildActivityDropdown(),
                _buildTextField(_budgetController, 'Budget', isNumber: true),
                _buildTextField(_ageController, 'Age', isNumber: true),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final trip = TripModel(
                  destination: _countryController.text,
                  language: _language,
                  isSolo: _isSolo,
                  season: _season,
                  budget: int.tryParse(_budgetController.text) ?? 0,
                  activity: _activity,
                  age: int.tryParse(_ageController.text) ?? 0,
                );
                context.read<TripCubit>().submitTrip(trip);
              }
            },
            child: const Text("Generate"),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) => value!.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return DropdownButtonFormField<String>(
      value: _language,
      items: ['English', 'Arabic', 'Spanish', 'French', 'Japanese']
          .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
          .toList(),
      onChanged: (val) => setState(() => _language = val!),
      decoration: const InputDecoration(labelText: 'Language'),
    );
  }

  Widget _buildSoloSwitch() {
    return SwitchListTile(
      value: _isSolo,
      title: const Text('Traveling Solo?'),
      onChanged: (val) => setState(() => _isSolo = val),
    );
  }

  Widget _buildGroupTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _groupType,
      items: ['Family', 'Family with Kids']
          .map((type) => DropdownMenuItem(value: type, child: Text(type)))
          .toList(),
      onChanged: (val) => setState(() => _groupType = val),
      decoration: const InputDecoration(labelText: 'Group Type'),
    );
  }

  Widget _buildSeasonDropdown() {
    return DropdownButtonFormField<String>(
      value: _season,
      items: _seasonActivities.keys
          .map((season) => DropdownMenuItem(value: season, child: Text(season)))
          .toList(),
      onChanged: (val) {
        setState(() {
          _season = val!;
          _activity = _seasonActivities[_season]!.first;
        });
      },
      decoration: const InputDecoration(labelText: 'Season'),
    );
  }

  Widget _buildActivityDropdown() {
    return DropdownButtonFormField<String>(
      value: _activity,
      items: _seasonActivities[_season]!
          .map((act) => DropdownMenuItem(value: act, child: Text(act)))
          .toList(),
      onChanged: (val) => setState(() => _activity = val!),
      decoration: const InputDecoration(labelText: 'Activity'),
    );
  }
}



