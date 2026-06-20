/// Interface indication that the class can be serialized to Json.
mixin JsonSerializable {
  Map<String, Object?> toJson();
}