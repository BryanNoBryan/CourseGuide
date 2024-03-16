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
        height: 210,
        width: 900,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blueAccent)),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.course.name!),
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
                ),
                Text(
                  '${widget.course.subject ?? ''}  ',
                ),
                Text(
                  widget.course.timeDesc ?? '',
                ),
              ],
            ),
            Text(
              widget.course.description!,
              overflow: TextOverflow.fade,
              maxLines: 4,
            ),
            Row(
              children: [
                Text(
                  'prereq:' + widget.course.prereq!.toString() + '  ',
                ),
                Text(
                  'coreq:' + widget.course.coreq!.toString() + '  ',
                ),
                Text(
                  'tags:' + widget.course.tags!.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
