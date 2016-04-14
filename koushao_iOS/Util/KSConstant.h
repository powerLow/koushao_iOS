//
//  KSConstant.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#ifndef KSConstant_h
#define KSConstant_h

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

///------
/// NSLog
///------

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

///------
/// Block
///------

typedef void (^VoidBlock)();
typedef BOOL (^BoolBlock)();
typedef int  (^IntBlock) ();
typedef id   (^IDBlock)  ();

typedef void (^VoidBlock_int)(int);
typedef BOOL (^BoolBlock_int)(int);
typedef int  (^IntBlock_int) (int);
typedef id   (^IDBlock_int)  (int);

typedef void (^VoidBlock_string)(NSString *);
typedef BOOL (^BoolBlock_string)(NSString *);
typedef int  (^IntBlock_string) (NSString *);
typedef id   (^IDBlock_string)  (NSString *);

typedef void (^VoidBlock_id)(id);
typedef BOOL (^BoolBlock_id)(id);
typedef int  (^IntBlock_id) (id);

///------
/// Color
///------

#define RGB(r, g, b) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define RGBAlpha(r, g, b, a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HexRGBAlpha(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]


#define BASE_COLOR      HexRGB(0x2CBD86)
#define KS_GrayColor_BackColor   HexRGB(0xF2F2F2)
#define KS_GrayColor0   HexRGB(0xE5E5E5)
#define KS_GrayColor    HexRGB(0xDDDDDD)
#define KS_GrayColor2   HexRGB(0xD1D1D1)
#define KS_GrayColor3   HexRGB(0xBEBEBE)
#define KS_GrayColor4   HexRGB(0x969696)
#define KS_PLACEHOLDER_IMAGE [HexRGB(0xEDEDED) color2Image]
#define KS_Maintheme_Color [KSUtil colorWithHexString:@"#34BC87"]
#define KS_Maintheme_Color2  [KSUtil colorWithHexString:@"#FDA45F"]
#define KS_SANDBOX @"KS_SANDBOX_"

#define KS_EMPTY_PLACEHOLDER @"Not Set"
#define DB_ID_KS_ACTIVITY_CREAT_MANAGER @"KS_ACTIVITY_CREAT_MANAGER"
#define DB_ID_KS_APP_SETTINGS @"KS_APP_SETTINGS"
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define LOCAL_IMAGE_DIC [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define KS_ALERT_TITLE @"提示:"
#define MBPROGRESSHUD_LABEL_TEXT @"加载中..."
#define NOTIFICATION_IMAGE_UPLOAD @"NOTIFICATION_IMAGE_UPLOAD"
#define NOTIFICATION_NEW_CONSULT @"NOTIFICATION_NEW_CONSULT"
#define REFRESH_ACTIVITY_LIST @"REFRESH_ACTIVITY_LIST"
#define ACTIVITY_PUBLISH_FINISH @"ACTIVITY_PUBLISH_FINISH"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define KS_LEFT_IMAGE_SIZE CGSizeMake(25, 25)
#define KS_1PX_WIDTH (1 / [UIScreen mainScreen].scale)

#define KS_SMALL_FONT [UIFont fontWithName:@"Arial" size:14]
#define KS_FONT_15 [UIFont fontWithName:@"Arial" size:15]
#define KS_FONT_16 [UIFont fontWithName:@"Arial" size:16]
#define KS_FONT_17 [UIFont fontWithName:@"Arial" size:17]
#define KS_FONT_18 [UIFont fontWithName:@"Arial" size:18]
#define KS_FONT_19 [UIFont fontWithName:@"Arial" size:19]
#define KS_NORMAL_FONT [UIFont fontWithName:@"Arial" size:20]
#define KS_NORMAL_BOLD_FONT [UIFont fontWithName:@"Helvetica-Bold" size:20]
#define KS_BIG_FONT [UIFont fontWithName:@"Arial" size:30]
#define KS_BIG_BOLD_FONT [UIFont fontWithName:@"Helvetica-Bold" size:30]
// 判别是否iOS7或以上版本系统
#define iOS7 ([UIDevice currentDevice].systemVersion.doubleValue >= 7.0)

// 判别是否iOS8或以上版本系统
#define iOS8 ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0)

///---------
/// App Info
///---------

#define KSApplicationVersionKey @"KSApplicationVersionKey"

#define KS_APP_ID        @""
#define KS_APP_STORE_URL @"https://itunes.apple.com/cn/app/id" MRC_APP_ID"?mt=8"

#define KS_APP_NAME    ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"])
#define KS_APP_VERSION ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
#define KS_APP_BUILD   ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])

#define PREVIEW_URL @"http://m.koushaoapp.com/activity/"



#endif /* KSConstant_h */
