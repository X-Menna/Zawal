import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/trip_model.dart';
import '../services/ai_service.dart';

abstract class TripState {}

class TripInitial extends TripState {}

class TripLoading extends TripState {}

class TripSuccess extends TripState {
  final Map<String, dynamic> responseData;
  TripSuccess(this.responseData);
}

class TripFailure extends TripState {
  final String error;
  TripFailure(this.error);
}

class TripCubit extends Cubit<TripState> {
  TripCubit() : super(TripInitial());

  Future<void> submitTrip(TripModel trip) async {
    emit(TripLoading());
    try {
      final response = await AIService.fetchRecommendations(trip);
      emit(TripSuccess(response));
    } catch (e) {
      emit(TripFailure(e.toString()));
    }
  }
}


