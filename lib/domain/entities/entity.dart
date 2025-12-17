/// Base class for all domain entities.
///
/// Entities are objects with a distinct identity that runs through time
/// and different representations. They are the core business objects.
abstract class Entity {
  /// Unique identifier for the entity
  final String id;

  const Entity(this.id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Entity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
