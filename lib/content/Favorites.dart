import 'package:course_guide/navigation/MyNavigator.dart';
import 'package:course_guide/providers/User.dart';
import 'package:course_guide/providers/UserDatabase.dart';
import 'package:course_guide/providers/database.dart';
import 'package:course_guide/widgets/CourseWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  MyUser? user;
  List<String>? favorites = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    user = UserDatabase().getUser();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      favorites = await UserDatabase().getFavorites(user);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Database().getCoursesFromFavorites(favorites),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done &&
              snapshot.data!.length == 0) {
            print('NOTHINGLESS OPTION');
            return SizedBox.shrink();
          } else if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(20),
                    child: CourseWidget(
                      course: snapshot.data![index],
                      onFavorite: () async {
                        await UserDatabase().removeFromFavorite(
                            snapshot.data![index].code ?? 'ERROR');
                        favorites = await UserDatabase().getFavorites(user);
                        setState(() {});
                      },
                      admin: false,
                      hasAccount: true,
                    ),
                  );
                },
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
