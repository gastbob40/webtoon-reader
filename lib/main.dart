import 'package:flutter/cupertino.dart';
import 'package:webtoon_crawler_app/domain/service/authentication_service.dart';
import 'package:webtoon_crawler_app/views/screens/login_view.dart';
import 'package:webtoon_crawler_app/views/screens/manga_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthenticationService authenticationService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: FutureBuilder<bool>(
        future: authenticationService.isUserAuthenticated(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CupertinoActivityIndicator(); // Cupertino-style activity indicator
          } else {
            if (!snapshot.data!) {
              // Delaying navigation until after the build is complete
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              });
            }
            // By this point, either the user is authenticated, or we have queued up navigation to the LoginPage.
            return const MangaEntriesScreen();
          }
        },
      ),
    );
  }

}
