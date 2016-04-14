//
//  KSTabbar.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/14.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSTabbar;
@protocol KSTabBarDelegate <UITabBarDelegate>

@optional
- (void) tabBarDidComposeButtonClick:(KSTabbar *) tabBar;

@end

@interface KSTabbar : UITabBar

//由于tabBar原来就有一个delegate，必须区分开来
@property(nonatomic, weak) id<KSTabBarDelegate> ksTabBarDelegate;

@end
