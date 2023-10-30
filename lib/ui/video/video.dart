import 'package:another_flushbar/flushbar_helper.dart';
import 'package:lottie/lottie.dart';
import 'package:saintpopekerollosvi/di/components/service_locator.dart';
import 'package:saintpopekerollosvi/stores/video/video_store.dart';
import 'package:saintpopekerollosvi/ui/video/play_video.dart';
import 'package:saintpopekerollosvi/stores/language/language_store.dart';
import 'package:saintpopekerollosvi/stores/post/post_store.dart';
import 'package:saintpopekerollosvi/stores/theme/theme_store.dart';
import 'package:saintpopekerollosvi/utils/locale/app_localization.dart';
import 'package:saintpopekerollosvi/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({
    super.key,
  });

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  //stores:---------------------------------------------------------------------
  late PostStore _postStore;

  // late ThemeStore _themeStore;
  // late LanguageStore _languageStore;

  ScrollController _scrollController = ScrollController();

  VideoStore _videoStore = getIt<VideoStore>();

  @override
  void initState() {
    _videoStore.getVideo();

    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   // initializing stores
  //   _languageStore = Provider.of<LanguageStore>(context);
  //   _themeStore = Provider.of<ThemeStore>(context);
  //   _postStore = Provider.of<PostStore>(context);
  //
  //   // check to see if already called api
  //   if (!_postStore.loading) {
  //     _postStore.getPosts();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  // app bar methods:-----------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('Videos'),
      // actions: _buildActions(context),
    );
  }

  // List<Widget> _buildActions(BuildContext context) {
  //   return <Widget>[
  //     // _buildGoogleSignInButton(),
  //     // // _buildLanguageButton(),
  //     // // _buildThemeButton(),
  //     // _buildLogoutButton(),
  //   ];
  // }

  // Widget _buildThemeButton() {
  //   return Observer(
  //     builder: (context) {
  //       return IconButton(
  //         onPressed: () {
  //           _themeStore.changeBrightnessToDark(!_themeStore.darkMode);
  //         },
  //         icon: Icon(
  //           _themeStore.darkMode ? Icons.brightness_5 : Icons.brightness_3,
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildLogoutButton() {
  //   return IconButton(
  //     onPressed: () {
  //       SharedPreferences.getInstance().then((preference) {
  //         preference.setBool(Preferences.is_logged_in, false);
  //         Navigator.of(context).pushReplacementNamed(Routes.login);
  //       });
  //     },
  //     icon: Icon(
  //       Icons.power_settings_new,
  //     ),
  //   );
  // }

  // Widget _buildLanguageButton() {
  //   return IconButton(
  //     onPressed: () {
  //       _buildLanguageDialog();
  //     },
  //     icon: Icon(
  //       Icons.language,
  //     ),
  //   );
  // }

  // Widget _buildGoogleSignInButton() {
  //   return IconButton(
  //     onPressed: () {
  //       final GoogleSignIn _googleSignIn = GoogleSignIn(
  //         clientId: '289605575676-5csing7me517q35f22up995qg6ucimr4.apps.googleusercontent.com',
  //         scopes: <String>[
  //           'https://www.googleapis.com/auth/calendar',
  //         ],
  //       );
  //       _googleSignIn.signIn();
  //     },
  //     icon: Icon(
  //       Icons.login,
  //     ),
  //   );
  // }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Observer(builder: (context) {
      return Stack(
        children: <Widget>[
          _buildMainContent(),
          if (_videoStore.isGetMoreYoutubeVideoInProcess)
            Align(
              alignment: Alignment.bottomCenter,
              child: LinearProgressIndicator(),
            )
        ],
      );
    });
  }

  Widget _buildMainContent() {
    return Observer(
      builder: (context) {
        return _videoStore.isGetYoutubeVideoInProcess ? CustomProgressIndicatorWidget() : Material(child: _buildListView());
      },
    );
  }

  Widget _buildListView() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        // Call your function here
        _videoStore.getMoreVideos(); // Replace this with the function you want to call
      }
    });

    return _videoStore.videoList.isNotEmpty
        ? ListView.separated(
            controller: _scrollController,
            itemCount: _videoStore.videoList.length,
            separatorBuilder: (context, position) {
              return Divider();
            },
            itemBuilder: (context, position) {
              return _buildListItem(position);
            },
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 120,
                  child: OverflowBox(
                    minHeight: 250,
                    maxHeight: 250,
                    child: Lottie.asset('assets/animations/404_lottie.json'),
                  ),
                ),
                Text(
                  'No Videos Available',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          );
  }

  Widget _buildListItem(int position) {
    final item = _videoStore.videoList[position].snippet;

    return CustomListItem(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => YoutubePlayer(
              item: _videoStore.videoList[position],
            ),
          ),
        );
      },
      imageUrl: item?.thumbnails?.thumbnailsDefault?.url ?? '',
      title: '${item?.title ?? ''}',
      subtitle: timeago.format(item?.publishedAt ?? DateTime.now()),
    );
  }

//
// _buildLanguageDialog() {
//   _showDialog<String>(
//     context: context,
//     child: MaterialDialog(
//       borderRadius: 5.0,
//       enableFullWidth: true,
//       title: Text(
//         AppLocalizations.of(context).translate('home_tv_choose_language'),
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 16.0,
//         ),
//       ),
//       headerColor: Theme.of(context).primaryColor,
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       closeButtonColor: Colors.white,
//       enableCloseButton: true,
//       enableBackButton: false,
//       onCloseButtonClicked: () {
//         Navigator.of(context).pop();
//       },
//       children: _languageStore.supportedLanguages
//           .map(
//             (object) => ListTile(
//               dense: true,
//               contentPadding: EdgeInsets.all(0.0),
//               title: Text(
//                 object.language!,
//                 style: TextStyle(
//                   color: _languageStore.locale == object.locale
//                       ? Theme.of(context).primaryColor
//                       : _themeStore.darkMode
//                           ? Colors.white
//                           : Colors.black,
//                 ),
//               ),
//               onTap: () {
//                 Navigator.of(context).pop();
//                 // change user language based on selected locale
//                 _languageStore.changeLanguage(object.locale!);
//               },
//             ),
//           )
//           .toList(),
//     ),
//   );
// }
//
// _showDialog<T>({required BuildContext context, required Widget child}) {
//   showDialog<T>(
//     context: context,
//     builder: (BuildContext context) => child,
//   ).then<void>((T? value) {
//     // The value passed to Navigator.pop() or null.
//   });
// }
}

class CustomListItem extends StatelessWidget {
  final Function onTap;
  final String imageUrl;
  final String title;
  final String subtitle;

  CustomListItem({
    required this.onTap,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12), // Adjust the spacing according to your requirement
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                    softWrap: true,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Theme.of(context).primaryColor, fontSize: 18),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
