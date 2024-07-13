import 'dart:convert';

class Companie {
  String name;
  String id;
  Companie({
    required this.name,
    required this.id,
  });

  Companie copyWith({
    String? name,
    String? id,
  }) {
    return Companie(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'name': name});
    result.addAll({'id': id});
  
    return result;
  }

  factory Companie.fromMap(Map<String, dynamic> map) {
    return Companie(
      name: map['name'] ?? '',
      id: map['id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Companie.fromJson(String source) => Companie.fromMap(json.decode(source));

  @override
  String toString() => 'Companie(name: $name, id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Companie &&
      other.name == name &&
      other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode;
}
