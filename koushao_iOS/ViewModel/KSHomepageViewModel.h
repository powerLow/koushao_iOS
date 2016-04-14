//
//  KSHomepageViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSTabBarViewModel.h"
#import "KSProfileViewModel.h"
#import "KSActivityListViewModel.h"

@interface KSHomepageViewModel : KSTabBarViewModel

@property(nonatomic, strong, readonly) KSActivityListViewModel *activityListViewModel;

@property(nonatomic, strong, readonly) KSProfileViewModel *profileViewModel;

@property (nonatomic,strong,readonly) RACCommand *didLogoutBtnClick;

@property(nonatomic,assign)BOOL isStartButtonPressed;
@end
