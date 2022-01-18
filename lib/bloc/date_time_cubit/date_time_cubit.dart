import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_drift_bloc/bloc/date_time_cubit/date_time_state.dart';

class DateTimeCubit extends Cubit<DateTimeState> {
  DateTimeCubit() : super(DateTimeIsNotSet());

  dateTimeIsSet(DateTime dateTime) {
    emit(DateTimeIsSet(dateTime: dateTime));
  }
}
