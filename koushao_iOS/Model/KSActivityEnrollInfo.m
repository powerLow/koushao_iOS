//
//  KSActivityEnrollInfo.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityEnrollInfo.h"
#import "KSActivity.h"
@implementation KSActivityTickets
@end
@implementation KSActivityEnrollInfo

//类别是购票还是报名,YES报名,NO购票
- (BOOL)isEnroll{
    if ([self.gender[@"male"] unsignedIntegerValue] != 0
        || [self.gender[@"female"] unsignedIntegerValue] != 0) {
        return YES;
    }else{
        return NO;
    }
    
    
}

#pragma makr -
- (BOOL)ks_saveOrUpdate{
    NSDictionary *dict = self.mj_keyValues;
    YTKKeyValueStore *store = [KSUtil getUserDB];
    KSActivity *curAct = [KSUtil getCurrentActivity];
    NSString *dbKey = [NSString stringWithFormat:@"%@%@",DB_ID_ENROLLINFO,curAct.sig];
    [store putObject:dict withId:dbKey intoTable:KS_DATABASE_TABLENAME_MYINFO];
    return YES;
}
- (BOOL)ks_delete {
    YTKKeyValueStore *store = [KSUtil getUserDB];
    KSActivity *curAct = [KSUtil getCurrentActivity];
    NSString *dbKey = [NSString stringWithFormat:@"%@%@",DB_ID_ENROLLINFO,curAct.sig];
    [store deleteObjectById:dbKey fromTable:KS_DATABASE_TABLENAME_MYINFO];
    return YES;
}
+ (instancetype)ks_fetch{
    YTKKeyValueStore *store = [KSUtil getUserDB];
    KSActivity *curAct = [KSUtil getCurrentActivity];
    NSString *dbKey = [NSString stringWithFormat:@"%@%@",DB_ID_ENROLLINFO,curAct.sig];
    NSDictionary *dict = [store getObjectById:dbKey fromTable:KS_DATABASE_TABLENAME_MYINFO];
    return [KSActivityEnrollInfo mj_objectWithKeyValues:dict];
}

@end
