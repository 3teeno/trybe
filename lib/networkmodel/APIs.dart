import 'package:flutter/cupertino.dart';

class APIs {
  APIs._();

  static const String baseUrl =
      "https://www.3dmagicaldesigns.com/developments/trybelockr/api";
  static const String treeShare =
      "http://www.3dmagicaldesigns.com/developments/trybelockr";

  static const String userpostimagesbaseurl =
      "https://www.3dmagicaldesigns.com/developments/trybelockr/public/post-images/";

  static const String userprofilebaseurl =
      "https://www.3dmagicaldesigns.com/developments/trybelockr/public/user-profile-images/";

  static const String userstoriesbaseurl =
      "https://www.3dmagicaldesigns.com/developments/trybelockr/public/users-stories/";

  static const String userpostvideosbaseurl =
      "https://www.3dmagicaldesigns.com/developments/trybelockr/public/post-videos/";
  static const String user_cover_photo =
      "https://www.3dmagicaldesigns.com/developments/trybelockr/public/user-cover-photos/";

  static const String registrationUrl = "$baseUrl/user-registration";
  static const String loginUrl = "$baseUrl/user-login";
  static const String updateprofile = "$baseUrl/update-user-profile";

  static const String sendotptoresetpassword =
      "$baseUrl/send-otp-to-reset-password";
  static const String receiveotptoresetpassword =
      "$baseUrl/receive-otp-to-reset-password";
  static const String createpost = "$baseUrl/create-post";

  static const String sociallogin = "$baseUrl/social-login";

  static const String getallposts = "$baseUrl/posts-of-home-screen";

  static const String likepost = "$baseUrl/activities-on-post";

  static const String notification = "$baseUrl/notifications";

  static const String getallcomment = "$baseUrl/all-comments-of-post";

  static const String postcomment = "$baseUrl/activities-on-post";

  static const String reportpost = "$baseUrl/report-a-post";

  static const String setnewpassword = "$baseUrl/set-new-password";

  static const String createcollection = "$baseUrl/create-collection";

  static const String allcollectionlist = "$baseUrl/collections";

  static const String savepsotcollection =
      "$baseUrl/save-unsave-post-under-collection";

  static const String treebegrouplist = "$baseUrl/trees";

  static const String createtrybetree = "$baseUrl/create-tree";

  static const String followunfollow = "$baseUrl/follow-unfollow";
  static const String deletetrybe = "$baseUrl/delete-tree";
  static const String renametrybe = "$baseUrl/update-tree";
  static const String deleteTreeMember = "$baseUrl/delete-tree-member";

  static const String getuserposts = "$baseUrl/posts";
  static const String globalusersearch = "$baseUrl/user-global-search";
  static const String globalpostsearch = "$baseUrl/post-global-search";
  static const String getallvideos = "$baseUrl/get-all-video-posts";

  static const String getallimages = "$baseUrl/get-all-images-posts";

  static const String fulldetailpost = "$baseUrl/full-detail-of-post";
  static const String getpostcollection = "$baseUrl/get-posts-under-collection";
  static const String addtrybemember = "$baseUrl/add-member-in-tree";
  static const String getmembertree = "$baseUrl/get-member-of-tree";
  static const String getrecentuserlist = "$baseUrl/get-recent-users";

  static const String resetpassword = "$baseUrl/reset-password";

  static const String getrecentsearchlist = "$baseUrl/get-all-recent-searches";
  static const String deleteuseraccount = "$baseUrl/delete-user-account";
  static const String sendstripetoken = "$baseUrl/stripe";

  static const String createplaylist = "$baseUrl/create-playlist";
  static const String getplaylist = "$baseUrl/playlists";
  static const String saveplaylist = "$baseUrl/save-unsave-post-under-playlist";
  static const String getplaylistpost = "$baseUrl/get-posts-under-playlist";

  static const String changeprivacy = "$baseUrl/make-data-private";

  static const String logoutapi = "$baseUrl/logout";
  static const String creategroundedaccount =
      "$baseUrl/create-grounded-account";
  static const String groundaccountlist =
      "$baseUrl/get-all-grounded-account-of-user";

  static const String notificationoff = "$baseUrl/make-notification-off";

  static const String acceptcancelrequest = "$baseUrl/accept-reject";
  static const String acceptcancelexecutorrequest =
      "$baseUrl/account-executor-accept";

  static const String searchfollowfollowing = "$baseUrl/user-fan-follow-search";

  static const String saveposttohistory =
      "$baseUrl/save-recent-viewed-video-posts";
  static const String showhistorylist =
      "$baseUrl/get-recent-viewed-video-posts";

  static const String accountexecutorrequest =
      "$baseUrl/account-executor-request";
  static const String contactus = "$baseUrl/contact-us";
  static const String acceptedexecutorlist = "$baseUrl/accepted-executor-list";
  static const String requestedexecutorlist= "$baseUrl/requested-executor-list";
  static const String deleteexecutoraccount= "$baseUrl/delete-executor-account";
  static const String supportus= "$baseUrl/support-us";
  static const String requesttransfergroundedaccount= "$baseUrl/request-transfer-grounded-account";
  static const String acceptrejecttransfergroundedaccount= "$baseUrl/accept-reject-transfer-grounded-account";
  static const String saveviewbycollection= "$baseUrl/save-view-by-collection";





  static BuildContext buildcontext;
}
