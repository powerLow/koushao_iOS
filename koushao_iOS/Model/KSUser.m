//
//  KSUser.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/13.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSUser.h"



static KSUser *_user = nil;

@implementation KSUserAttr



@end

@implementation KSUser


+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _user = [[KSUser alloc] init];
    });
    return _user;
}
+ (instancetype)currentUser {
    return [[KSMemoryCache sharedInstance] objectForKey:@"currentUser"];
}

+ (void)cacheUser:(KSUser*)user {
    if (user == nil) {
        [[KSMemoryCache sharedInstance] removeObjectForKey:@"currentUser"];
    }else{
        [[KSMemoryCache sharedInstance] setObject:user forKey:@"currentUser"];
    }
    
}

#pragma mark -
+ (instancetype)ks_fetchById:(NSString*)key; {
    YTKKeyValueStore *store = [KSUtil getDatabase];
    NSDictionary *userDic =  [store getObjectById:key fromTable:KS_DATABASE_TABLENAME_USER];
    if (userDic == nil) {
        return nil;
    }
    return [KSUser mj_objectWithKeyValues:userDic];
}
- (BOOL)ks_saveOrUpdate {
    NSDictionary *userDic = self.mj_keyValues;
    NSLog(@"userDic = %@",userDic);
    YTKKeyValueStore *store = [KSUtil getDatabase];
    [store putObject:userDic withId:self.username intoTable:KS_DATABASE_TABLENAME_USER];
    return YES;
}
- (BOOL)ks_delete {
    YTKKeyValueStore *store = [KSUtil getDatabase];
    [store deleteObjectById:self.username fromTable:KS_DATABASE_TABLENAME_USER];
    return YES;
}

#pragma mark Lifecycle

@end
