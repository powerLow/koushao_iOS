//
//  SSKeychain+KSUtil.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "SSKeychain+KSUtil.h"

@implementation SSKeychain (KSUtil)



+ (NSString *)rawLogin {
    NSString *rawLogin = [[NSUserDefaults standardUserDefaults] objectForKey:KS_RAW_LOGIN];
    if (rawLogin == nil) NSLog(@"+rawLogin: %@", rawLogin);
    return rawLogin;
}

+ (NSString *)password {
    return [self passwordForService:KS_SERVICE_NAME account:KS_PASSWORD];
}

+ (NSString *)accessToken {
    return [self passwordForService:KS_SERVICE_NAME account:KS_ACCESS_TOKEN];
}

+ (BOOL)setRawLogin:(NSString *)rawLogin {
    if (rawLogin == nil) NSLog(@"+setRawLogin: %@", rawLogin);
    
    [[NSUserDefaults standardUserDefaults] setObject:rawLogin forKey:KS_RAW_LOGIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

+ (BOOL)setPassword:(NSString *)password {
    return [self setPassword:password forService:KS_SERVICE_NAME account:KS_PASSWORD];
}

+ (BOOL)setAccessToken:(NSString *)accessToken {
    return [self setPassword:accessToken forService:KS_SERVICE_NAME account:KS_ACCESS_TOKEN];
}

+ (BOOL)deleteRawLogin {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KS_RAW_LOGIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

+ (BOOL)deletePassword {
    return [self deletePasswordForService:KS_SERVICE_NAME account:KS_PASSWORD];
}

+ (BOOL)deleteAccessToken {
    return [self deletePasswordForService:KS_SERVICE_NAME account:KS_ACCESS_TOKEN];
}

@end
