//
//  AppDelegate.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "WeiboSDK.h"
@class KSNavigationControllerStack;

@interface KSAppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong, readonly) KSNavigationControllerStack *navigationControllerStack;
@property (nonatomic, assign, readonly) NetworkStatus networkStatus;

@property (nonatomic, copy, readonly) NSString *adURL;

@end

