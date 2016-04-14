//
//  KSLoginViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"

@interface KSLoginViewModel : KSViewModel

@property(nonatomic, copy, readonly) NSURL *avatarURL;
@property(nonatomic, copy, readwrite) NSString *mobilePhone;
@property(nonatomic, copy, readwrite) NSString *smscode;

@property(nonatomic, strong, readonly) RACSignal *validLoginSignal;

@property(nonatomic, strong, readonly) RACCommand *loginCommand;
@property(nonatomic, strong, readonly) RACCommand *requestSmsCommand;
@property(nonatomic, assign, readonly) BOOL isSmsRequestSuccess;
@end
