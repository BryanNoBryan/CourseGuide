import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_guide/providers/Course.dart';
import 'package:csv/csv.dart';

class Database {
  static final Database _state = Database._init();
  factory Database() {
    return _state;
  }
  Database._init();

  FirebaseFirestore database = FirebaseFirestore.instance;
  List<Course>? courses;
  List<Course>? queriedCourses;

  Future<void> addCourse(Course course) async {
    FirebaseFirestore.instance
        .collection('Courses')
        .doc(course.code)
        .set(course.toFirestore())
        .onError((error, stackTrace) => print('$error'));
    print('add course');
  }

  Future<void> editCourse(Course course) async {
    FirebaseFirestore.instance
        .collection('Courses')
        .doc(course.code)
        .set(course.toFirestore())
        .onError((error, stackTrace) => print('$error'));
    print('edit course');
  }

  Future<void> retrieveCourses() async {
    print('course retrieved');
    var snapshot =
        await FirebaseFirestore.instance.collection('Courses').get().then(
              (doc) => doc,
              onError: (e) => print("Error updating document $e"),
            );

    print('bruh');
    courses =
        snapshot.docs.map((doc) => Course.fromFirestore(doc, null)).toList();
    print('retrieve: + $courses');
  }

  List<Course>? getCourses() {
    print('course got');
    return courses;
  }

  List<Course>? getQueriedCourses() {
    print('course got');
    return queriedCourses;
  }

  //query 0: keywords, 1:subject, 2: level
  List<Course> queryCourses(int query,
      {List<String>? keywords, String? subject, String? level}) {
    print('course queried');

    keywords?.forEach((e) => e.toLowerCase());
    subject = subject?.toLowerCase();
    level = level?.toLowerCase();

    queriedCourses = [];
    switch (query) {
      case 0:
        {
          for (Course c in courses!) {
            for (String word in keywords!) {
              if (c.description?.toLowerCase().contains(word) ?? false) {
                queriedCourses!.add(c);
                continue;
              }
              if (c.name?.toLowerCase().contains(word) ?? false) {
                queriedCourses!.add(c);
                continue;
              }
              if (c.timeDesc?.toLowerCase().contains(word) ?? false) {
                queriedCourses!.add(c);
                continue;
              }
              if (c.level?.toLowerCase().contains(word) ?? false) {
                queriedCourses!.add(c);
                continue;
              }
              if (c.subject?.toLowerCase().contains(word) ?? false) {
                queriedCourses!.add(c);
                continue;
              }
            }
          }
        }
        break;
      case 1:
        {
          for (Course c in courses!) {
            if ((c.subject?.toLowerCase() ?? '') == subject!) {
              queriedCourses!.add(c);
            }
          }
        }
        break;
      case 2:
        {
          for (Course c in courses!) {
            if ((c.level?.toLowerCase() ?? '') == level!) {
              queriedCourses!.add(c);
            }
          }
        }
        break;
      default:
        {
          print('NOT A QUERY OPTION');
        }
        break;
    }
    printQueriedList();
    return queriedCourses!;
  }

  Future<void> deleteCourse(Course course) async {
    await FirebaseFirestore.instance
        .collection('Courses')
        .doc(course.code)
        .delete()
        .then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error updating document $e"),
        );
    print('finished deleting');
  }

  Future<List<Course>?> updateList(String code) async {
    var doc =
        await FirebaseFirestore.instance.collection('Courses').doc(code).get();
    if (!doc.exists) {
      log('doc in update list exists');
      log('code $code');
      for (int i = 0; i < courses!.length; i++) {
        log('each code ${courses![i].code}');
        if ((courses![i].code ?? '') == code) {
          courses!.removeAt(i);
          log('${courses} removedd thingys DID IT DO IT? $i ');
          printList();
          break;
        }
      }
    } else {
      log('other');
      Course course = Course.fromFirestore(doc, null);
      for (int i = 0; i < courses!.length; i++) {
        if (courses![i].code == code) {
          courses![i] = course;
          break;
        }
      }
      if (queriedCourses != null) {
        for (int i = 0; i < queriedCourses!.length; i++) {
          if (queriedCourses![i].code == code) {
            queriedCourses![i] = course;
            break;
          }
        }
      }
      print(course.prereq);
    }

    print('called update list');
    printList();
    return courses;
  }

  //list of course codes
  Future<List<Course>?> getCoursesFromFavorites(List<String>? favorites) async {
    log('tried');
    print(favorites.toString());
    if (favorites == null) {
      return null;
    } else if (favorites!.length == 0) {
      return [];
    }
    print('before trying to get courses fav from method');
    var snapshot = await FirebaseFirestore.instance
        .collection('Courses')
        .where('code', whereIn: favorites)
        .get();
    List<Course> favCourses = [];
    print('fav courses from method');
    printList();
    for (var doc in snapshot.docs) {
      favCourses.add(Course.fromFirestore(doc, null));
    }
    log('got courses from favs ${favCourses}');
    return favCourses;
  }

  void printList() {
    String s = '';
    courses!.forEach((e) {
      s += '${e.code} ${e.prereq} , ';
    });
    print(s);
  }

  void printQueriedList() {
    String s = '';
    queriedCourses?.forEach((e) {
      s += '${e.code} ${e.prereq} , ';
    });
    print(s);
  }
}
