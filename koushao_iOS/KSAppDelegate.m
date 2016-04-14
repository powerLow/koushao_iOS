//
//  AppDelegate.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSAppDelegate.h"
#import "KSViewModelServicesImpl.h"
#import "KSHomepageViewModel.h"
#import "KSHomepageViewController.h"
#import "KSNavigationControllerStack.h"
#import "KSNavigationController.h"
#import "KSStartpageViewModel.h"
#import "KSStartpageViewController.h"
#import "ActivityDetailViewController.h"
#import "YTKNetworkConfig.h"
#import "KSBaseApiRequest.h"
#import <MAMapKit/MAMapKit.h>
#import "APService.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "MobClick.h"//友盟分析

@interface KSAppDelegate ()

@property(nonatomic, strong) KSViewModelServicesImpl *services;
@property(nonatomic, strong) id <KSViewModelProtocol> viewModel;
@property(nonatomic, strong) Reachability *reachability;

@property(nonatomic, strong, readwrite) KSNavigationControllerStack *navigationControllerStack;
@property(nonatomic, assign, readwrite) NetworkStatus networkStatus;

@end

@implementation KSAppDelegate

- (void)umengTrack {
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    [MobClick setEncryptEnabled:YES];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //  友盟的方法本身是异步执行，所以不需要再异步调用
    [self umengTrack];
    [self configureUMengSocial];
    //微博sdk
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WeiBoID];
    //配置
    [self configureDatabase];
    [self configureAppearance];
    [self configureKeyboardManager];
    [self configureReachability];
    
    [self configureYTKNetwork];
    [self configureMAp];
    [self configurePushNotification:launchOptions];
    self.services = [[KSViewModelServicesImpl alloc] init];
    self.navigationControllerStack = [[KSNavigationControllerStack alloc] initWithServices:self.services];
    
    UINavigationController *nav = [[KSNavigationController alloc] initWithRootViewController:self.createInitialViewController];
    [self.navigationControllerStack pushNavigationController:nav];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    [[NSUserDefaults standardUserDefaults] setValue:KS_APP_VERSION forKey:KSApplicationVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    if([KSUser currentUser])
    {
        NSString* username=[KSUser currentUser].username;
        [APService setAlias:[KSUser currentUser].username callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
        [[KSClientApi registerDevice:username]subscribeNext:^(id x) {
            
        } error:^(NSError *error) {
            NSLog([error.userInfo objectForKey:@"tips"],nil);
            [KSUtil filterError:error params:self.services];
        }];
        
    }
    return YES;
}
-(void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}




- (UIViewController *)createInitialViewController {
    //判断用户是否已经登陆
    if ([SSKeychain rawLogin].isExist && [SSKeychain accessToken].isExist
        && [KSUser ks_fetchById:[SSKeychain rawLogin]] != nil) {
        KSUser *user = [KSUser ks_fetchById:[SSKeychain rawLogin]];
        [KSUser cacheUser:user];
        user.isLogin = YES;
        self.viewModel = [[KSHomepageViewModel alloc] initWithServices:self.services params:nil];
        return [[KSHomepageViewController alloc] initWithViewModel:self.viewModel];
    } else {
        self.viewModel = [[KSStartpageViewModel alloc] initWithServices:self.services params:nil];
        return [[KSStartpageViewController alloc] initWithViewModel:self.viewModel];
    }
}

- (void)configurePushNotification:(NSDictionary *)launchOptions
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    
    // Required
    [APService setupWithOption:launchOptions];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    NSLog(@"Notification:");
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    NSLog(userInfo,nil);
    [APService handleRemoteNotification:userInfo];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"Notification:");
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    if([userInfo objectForKey:@"view_controller"])
    {
        NSString* viewController=[userInfo objectForKey:@"view_controller"];
        if([viewController isEqualToString:@"consult"])
        {
            NSString* hashCode=[userInfo objectForKey:@"hash"];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NEW_CONSULT object:hashCode];
        }
    }
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}




- (void)configureDatabase {
    //数据库
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:KS_DATABASE_NAME];
    //用户表
    [store createTableWithName:KS_DATABASE_TABLENAME_USER];
    //活动发布
    [store createTableWithName:KS_DATABASE_TABLENAME_ACTIVITY_CREAT_MANAGER];
    //程序设置的缓存
    [store createTableWithName:KS_DATABASE_TABLENAME_APP_SETTINGS];
    //缓存
    [[KSMemoryCache sharedInstance] setObject:store forKey:@"database"];
}

- (void)configureYTKNetwork {
    YTKNetworkConfig *config = [YTKNetworkConfig sharedInstance];
    config.baseUrl = @"http://121.199.44.98:5000/1.0";
//    config.baseUrl = @"https://apidev.koushaoapp.com/1.0";
//    config.cdnUrl = @"https://api.koushaoapp.com/1.0";
    
}

- (void)configureAppearance {
    self.window.backgroundColor = UIColor.whiteColor;
    
    // 0x2CBD86
    //    [UINavigationBar appearance].barTintColor = HexRGB(BASE_COLOR);
    [[UINavigationBar appearance] setBackgroundImage:BASE_COLOR.color2Image forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].barStyle = UIBarStyleBlack;
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    
    [UISegmentedControl appearance].tintColor = [UIColor whiteColor];
    
    [UITabBar appearance].tintColor = HexRGB(0x0000FF);
}

- (void)configureKeyboardManager {
    IQKeyboardManager.sharedManager.enableAutoToolbar = NO;
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = YES;
}


- (void)configureReachability {
    self.reachability = Reachability.reachabilityForInternetConnection;
    
    RAC(self, networkStatus) = [[[[NSNotificationCenter.defaultCenter
                                   rac_addObserverForName:kReachabilityChangedNotification object:nil]
                                  map:^id(NSNotification *notification) {
                                      return @([notification.object currentReachabilityStatus]);
                                  }]
                                 startWith:@(self.reachability.currentReachabilityStatus)]
                                distinctUntilChanged];
    
    @weakify(self)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self)
        [self.reachability startNotifier];
    });
}

- (void)configureUMengSocial {
    [UMSocialData setAppKey:UMENG_APPKEY];
    [UMSocialQQHandler setQQWithAppId:QQID appKey:QQKey url:@"http://www.koushaoapp.com"];
    [UMSocialWechatHandler setWXAppId:WeixinID appSecret:WeixinSecretKey url:@"http://www.koushaoapp.com"];
    [UMSocialSinaHandler openSSOWithRedirectURL:WeiBoRedirectURI];
}

- (void)configureMAp {
    [MAMapServices sharedServices].apiKey = @"cb83273f0b6ed693f5f8009f8f4b94ce";
    [AMapSearchServices sharedServices].apiKey = @"cb83273f0b6ed693f5f8009f8f4b94ce";
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [UMSocialSnsService handleOpenURL:url]
    || [WeiboSDK handleOpenURL:url delegate:self ];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [UMSocialSnsService handleOpenURL:url]
    || [WeiboSDK handleOpenURL:url delegate:self ];
}

#pragma mark - WeiboSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    NSLog(@"WBBaseRequest = %@",request);
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    NSLog(@"WBBaseResponse = %@",response);
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        if (response.statusCode == -1) {
            KSError(@"分享到微博失败");
        }else{
            KSSuccess(@"分享到微博成功");
        }
        //        NSString *title = NSLocalizedString(@"发送结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
        NSLog(@"发送结果 = %@",message);
        //        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        //        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        //        if (accessToken)
        //        {
        //            self.wbtoken = accessToken;
        //        }
        //        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        //        if (userID) {
        //            self.wbCurrentUserID = userID;
        //        }
        
    }
}
@end
