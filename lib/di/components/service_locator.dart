import 'package:saintpopekerollosvi/data/local/datasources/post/post_datasource.dart';
import 'package:saintpopekerollosvi/data/network/apis/posts/post_api.dart';
import 'package:saintpopekerollosvi/data/network/dio_client.dart';
import 'package:saintpopekerollosvi/data/network/rest_client.dart';
import 'package:saintpopekerollosvi/data/repository.dart';
import 'package:saintpopekerollosvi/data/sharedpref/shared_preference_helper.dart';
import 'package:saintpopekerollosvi/di/module/local_module.dart';
import 'package:saintpopekerollosvi/di/module/network_module.dart';
import 'package:saintpopekerollosvi/stores/error/error_store.dart';
import 'package:saintpopekerollosvi/stores/form/form_store.dart';
import 'package:saintpopekerollosvi/stores/language/language_store.dart';
import 'package:saintpopekerollosvi/stores/post/post_store.dart';
import 'package:saintpopekerollosvi/stores/theme/theme_store.dart';
import 'package:saintpopekerollosvi/stores/user/user_store.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/network/apis/calendar/calendar_api.dart';
import '../../data/network/apis/video/video_api.dart';
import '../../data/network/calendar_repository.dart';
import '../../data/network/video_repository.dart';
import '../../stores/calendar/calendar_store.dart';
import '../../stores/video/video_store.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // factories:-----------------------------------------------------------------
  getIt.registerFactory(() => ErrorStore());
  getIt.registerFactory(() => FormStore());

  // async singletons:----------------------------------------------------------
  getIt.registerSingletonAsync<Database>(() => LocalModule.provideDatabase());
  getIt.registerSingletonAsync<SharedPreferences>(() => LocalModule.provideSharedPreferences());

  // singletons:----------------------------------------------------------------
  getIt.registerSingleton(SharedPreferenceHelper(await getIt.getAsync<SharedPreferences>()));
  getIt.registerSingleton<Dio>(NetworkModule.provideDio(getIt<SharedPreferenceHelper>()));
  getIt.registerSingleton(DioClient(getIt<Dio>()));
  getIt.registerSingleton(RestClient());

  // api's:---------------------------------------------------------------------
  getIt.registerSingleton(PostApi(getIt<DioClient>(), getIt<RestClient>()));
  getIt.registerSingleton(VideoApi(getIt<DioClient>()));
  getIt.registerSingleton(CalendarApi(getIt<DioClient>()));

  // data sources
  getIt.registerSingleton(PostDataSource(await getIt.getAsync<Database>()));

  // repository:----------------------------------------------------------------
  getIt.registerSingleton(Repository(
    getIt<PostApi>(),
    getIt<SharedPreferenceHelper>(),
    getIt<PostDataSource>(),
  ));
  getIt.registerSingleton(VideoRepository(
    getIt<VideoApi>(),
    getIt<SharedPreferenceHelper>(),
  ));
  getIt.registerSingleton(CalendarRepository(
    getIt<CalendarApi>(),
    getIt<SharedPreferenceHelper>(),
  ));

  // stores:--------------------------------------------------------------------
  getIt.registerSingleton(LanguageStore(getIt<Repository>()));
  getIt.registerSingleton(PostStore(getIt<Repository>()));
  getIt.registerSingleton(ThemeStore(getIt<Repository>()));
  getIt.registerSingleton(UserStore(getIt<Repository>()));
  getIt.registerSingleton(VideoStore(getIt<VideoRepository>()));
  getIt.registerSingleton(CalendarStore(getIt<CalendarRepository>()));
}
