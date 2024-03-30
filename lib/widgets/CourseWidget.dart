import 'package:course_guide/MyColors.dart';
import 'package:course_guide/providers/Course.dart';
import 'package:flutter/material.dart';

class CourseWidget extends StatefulWidget {
  const CourseWidget(
      {required this.course,
      this.onEdit,
      this.onFavorite,
      required this.admin,
      required this.hasAccount,
      super.key});

  final Course course;
  final Function()? onEdit;
  final Function()? onFavorite;
  final bool admin;
  final bool hasAccount;

  @override
  State<CourseWidget> createState() => _CourseWidgetState();
}

class _CourseWidgetState extends State<CourseWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: MyColors.lightBlue,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blueAccent)),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.course.name!,
                      style: TextStyle(fontSize: 36),
                      maxLines: 3,
                    ),
                  ),
                  Row(
                    children: [
                      Visibility(
                        visible: widget.admin,
                        child: IconButton(
                            onPressed: widget.onEdit,
                            icon: Icon(Icons.edit),
                            highlightColor: Colors.lightBlue,
                            hoverColor: Colors.lightBlue),
                      ),
                      Visibility(
                        visible: widget.hasAccount,
                        child: IconButton(
                            onPressed: widget.onFavorite,
                            icon: Icon(Icons.favorite),
                            highlightColor: Colors.lightBlue,
                            hoverColor: Colors.lightBlue),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    '${widget.course.level ?? ''}  ',
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    '${widget.course.subject ?? ''}  ',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
              Text(
                widget.course.timeDesc ?? '',
                style: TextStyle(fontSize: 18),
              ),
            ]),
            Text(
              widget.course.description!,
              style: TextStyle(fontSize: 24),
              maxLines: 10,
            ),
            Text(
              'prereq:' + widget.course.prereq!.toString() + '  ',
              style: TextStyle(fontSize: 18),
            ),
            Row(
              children: [
                Text(
                  'tags:' + widget.course.tags!.toString(),
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
