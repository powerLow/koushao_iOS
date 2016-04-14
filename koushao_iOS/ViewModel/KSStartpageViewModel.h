//
//  KSStartpageViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/13.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"

@interface KSStartpageViewModel : KSViewModel

//手机号登陆
@property(nonatomic, strong, readonly) RACCommand *loginWithPhoneCommand;

//子账号登陆
@property(nonatomic, strong, readonly) RACCommand *loginWithSubAccountCommand;

//发起活动
@property(nonatomic, strong, readonly) RACCommand *beginActivityCommand;

//发布活动成功,跳转到活动列表页面
@property(nonatomic, strong, readonly) RACCommand *loginCommand;
@end
