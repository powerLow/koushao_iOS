//
//  KSAwardConfirm.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/16.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSAwardConfirmApi.h"
#import "KSActivity.h"

@interface KSAwardConfirmApi()

@property (nonatomic,strong) NSNumber* wid;
@property (nonatomic,copy) NSString* nu;
@property (nonatomic,copy) NSString *company;

@end

@implementation KSAwardConfirmApi

- (instancetype)initWithWid:(NSNumber*)wid
                         nu:(NSString*)nu
                    company:(NSString*)company{
    self = [super init];
    if (self) {
        self.wid = wid;
        self.nu = [nu copy];
        self.company = [company copy];
    }
    return self;
}
- (NSString *)requestUrl {
    return @"/activity/welfare/award/confirm";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    KSActivity *act = [KSUtil getCurrentActivity];
    NSDictionary *params =  @{
                              @"hash":act.hashCode,
                              @"id":_wid == nil ? @0 : _wid,
                              @"company":_company,
                              @"nu":_nu,
                              };
    return [self getSource:params];
}

@end
