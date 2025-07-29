import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawal/screens/profilescreen.dart';
import '../constants/app_colors.dart';
import '../cubits/theme_cubit.dart';
import '../cubits/trip_cubit.dart';
import '../widgets/trip_dialog.dart';
import '../widgets/country_tiles.dart'; 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.brightness_6, color: Colors.white),
          onPressed: themeCubit.toggleTheme,
        ),
        title: const Text('Zawal', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '🌍 Explore Destinations',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 12),

          CountryTiles(),

          const SizedBox(height: 24),

          Center(
            child:
            BlocBuilder<TripCubit, TripState>(
  builder: (context, state) {
    if (state is TripLoading) {
      return const CircularProgressIndicator();
    } else if (state is TripLoadingFailed) {
      return const Text("Failed to fetch recommendations.");
    } else if (state is TripSuccess) {
      final cubit = context.read<TripCubit>();
      final data = cubit.response;

      if (data == null) return const Text("No data available.");

      final status = data.status ?? 'Unknown';
      final message = data.message ?? '';
      final firstAlternative = data.alternatives?.isNotEmpty == true
          ? data.alternatives!.first
          : null;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Status: $status", style: Theme.of(context).textTheme.headlineSmall),
          if (message.isNotEmpty) Text("Message: $message"),
          const SizedBox(height: 8),
          if (firstAlternative != null) ...[
            Text("Recommended: ${firstAlternative.country}"),
            Text("Score: ${firstAlternative.score}"),
          ],
        ],
      );
    } else {
      return const Text('Click + to plan your next trip ✈️');
    }
  },
)


            
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const TripDialog(),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

