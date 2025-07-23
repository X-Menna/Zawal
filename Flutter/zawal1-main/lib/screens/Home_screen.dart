import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/app_colors.dart';
import '../cubits/theme_cubit.dart';
import '../cubits/trip_cubit.dart';
import '../widgets/trip_dialog.dart';
//import 'profile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: Icon(Icons.brightness_6, color: Colors.white),
          onPressed: themeCubit.toggleTheme,
        ),
        title: const Text('Zawal', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<TripCubit, TripState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const CircularProgressIndicator();
            } else if (state.trip != null) {
              return Text(
                'Trip to ${state.trip!.destination} added!',
                style: Theme.of(context).textTheme.headlineSmall,
              );
            } else {
              return const Text('Click + to plan your next trip ✈️');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed:
            () => showDialog(
              context: context,
              builder: (_) => const TripDialog(),
            ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
