import 'package:freezed_annotation/freezed_annotation.dart';

part 'persona.freezed.dart';
part 'persona.g.dart';

/// Persona model - represents a user profile for roleplay
@freezed
class Persona with _$Persona {
  const factory Persona({
    required String id,
    required String name,
    @Default('') String description,
    String? avatarPath,
    @Default(false) bool isDefault,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Persona;

  factory Persona.fromJson(Map<String, dynamic> json) => _$PersonaFromJson(json);
}

/// Default persona for new users
Persona createDefaultPersona() {
  final now = DateTime.now();
  return Persona(
    id: 'default',
    name: 'User',
    description: '',
    isDefault: true,
    createdAt: now,
    updatedAt: now,
  );
}