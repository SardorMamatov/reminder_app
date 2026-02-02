import '../../domain/entities/event_entity.dart';

class EventModel extends EventEntity {
  const EventModel({
    required super.id,
    required super.title,
    super.description,
    super.location,
    required super.startAt,
    required super.endAt,
    required super.colorHex,
    required super.remindMinutesBefore,
    required super.createdAt,
    required super.updatedAt,
  });

  factory EventModel.fromMap(Map<String, Object?> map) {
    return EventModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String?,
      location: map['location'] as String?,
      startAt: DateTime.fromMillisecondsSinceEpoch(map['start_at'] as int),
      endAt: DateTime.fromMillisecondsSinceEpoch(map['end_at'] as int),
      colorHex: map['color_hex'] as int,
      remindMinutesBefore: map['remind_before'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'start_at': startAt.millisecondsSinceEpoch,
      'end_at': endAt.millisecondsSinceEpoch,
      'color_hex': colorHex,
      'remind_before': remindMinutesBefore,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }
}
