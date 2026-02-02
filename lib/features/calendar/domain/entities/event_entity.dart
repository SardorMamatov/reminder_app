import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  const EventEntity({
    required this.id,
    required this.title,
    this.description,
    this.location,
    required this.startAt,
    required this.endAt,
    required this.colorHex,
    required this.remindMinutesBefore,
    required this.createdAt,
    required this.updatedAt,
  });
  final int? id; 
  final String title;
  final String? description;
  final String? location;
  final DateTime startAt;
  final DateTime endAt;
  final int colorHex;
  final int remindMinutesBefore; 
  final DateTime createdAt;
  final DateTime updatedAt;

   @override
  List<Object?> get props => [
        id,
        title,
        description,
        location,
        startAt,
        endAt,
        colorHex,
        remindMinutesBefore,
        createdAt,
        updatedAt,
      ];
}
