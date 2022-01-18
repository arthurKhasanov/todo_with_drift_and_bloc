abstract class DateTimeState {}

class DateTimeIsSet extends DateTimeState {
  DateTime dateTime;
  DateTimeIsSet({required this.dateTime});
}

class DateTimeIsNotSet extends DateTimeState {}