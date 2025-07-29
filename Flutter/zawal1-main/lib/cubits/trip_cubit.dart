import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawal/constants/end_points.dart';
import 'package:zawal/dio.dart';
import 'package:zawal/models/recommendation_model.dart';
import 'package:zawal/models/trip_model.dart';

abstract class TripState {}

class TripInitial extends TripState {}

class TripLoading extends TripState {}

class TripSuccess extends TripState {}

class TripLoadingFailed extends TripState {}

class TripCubit extends Cubit<TripState> {
  TripCubit(super.initialState);

  recommendation_model? response;

  // void getJustHomeData() async {
  //   emit(TripLoading());
  //   await DioHelper.getData(url: EndPoints.getRecommendations)
  //       .then((value) {
  //     if (value.data['status'] == true) {
  //       response = RecommendationResponse.fromJson(value.data);
  //       emit(TripSuccess());
  //     } else {
  //       emit(TripLoadingFailed());
  //     }
  //   }).catchError((e) {
  //     emit(TripLoadingFailed());
  //   });
  // }


  void submitTrip(TripModel trip) async {
    emit(TripLoading());

    await DioHelper.postData(
      url: EndPoints.generateTrip,
      data: {
        "destination": trip.destination,
        "language": trip.language,
        "is_solo": trip.isSolo,
        "season": trip.season,
        "activity": trip.activity,
        "budget": trip.budget,
        "age": trip.age,
      },
    ).then((value) {
      response = recommendation_model.fromJson(value.data);
      emit(TripSuccess());
    }).catchError((error) {
      emit(TripLoadingFailed());
    });
  }
}
