//
//  SSKeychain+KSUtil.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "SSKeychain.h"

@interface SSKeychain (KSUtil)

+ (NSString *)rawLogin;
+ (NSString *)password;
+ (NSString *)accessToken;

+ (BOOL)setRawLogin:(NSString *)rawLogin;
+ (BOOL)setPassword:(NSString *)password;
+ (BOOL)setAccessToken:(NSString *)accessToken;

+ (BOOL)deleteRawLogin;
+ (BOOL)deletePassword;
+ (BOOL)deleteAccessToken;


@end
