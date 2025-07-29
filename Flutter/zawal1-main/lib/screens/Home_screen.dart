import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawal/constants/app_colors.dart';
import 'package:zawal/cubits/theme_cubit.dart';
import 'package:zawal/cubits/trip_cubit.dart';
import 'package:zawal/screens/profilescreen.dart';
import 'package:zawal/screens/recomendation_screen.dart';
import 'package:zawal/widgets/country_tiles.dart';
import 'package:zawal/widgets/trip_dialog.dart';

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
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),

      body: BlocListener<TripCubit, TripState>(
        listener: (context, state) {
          if (state is TripSuccess) {
            final responseData = context.read<TripCubit>().response;
            if (responseData != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          RecommendationScreen(response: responseData.toJson()),
                ),
              );
            }
          }
        },
        child: ListView(
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
              child: BlocBuilder<TripCubit, TripState>(
                builder: (context, state) {
                  if (state is TripLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is TripLoadingFailed) {
                    return const Text("Failed to fetch recommendations.");
                  } else if (state is TripSuccess) {
                    final cubit = context.read<TripCubit>();
                    final model = cubit.response;

                    if (model == null || model.preferences == null) {
                      return const Text("No data available.");
                    }

                    final prefs = model.preferences!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Destination: ${prefs.country ?? 'N/A'}",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text("Budget: ${prefs.budget ?? 'N/A'}"),
                        Text("Age: ${prefs.age ?? 'N/A'}"),
                        Text("Season: ${prefs.season ?? 'N/A'}"),
                        Text("Language: ${prefs.language ?? 'N/A'}"),
                        Text(
                          "Solo Travel: ${prefs.isSoloTravel == 1 ? 'Yes' : 'No'}",
                        ),
                        if (prefs.activities != null &&
                            prefs.activities!.isNotEmpty)
                          Text("Activities: ${prefs.activities!.join(', ')}"),
                      ],
                    );
                  } else {
                    return const Text('Click + to plan your next trip ✈️');
                  }
                },
              ),
            ),
          ],
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
