import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/trip_model.dart';

class TripState {
  final TripModel? trip;
  final bool isLoading;

  TripState({this.trip, this.isLoading = false});
}

class TripCubit extends Cubit<TripState> {
  TripCubit() : super(TripState());

  void submitTrip(TripModel model) {
    emit(TripState(isLoading: true));
    Future.delayed(const Duration(seconds: 2), () {
      emit(TripState(trip: model, isLoading: false));
    });
  }
}
