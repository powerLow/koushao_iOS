//
//  KSLoginSubViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/13.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"

@interface KSLoginSubViewModel : KSViewModel
@property(nonatomic, copy, readonly) NSURL *avatarURL;
@property(nonatomic, copy, readwrite) NSString *username;
@property(nonatomic, copy, readwrite) NSString *password;

@property(nonatomic, strong, readonly) RACCommand *loginCommand;
@end
