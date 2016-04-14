//
//  KSActivity.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/14.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivity.h"

@implementation KSActivityAttrModuleModel


@end
@implementation KSActivityAttrTicketModel


@end
@implementation KSActivityAttrModel

@end

@implementation KSActivity

+ (NSDictionary *)replacedKeyFromPropertyName {
    
    return @{
             @"hashCode" : @"hash",
             };
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"attr":[KSActivityAttrModel class],
             };
}
#pragma mark - KSPersistenceProtocol
- (BOOL)ks_saveOrUpdate{
    NSDictionary *dict = [self mj_keyValuesWithIgnoredKeys:@[@"thumbnail"]];
//    NSLog(@"Activity Dict = %@",dict);
    YTKKeyValueStore *store = [KSUtil getUserDB];
    [store putObject:dict withId:self.sig intoTable:KS_DATABASE_TABLENAME_ACTIVITY];
    return YES;
}
- (BOOL)ks_delete {
    YTKKeyValueStore *store = [KSUtil getUserDB];
    [store deleteObjectById:self.sig fromTable:KS_DATABASE_TABLENAME_ACTIVITY];
    return YES;
}
+ (void)ks_saveActivitys:(NSArray*)activitys {
    for (KSActivity* item in activitys) {
        [item ks_saveOrUpdate];
    }
}

+ (void)ks_deleteActivitys {
    YTKKeyValueStore *store = [KSUtil getUserDB];
    [store clearTable:KS_DATABASE_TABLENAME_ACTIVITY];
}

+ (NSArray*)ks_fetchActivitys {
    
    YTKKeyValueStore *store = [KSUtil getUserDB];
    NSArray* dicts = [store getAllItemsFromTable:KS_DATABASE_TABLENAME_ACTIVITY];
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[dicts count]];
    for (YTKKeyValueItem* dict in dicts) {
        NSLog(@"cache dict = %@",dict);
        NSDictionary *value = dict.itemObject;
        KSActivity *act = [KSActivity mj_objectWithKeyValues:value];
        [items addObject:act];
    }
    return items;
}

@end

@implementation KSActivityList

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"activityList" : @"result.activity_list",
             };
}

@end
