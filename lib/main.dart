import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/src/change_notifier_provider.dart';
import 'package:provider/src/provider.dart';
import 'package:trybelocker/Recentpostuserlist.dart';
import 'package:trybelocker/comments.dart';
import 'package:trybelocker/enums/enums.dart';
import 'package:trybelocker/home_screen.dart';
import 'package:trybelocker/login_screen.dart';
import 'package:trybelocker/networkmodel/APIs.dart';
import 'package:trybelocker/notifications.dart';
import 'package:trybelocker/profile/profile.dart';
import 'package:trybelocker/publicprofile/publicprofilescreen.dart';
import 'package:trybelocker/search.dart';
import 'package:trybelocker/service/service_locator.dart';
import 'package:trybelocker/settings/accountinfo/account_info.dart';
import 'package:trybelocker/settings/groundedaccounts/MyExecutorAccounts.dart';
import 'package:trybelocker/settings/groundedaccounts/contactUsScreen.dart';
import 'package:trybelocker/settings/groundedaccounts/create_grounded_account.dart';
import 'package:trybelocker/settings/groundedaccounts/deletegroundedaccount.dart';
import 'package:trybelocker/settings/groundedaccounts/executoraccountsSettings.dart';
import 'package:trybelocker/settings/groundedaccounts/grounded_account_executer.dart';
import 'package:trybelocker/settings/groundedaccounts/grounded_account_profile.dart';
import 'package:trybelocker/settings/groundedaccounts/grounded_accounts.dart';
import 'package:trybelocker/settings/groundedaccounts/groundedaccountprofilesettings.dart';
import 'package:trybelocker/settings/groundedaccounts/manage_grounded_accounts.dart';
import 'package:trybelocker/settings/groundedaccounts/privacyScreen.dart';
import 'package:trybelocker/settings/groundedaccounts/transfergroundedaccount.dart';
import 'package:trybelocker/settings/groundedaccounts/viewexecuter.dart';
import 'package:trybelocker/settings/resetpassword/reset_password.dart';
import 'package:trybelocker/settings/settings.dart';
import 'package:trybelocker/settings/supportUs/SupportProjectScreen.dart';
import 'package:trybelocker/settings/supportUs/SupportUsScreen.dart';
import 'package:trybelocker/settings/switchaccount/switch_account.dart';
import 'package:trybelocker/social_login.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/SupportUsViewModel.dart';
import 'package:trybelocker/viewmodel/accountexecutor_viewmodel.dart';
import 'package:trybelocker/viewmodel/allvideos_view_model.dart';
import 'package:trybelocker/viewmodel/auth_view_model.dart';
import 'package:trybelocker/viewmodel/collection_list_view_model.dart';
import 'package:trybelocker/viewmodel/createpost_view_model.dart';
import 'package:trybelocker/viewmodel/favourites_view_model.dart';
import 'package:trybelocker/viewmodel/get_playlist_viewmodel.dart';
import 'package:trybelocker/viewmodel/groundedAccount_viewmodel.dart';
import 'package:trybelocker/viewmodel/home_view_model.dart';
import 'package:trybelocker/viewmodel/news_view_model.dart';
import 'package:trybelocker/viewmodel/notification_view_model.dart';
import 'package:trybelocker/viewmodel/post_details_view_model.dart';
import 'package:trybelocker/viewmodel/profile_view_model.dart';
import 'package:trybelocker/viewmodel/publicprofileviewmodel.dart';
import 'package:trybelocker/viewmodel/recentuserpostviewmodel.dart';
import 'package:trybelocker/viewmodel/search_view_model.dart';
import 'package:trybelocker/viewmodel/setting_view_model.dart';
import 'package:trybelocker/viewmodel/trybe_tree_viewmodel.dart';
import 'package:trybelocker/viewmodel/videoplayerviewmodel.dart';

import 'UniversalFunctions.dart';
import 'createpost/create_post.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  await MemoryManagement.init(); //initialize the shared preference once
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  // await FirebaseCrashlytics.instance.crash();

  await MemoryManagement.init(); //initial
  setupServiceLocator();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) async {
    var isUserLoggedIn = MemoryManagement.getUserLoggedIn() ?? false;
    //load user model to instance
    // if(isUserLoggedIn)
    // {
    //   MODELUser modelUser = SessionData().modelUser;
    //   if (modelUser == null) {
    //     modelUser = MODELUser();
    //     SessionData().modelUser = modelUser;
    //   }
    //   var response =LoginResponse.fromJson(json.decode(MemoryManagement.getUserData()));
    //   modelUser.loginResponse = response;
    // }
    runApp(
      MultiProvider(providers: [
        Provider<Flavor>.value(value: Flavor.dev),
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) => AuthViewModel(),
        ),
        ChangeNotifierProvider<HomeViewModel>(
          create: (context) => HomeViewModel(),
        ),
        ChangeNotifierProvider<PublicProfileViewModel>(
          create: (context) => PublicProfileViewModel(),
        ),
        ChangeNotifierProvider<CollectionListViewModel>(
          create: (context) => CollectionListViewModel(),
        ),
        ChangeNotifierProvider<FavouritesViewModel>(
          create: (context) => FavouritesViewModel(),
        ),
        ChangeNotifierProvider<TrybeTreeViewModel>(
          create: (context) => TrybeTreeViewModel(),
        ),
        ChangeNotifierProvider<ProfileViewModel>(
          create: (context) => ProfileViewModel(),
        ),
        ChangeNotifierProvider<PostDetailsViewModel>(
          create: (context) => PostDetailsViewModel(),
        ),
        ChangeNotifierProvider<NewsViewModel>(
          create: (context) => NewsViewModel(),
        ),
        ChangeNotifierProvider<GetPlayListViewModel>(
          create: (context) => GetPlayListViewModel(),
        ),
        ChangeNotifierProvider<SettingViewModel>(
          create: (context) => SettingViewModel(),
        ),
        ChangeNotifierProvider<SearchViewModel>(
          create: (context) => SearchViewModel(),
        ),
        ChangeNotifierProvider<NotificationViewModel>(
          create: (context) => NotificationViewModel(),
        ),
        ChangeNotifierProvider<AllVideosViewModel>(
          create: (context) => AllVideosViewModel(),
        ),
        ChangeNotifierProvider<RecentUserPostViewModel>(
          create: (context) => RecentUserPostViewModel(),
        ),
        ChangeNotifierProvider<GroundedAccountViewModel>(
          create: (context) => GroundedAccountViewModel(),
        ),
        ChangeNotifierProvider<CreatePostViewModel>(
          create: (context) => CreatePostViewModel(),
        ),
        ChangeNotifierProvider<AccountExecutorViewModel>(
          create: (context) => AccountExecutorViewModel(),
        ),
        ChangeNotifierProvider<SupportUsViewModel>(
          create: (context) => SupportUsViewModel(),
        ),
        ChangeNotifierProvider<VideoPlayerViewModel>(
          create: (context) => VideoPlayerViewModel(),
        ),
      ], child: MyApp(isUserLoggedIn: isUserLoggedIn)),
    );
  });
}

class MyApp extends StatefulWidget {
  final bool isUserLoggedIn;

  MyApp({@required this.isUserLoggedIn});

  MyAppState createState() => MyAppState(isUserLoggedIn: isUserLoggedIn);
}

class MyAppState extends State<MyApp> {
  final bool isUserLoggedIn;

  MyAppState({@required this.isUserLoggedIn});

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        systemNavigationBarColor: getColorFromHex(AppColors.black),
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light));

    // requestmediapermission();
  }

  @override
  Widget build(BuildContext context) {
    APIs.buildcontext = context;
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => (!isUserLoggedIn) ? SocialLogin() : HomeScreen(),
        LoginScreen.TAG: (context) => LoginScreen(),
        CreatePost.TAG: (context) => CreatePost(),
        HomeScreen.TAG: (context) => HomeScreen(),
        SocialLogin.TAG: (context) => SocialLogin(),
        CommentScreen.TAG: (context) => CommentScreen(0),
        SettingsScreen.TAG: (context) => SettingsScreen(),
        AccountInfoScreen.TAG: (context) => AccountInfoScreen(),
        GroundedAcctScreen.TAG: (context) => GroundedAcctScreen(),
        CreateGroundedScreen.TAG: (context) => CreateGroundedScreen(false),
        GroundedProfileScreen.TAG: (context) => GroundedProfileScreen(),
        ManageGroundedAcctScreen.TAG: (context) => ManageGroundedAcctScreen(),
        // GroundedProfileEditScreen.TAG: (context) => GroundedProfileEditScreen(),
        SearchScreen.TAG: (context) => SearchScreen(),
        NotificationScreen.TAG: (context) => NotificationScreen(),
        GroundedAccountProfile.TAG: (context) => GroundedAccountProfile(),
        TransferUserlistGrouAcc.TAG: (context) => TransferUserlistGrouAcc(),
        GroundedExecuterAcc.TAG: (context) => GroundedExecuterAcc(),
        GroundedAccountExecuter.TAG: (context) => GroundedAccountExecuter(),
        Passwordreset.TAG: (context) => Passwordreset(),
        SwitchAcctScreen.TAG: (context) => SwitchAcctScreen(),
        ViewExecuterScreen.TAG: (context) => ViewExecuterScreen(),
        DeleteGroundedAccScreen.TAG: (context) => DeleteGroundedAccScreen(),
        PrivacyScreen.TAG: (context) => PrivacyScreen(),
        PublicProfileScreen.TAG: (context) => PublicProfileScreen(),
        RecentPostUserList.TAG: (context) => RecentPostUserList(),
        Profile.TAG: (context) => Profile(),
        ContactUsScreen.TAG: (context) => ContactUsScreen(),
        MyExecutorAccounts.TAG: (context) => MyExecutorAccounts(),
        SupportUsScreen.TAG: (context) => SupportUsScreen(),
        SupportProjectScreen.TAG: (context) => SupportProjectScreen(),

        //DeleteExecutorScreen.TAG:(context) => DeleteExecutorScreen()

        // PostPrivacy.TAG:(context)=>PostPrivacy(),
      },
    );
  }

  requestmediapermission() async {
    var result = await PhotoManager.requestPermission();
    if (result) {
    } else {
      print("please allow permission");
    }
  }
}
