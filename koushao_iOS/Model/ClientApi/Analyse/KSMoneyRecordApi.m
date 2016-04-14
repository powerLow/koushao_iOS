//
//  KSMoneyRecordApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/5.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSMoneyRecordApi.h"



@interface KSMoneyRecordApi()

@property (nonatomic,assign) KSMoneyRecordApiType record_type;
@property (nonatomic,strong) NSNumber* limit;
@property (nonatomic,assign) KSRequestRefreshType refresh_type;
@property (nonatomic,strong) NSNumber *mid;

@end

@implementation KSMoneyRecordApi

- (instancetype)initWithId:(NSNumber*)mid
              record_type:(KSMoneyRecordApiType)record_type
             refresh_type:(KSRequestRefreshType)refresh_type
                    limit:(NSNumber*)limit{
    self = [super init];
    if (self) {
        self.mid = mid;
        self.limit = limit;
        self.record_type = record_type;
        self.refresh_type = refresh_type;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/analyse/moneyrecord";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    NSDictionary *params =  @{
                              @"record_type":@(_record_type),
                              @"limit":_limit,
                              @"refresh_type":@(_refresh_type),
                              @"mid":_mid == nil ? @0 : _mid,
                              };
    return [self getSource:params];
}

@end
