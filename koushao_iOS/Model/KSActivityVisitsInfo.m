//
//  KSActivityVisitsInfo.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/2.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityVisitsInfo.h"

#import "KSActivity.h"

@implementation KSActivityVisitsInfo

- (BOOL)ks_saveOrUpdate{
    NSDictionary *dict = self.mj_keyValues;
    YTKKeyValueStore *store = [KSUtil getUserDB];
    KSActivity *curAct = [KSUtil getCurrentActivity];
    NSString *dbKey = [NSString stringWithFormat:@"%@%@",DB_ID_VISITSINFO,curAct.sig];
    [store putObject:dict withId:dbKey intoTable:KS_DATABASE_TABLENAME_MYINFO];
    return YES;
}
- (BOOL)ks_delete {
    YTKKeyValueStore *store = [KSUtil getUserDB];
    KSActivity *curAct = [KSUtil getCurrentActivity];
    NSString *dbKey = [NSString stringWithFormat:@"%@%@",DB_ID_VISITSINFO,curAct.sig];
    [store deleteObjectById:dbKey fromTable:KS_DATABASE_TABLENAME_MYINFO];
    return YES;
}
+ (instancetype)ks_fetch{
    YTKKeyValueStore *store = [KSUtil getUserDB];
    KSActivity *curAct = [KSUtil getCurrentActivity];
    NSString *dbKey = [NSString stringWithFormat:@"%@%@",DB_ID_VISITSINFO,curAct.sig];
    NSDictionary *dict = [store getObjectById:dbKey fromTable:KS_DATABASE_TABLENAME_MYINFO];
    return [KSActivityVisitsInfo mj_objectWithKeyValues:dict];
}
@end
