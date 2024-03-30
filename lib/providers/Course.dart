import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String? code;
  final String? name;
  final String? description;
  final String? subject;
  final String? timeDesc;
  final String? level;
  final String? prereq;
  final List<String>? tags;

  Course({
    this.code,
    this.name,
    this.description,
    this.subject,
    this.timeDesc,
    this.level,
    this.prereq,
    this.tags,
  });

  factory Course.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Course(
      code: data?['code'],
      name: data?['name'],
      description: data?['description'],
      subject: data?['subject'],
      timeDesc: data?['timeDesc'],
      level: data?['level'],
      prereq: data?['prereq'],
      tags: data?['tags'] is Iterable ? List.from(data?['tags']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (subject != null) 'subject': subject,
      if (timeDesc != null) 'timeDesc': timeDesc,
      if (level != null) 'level': level,
      if (prereq != null) 'prereq': prereq,
      if (tags != null) 'tags': tags,
    };
  }
}
