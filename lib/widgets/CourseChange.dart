import 'package:course_guide/providers/Course.dart';
import 'package:course_guide/providers/database.dart';
import 'package:flutter/material.dart';

class CourseChangeDialog extends StatefulWidget {
  const CourseChangeDialog(
      {required this.isCreate, this.course, this.onDelete, super.key});

  final bool isCreate;
  final Course? course;
  final Function? onDelete;

  @override
  State<CourseChangeDialog> createState() => _CourseChangeDialogState();
}

class _CourseChangeDialogState extends State<CourseChangeDialog> {
  final primaryColor = const Color(0xff4338CA);
  final accentColor = const Color(0xffffffff);
  final TextEditingController name = TextEditingController();
  final TextEditingController desc = TextEditingController();
  final TextEditingController code = TextEditingController();
  final TextEditingController subject = TextEditingController();
  final TextEditingController timeDesc = TextEditingController();
  final TextEditingController level = TextEditingController();
  final TextEditingController prereq = TextEditingController();
  final TextEditingController coreq = TextEditingController();
  final TextEditingController tags = TextEditingController();

  final primaryColor2 = Color(0xff4338CA);
  final secondaryColor2 = Color(0xff6D28D9);
  final accentColor2 = Color(0xffffffff);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    name.text = !widget.isCreate ? widget.course!.name ?? '' : '';
    desc.text = !widget.isCreate ? widget.course!.description ?? '' : '';
    code.text = !widget.isCreate ? widget.course!.code ?? '' : '';
    subject.text = !widget.isCreate ? widget.course!.subject ?? '' : '';
    timeDesc.text = !widget.isCreate ? widget.course!.timeDesc ?? '' : '';
    level.text = !widget.isCreate ? widget.course!.level ?? '' : '';
    prereq.text = !widget.isCreate
        ? widget.course!.prereq?.reduce((v, e) => '$v,$e') ?? ''
        : '';
    coreq.text = !widget.isCreate
        ? widget.course!.coreq?.reduce((v, e) => v = '$v,$e') ?? ''
        : '';
    tags.text = !widget.isCreate
        ? widget.course!.tags?.reduce((v, e) => v = '$v,$e') ?? ''
        : '';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.4,
        height: MediaQuery.of(context).size.height / 1.2,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(12, 26),
                  blurRadius: 50,
                  spreadRadius: 0,
                  color: Colors.grey.withOpacity(.1)),
            ]),
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            Center(
              child: Text(
                widget.isCreate ? "Creating Course" : "Editing Course",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 3.5,
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Input(title: 'Name', controller: name)),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Input(title: 'Description', controller: desc)),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Input(title: 'Code', controller: code)),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Input(title: 'Subject', controller: subject)),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Input(title: 'Time Description', controller: timeDesc)),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Input(title: 'Level', controller: level)),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Input(title: 'Prerequisites', controller: prereq)),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Input(title: 'Corequisites', controller: coreq)),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Input(title: 'Tags', controller: tags)),
            const SizedBox(
              height: 3.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SimpleBtn1(
                    text: "Submit",
                    onPressed: () async {
                      Course c = Course(
                          code: code.text,
                          name: name.text,
                          description: desc.text,
                          subject: subject.text,
                          timeDesc: timeDesc.text,
                          level: level.text,
                          prereq: prereq.text.split(','),
                          coreq: coreq.text.split(','),
                          tags: tags.text.split(','));

                      if (widget.isCreate) {
                        await Database().addCourse(c);
                        Database().courses!.add(c);
                      } else {
                        await Database().editCourse(c);
                        await Database()
                            .updateList(c.code ?? "ERROR NOTHING CODE");
                      }
                      Database().printList();
                      print('changed a course');
                      Navigator.of(context).pop();
                    }),
                Visibility(
                  visible: widget.course != null,
                  child: SimpleBtn1(
                    text: "Delete",
                    onPressed: () async {
                      widget.onDelete!();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SimpleBtn1(
                  text: "Cancel",
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  invertedColors: true,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Input extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  const Input(
      {required this.title,
      this.hint = '',
      super.key,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xff4338CA);
    const secondaryColor = Color(0xff6D28D9);
    const accentColor = Color(0xffffffff);
    const backgroundColor = Color(0xffffffff);
    const errorColor = Color(0xffEF4444);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.white.withOpacity(.9)),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          height: 50,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                offset: const Offset(12, 26),
                blurRadius: 50,
                spreadRadius: 0,
                color: Colors.grey.withOpacity(.1)),
          ]),
          child: TextField(
            controller: controller,
            onChanged: (value) {
              //Do something with
            },
            style: const TextStyle(fontSize: 14, color: Colors.black),
            decoration: InputDecoration(
              label: Text(title),
              labelStyle: const TextStyle(color: primaryColor),
              // prefixIcon: Icon(Icons.email),
              filled: true,
              fillColor: accentColor,
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: secondaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SimpleBtn1 extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool invertedColors;
  const SimpleBtn1(
      {required this.text,
      required this.onPressed,
      this.invertedColors = false,
      super.key});
  final primaryColor = const Color(0xff4338CA);
  final accentColor = const Color(0xffffffff);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            alignment: Alignment.center,
            side: MaterialStateProperty.all(
                BorderSide(width: 1, color: primaryColor)),
            padding: MaterialStateProperty.all(
                const EdgeInsets.only(right: 25, left: 25, top: 0, bottom: 0)),
            backgroundColor: MaterialStateProperty.all(
                invertedColors ? accentColor : primaryColor),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            )),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              color: invertedColors ? primaryColor : accentColor, fontSize: 16),
        ));
  }
}
