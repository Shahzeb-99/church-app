import 'package:another_flushbar/flushbar_helper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:saintpopekerollosvi/data/sharedpref/constants/preferences.dart';
import 'package:saintpopekerollosvi/di/components/service_locator.dart';
import 'package:saintpopekerollosvi/stores/video/video_store.dart';
import 'package:saintpopekerollosvi/ui/video/play_video.dart';
import 'package:saintpopekerollosvi/utils/routes/routes.dart';
import 'package:saintpopekerollosvi/stores/language/language_store.dart';
import 'package:saintpopekerollosvi/stores/post/post_store.dart';
import 'package:saintpopekerollosvi/stores/theme/theme_store.dart';
import 'package:saintpopekerollosvi/utils/locale/app_localization.dart';
import 'package:saintpopekerollosvi/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:googleapis/calendar/v3.dart' as googleApi;
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
  late ThemeStore _themeStore;
  late LanguageStore _languageStore;

  ScrollController _scrollController = ScrollController();

  VideoStore _videoStore = getIt<VideoStore>();

  @override
  void initState() {
    _videoStore.getVideo();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // initializing stores
    _languageStore = Provider.of<LanguageStore>(context);
    _themeStore = Provider.of<ThemeStore>(context);
    _postStore = Provider.of<PostStore>(context);

    // check to see if already called api
    if (!_postStore.loading) {
      _postStore.getPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  // app bar methods:-----------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('Videos'),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      _buildGoogleSignInButton(),
      // _buildLanguageButton(),
      // _buildThemeButton(),
      _buildLogoutButton(),
    ];
  }

  Widget _buildThemeButton() {
    return Observer(
      builder: (context) {
        return IconButton(
          onPressed: () {
            _themeStore.changeBrightnessToDark(!_themeStore.darkMode);
          },
          icon: Icon(
            _themeStore.darkMode ? Icons.brightness_5 : Icons.brightness_3,
          ),
        );
      },
    );
  }

  Widget _buildLogoutButton() {
    return IconButton(
      onPressed: () {
        SharedPreferences.getInstance().then((preference) {
          preference.setBool(Preferences.is_logged_in, false);
          Navigator.of(context).pushReplacementNamed(Routes.login);
        });
      },
      icon: Icon(
        Icons.power_settings_new,
      ),
    );
  }

  Widget _buildLanguageButton() {
    return IconButton(
      onPressed: () {
        _buildLanguageDialog();
      },
      icon: Icon(
        Icons.language,
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return IconButton(
      onPressed: () {
        final GoogleSignIn _googleSignIn = GoogleSignIn(
          clientId: '289605575676-5csing7me517q35f22up995qg6ucimr4.apps.googleusercontent.com',
          scopes: <String>[
            'https://www.googleapis.com/auth/calendar',
          ],
        );
        _googleSignIn.signIn();
      },
      icon: Icon(
        Icons.login,
      ),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        _handleErrorMessage(),
        _buildMainContent(),
      ],
    );
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

    return _videoStore.getYoutubeVideoResponse != null
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
            child: Text(
              AppLocalizations.of(context).translate('home_tv_no_post_found'),
            ),
          );
  }

  Widget _buildListItem(int position) {
    final item = _videoStore.videoList[position].snippet;

    return ListTile(
      onTap: (){

        Navigator.push(context, MaterialPageRoute(builder: (context)=>YoutubePlayer(item: _videoStore.videoList[position],)));

      },
      dense: true,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
          child: Image.network(item?.thumbnails?.thumbnailsDefault?.url ?? '',fit: BoxFit.cover,)),
      title: Text(
        '${item?.title ?? ''}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        '${item?.publishedAt.toString() ?? ''}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
    );
  }

  Widget _handleErrorMessage() {
    return Observer(
      builder: (context) {
        if (_postStore.errorStore.errorMessage.isNotEmpty) {
          return _showErrorMessage(_postStore.errorStore.errorMessage);
        }

        return SizedBox.shrink();
      },
    );
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (message.isNotEmpty) {
        FlushbarHelper.createError(
          message: message,
          title: AppLocalizations.of(context).translate('home_tv_error'),
          duration: Duration(seconds: 3),
        )..show(context);
      }
    });

    return SizedBox.shrink();
  }

  _buildLanguageDialog() {
    _showDialog<String>(
      context: context,
      child: MaterialDialog(
        borderRadius: 5.0,
        enableFullWidth: true,
        title: Text(
          AppLocalizations.of(context).translate('home_tv_choose_language'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        headerColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        closeButtonColor: Colors.white,
        enableCloseButton: true,
        enableBackButton: false,
        onCloseButtonClicked: () {
          Navigator.of(context).pop();
        },
        children: _languageStore.supportedLanguages
            .map(
              (object) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(0.0),
                title: Text(
                  object.language!,
                  style: TextStyle(
                    color: _languageStore.locale == object.locale
                        ? Theme.of(context).primaryColor
                        : _themeStore.darkMode
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // change user language based on selected locale
                  _languageStore.changeLanguage(object.locale!);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  _showDialog<T>({required BuildContext context, required Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T? value) {
      // The value passed to Navigator.pop() or null.
    });
  }
}
