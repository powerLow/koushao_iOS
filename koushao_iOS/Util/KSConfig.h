//
//  KSConfig.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#ifndef KSConfig_h
#define KSConfig_h


///------------
/// AppDelegate
///------------

#define KSSharedAppDelegate ((KSAppDelegate *)[UIApplication sharedApplication].delegate)

///------------
/// Client Info
///------------
//友盟
#define UMENG_APPKEY @"5545d79a67e58eac900024cc"
//微信
//#define WeixinID @"wx7624d66475e59323"
//#define WeixinSecretKey @"00fab6a4b888586fa85589f5ed42968a"
#define WeixinID @"wxf3356f190c3c2046"
#define WeixinSecretKey @"2c2ab05eb35aeb390220b8caa73a6e98"
//微博
#define WeiBoID @"3918506055"
#define WeiBoSecretKey @"387593c7741ce4d88c82e0f97b698079"
//#define WeiBoRedirectURI @"https://leancloud.cn/1.1/sns/callback/j0kqmk6h9x7wnf0v"
//#define WeiBoRedirectURI @"http://h5.koushaoapp.com/login/auth/weibo/callback"
#define WeiBoRedirectURI @"https://passport.koushaoapp.com/login/auth/weibocallback"
//QQ
//#define QQID @"101205964"
//#define QQKey @"b959174435a0865f306863a73483377b"
#define QQID @"1104312750"
#define QQKey @"IhagZwSBszUgIn51"
///-----------
/// DateBase
///-----------

#define KS_DATABASE_NAME @"data.db"
#define KS_DATABASE_TABLENAME_USER @"user"
#define KS_DATABASE_TABLENAME_ACTIVITY @"activity"
#define KS_DATABASE_TABLENAME_MYINFO @"myinfo"
#define KS_DATABASE_TABLENAME_ACTIVITY_CREAT_MANAGER @"ACTIVITY_CREAT_MANAGER"
#define KS_DATABASE_TABLENAME_APP_SETTINGS @"APP_SETTINGS"
///-----------
/// SSKeychain
///-----------

#define KS_SERVICE_NAME @"com.koushaoapp.whistle"
#define KS_RAW_LOGIN    @"RawLogin"
#define KS_PASSWORD     @"Password"
#define KS_ACCESS_TOKEN @"AccessToken"
///-----------
/// URL Scheme
///-----------

#define KS_URL_SCHEME @"koushaoapp_iOS"

///----------------------
/// Persistence Directory
///----------------------

#define KS_DOCUMENT_DIRECTORY NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

#endif /* KSConfig_h */
