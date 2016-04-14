//
//  KSApplicationSettings.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSApplicationSettings.h"

@implementation KSApplicationSettings
+ (KSApplicationSettings *)sharedManager
{
    static KSApplicationSettings *settingsInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        YTKKeyValueStore *store = [KSUtil getDatabase];
        NSDictionary *dict = [store getObjectById:DB_ID_KS_ACTIVITY_CREAT_MANAGER fromTable:KS_DATABASE_TABLENAME_ACTIVITY_CREAT_MANAGER];
        settingsInstance=[KSApplicationSettings mj_objectWithKeyValues:dict];
        if(!settingsInstance)
        {
            settingsInstance = [[self alloc] init];
            [settingsInstance ks_saveOrUpdate];
        }
    });
    return settingsInstance;
}
- (BOOL)ks_saveOrUpdate{
    NSDictionary *dict = self.mj_keyValues;
    YTKKeyValueStore *store = [KSUtil getDatabase];
    [store putObject:dict withId:DB_ID_KS_APP_SETTINGS intoTable:KS_DATABASE_TABLENAME_APP_SETTINGS];
    return YES;
}
- (BOOL)ks_delete {
    YTKKeyValueStore *store = [KSUtil getDatabase];
    [store deleteObjectById:DB_ID_KS_APP_SETTINGS fromTable:KS_DATABASE_TABLENAME_APP_SETTINGS];
    return YES;
}
+ (instancetype)ks_fetchById:(NSString *)key {
    YTKKeyValueStore *store = [KSUtil getDatabase];
    NSDictionary *dict = [store getObjectById:DB_ID_KS_APP_SETTINGS fromTable:KS_DATABASE_TABLENAME_APP_SETTINGS];
    return [KSApplicationSettings mj_objectWithKeyValues:dict];
}

@end
