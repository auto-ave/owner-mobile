import 'package:json_annotation/json_annotation.dart';
part 'booked_by.g.dart';

@JsonSerializable()
class BookedBy {
  final String? name;

  final String? phone;

  final String? email;
  BookedBy({
    required this.name,
    required this.phone,
    required this.email,
  });
  factory BookedBy.fromEntity(BookedByEntity e) {
    return BookedBy(name: e.name, phone: e.phone, email: e.email);
  }
}

@JsonSerializable()
class BookedByEntity {
  final String? name;

  final String? phone;

  final String? email;
  BookedByEntity({
    required this.name,
    required this.phone,
    required this.email,
  });
  factory BookedByEntity.fromJson(Map<String, dynamic> data) =>
      _$BookedByEntityFromJson(data);

  Map<String, dynamic> toJson() => _$BookedByEntityToJson(this);
}
