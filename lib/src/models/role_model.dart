import 'package:cloud_firestore/cloud_firestore.dart';

class RoleModel {
  final String id;
  final String name;
  final String displayName;
  final String description;
  final bool removeable;

  // date
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  RoleModel({
    required this.id,
    required this.name,
    required this.displayName,
    required this.description,
    this.removeable = true,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  @override
  String toString() {
    return 'RoleModel(id: $id, name: $name, displayName: $displayName, description: $description, removeable: $removeable, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  RoleModel.fromDocumentSnapshot(DocumentSnapshot<Object?> doc)
      : this(
          id: doc.id,
          name: doc.get('name'),
          displayName: doc.get('displayName'),
          description: doc.get('description'),
          removeable: doc.get('removeable'),
          createdAt: doc.get('createdAt').toDate(),
          updatedAt: doc.get('updatedAt').toDate(),
          deletedAt: doc.get('deletedAt') == null
              ? doc.get('deletedAt')
              : doc.get('deletedAt').toDate(),
        );

  RoleModel.fromQueryDocumentSnapshot(QueryDocumentSnapshot<Object?> doc)
      : this(
          id: doc.id,
          name: doc.get('name'),
          displayName: doc.get('displayName'),
          description: doc.get('description'),
          removeable: doc.get('removeable'),
          createdAt: doc.get('createdAt').toDate(),
          updatedAt: doc.get('updatedAt').toDate(),
          deletedAt: doc.get('deletedAt') == null
              ? doc.get('deletedAt')
              : doc.get('deletedAt').toDate(),
        );

  RoleModel.fromMap(Map<String, dynamic> map)
      : this(
          id: map['id'],
          name: map['name'],
          displayName: map['displayName'],
          description: map['description'],
          removeable: map['removeable'],
          createdAt: map['createdAt'],
          updatedAt: map['updatedAt'],
          deletedAt: map['deletedAt'],
        );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'displayName': displayName,
      'description': description,
      'removeable': removeable,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }

  RoleModel.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as String,
          name: json['name']! as String,
          displayName: json['displayName']! as String,
          description: json['description']! as String,
          removeable: json['removeable']! as bool,
          createdAt: json['createdAt']! as DateTime,
          updatedAt: json['updatedAt']! as DateTime,
          deletedAt: json['deletedAt']! as DateTime,
        );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'displayName': displayName,
      'description': description,
      'removeable': removeable,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }
}
