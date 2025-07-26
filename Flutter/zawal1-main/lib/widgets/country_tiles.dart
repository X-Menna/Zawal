import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_textstyles.dart';

class CountryTiles extends StatelessWidget {
  final List<CountryInfo> countries = [
    CountryInfo(
      name: 'Japan',
      image: 'assets/images/japan.jpeg',
      description:
          'Japan is known for its unique blend of traditional culture and modern technology. It’s famous for cherry blossoms, sushi, and Mount Fuji.',
    ),
    CountryInfo(
      name: 'Italy',
      image: 'assets/images/italy.jpg',
      description:
          'Italy is rich in history and culture. It’s famous for its cuisine, ancient ruins, art, and beautiful coastlines.',
    ),
    CountryInfo(
      name: 'Egypt',
      image: 'assets/images/egypt.jpg',
      description:
          'Egypt is known for its ancient civilization and famous monuments such as the Pyramids and the Great Sphinx.',
    ),
    CountryInfo(
      name: 'Thailand',
      image: 'assets/images/thailand.jpg',
      description:
          'Thailand offers tropical beaches, royal palaces, ancient ruins, and ornate temples displaying Buddha figures.',
    ),
    CountryInfo(
      name: 'France',
      image: 'assets/images/france.jpg',
      description:
          'France is celebrated for its wine, fashion, the Eiffel Tower, and its influence on global art and cuisine.',
    ),
    CountryInfo(
      name: 'Brazil',
      image: 'assets/images/brazil.jpg',
      description:
          'Brazil is known for its Amazon rainforest, Carnival festival, and vibrant cities like Rio de Janeiro.',
    ),
  ];

  CountryTiles({super.key});

  void _showCountryDialog(BuildContext context, CountryInfo country) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(country.name),
        content: Text(country.description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: countries.length,
        itemBuilder: (context, index) {
          final country = countries[index];
          return GestureDetector(
            onTap: () => _showCountryDialog(context, country),
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(country.image),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.25),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    country.name,
                    style: AppTextStyles.heading.copyWith(
                      color: AppColors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CountryInfo {
  final String name;
  final String image;
  final String description;

  CountryInfo({
    required this.name,
    required this.image,
    required this.description,
  });
}