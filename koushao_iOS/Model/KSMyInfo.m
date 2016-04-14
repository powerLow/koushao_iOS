//
//  KSMyInfo.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/21.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSMyInfo.h"
@interface KSMyInfo()



//举办活动数目
@property (nonatomic, strong, readwrite) NSNumber *count;
//访问人数
@property (nonatomic, strong, readwrite) NSNumber *visits;
//感兴趣人数
@property (nonatomic, strong, readwrite) NSNumber *interested;
//报名人数
@property (nonatomic, strong, readwrite) NSNumber *enroll;

@end
@implementation KSMyInfo

-(instancetype)initWithCount:(NSNumber*)count visits:(NSNumber*)visits interested:(NSNumber*)interested
                      enroll:(NSNumber*)enroll{
    self = [super init];
    if (self) {
        self.count =count;
        self.visits = visits;
        self.interested = interested;
        self.enroll = enroll;
    }
    return self;
}
#pragma mark - KSPersistenceProtocol
- (BOOL)ks_saveOrUpdate{
    NSDictionary *dict = self.mj_keyValues;
    YTKKeyValueStore *store = [KSUtil getUserDB];
    [store putObject:dict withId:DB_ID_KSMYINFO intoTable:KS_DATABASE_TABLENAME_MYINFO];
    return YES;
}
- (BOOL)ks_delete {
    YTKKeyValueStore *store = [KSUtil getUserDB];
    [store deleteObjectById:DB_ID_KSMYINFO fromTable:KS_DATABASE_TABLENAME_MYINFO];
    return YES;
}
+ (instancetype)ks_fetchById:(NSString *)key {
    YTKKeyValueStore *store = [KSUtil getUserDB];
    NSDictionary *dict = [store getObjectById:DB_ID_KSMYINFO fromTable:KS_DATABASE_TABLENAME_MYINFO];
    return [KSMyInfo mj_objectWithKeyValues:dict];
}
@end
