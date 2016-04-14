//
//  KSMyMonelInfo.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/22.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSMyMoneyInfo.h"


@implementation KSMyMoneyInfo

#pragma mark - KSPersistenceProtocol
- (BOOL)ks_saveOrUpdate{
    NSDictionary *dict = self.mj_keyValues;
    YTKKeyValueStore *store = [KSUtil getUserDB];
    [store putObject:dict withId:DB_ID_KSMYMONEYINFO intoTable:KS_DATABASE_TABLENAME_MYINFO];
    return YES;
}
- (BOOL)ks_delete {
    YTKKeyValueStore *store = [KSUtil getUserDB];
    [store deleteObjectById:DB_ID_KSMYMONEYINFO fromTable:KS_DATABASE_TABLENAME_MYINFO];
    return YES;
}
+ (instancetype)ks_fetchById:(NSString *)key {
    YTKKeyValueStore *store = [KSUtil getUserDB];
    NSDictionary *dict = [store getObjectById:DB_ID_KSMYMONEYINFO fromTable:KS_DATABASE_TABLENAME_MYINFO];
    return [KSMyMoneyInfo mj_objectWithKeyValues:dict];
}

@end
