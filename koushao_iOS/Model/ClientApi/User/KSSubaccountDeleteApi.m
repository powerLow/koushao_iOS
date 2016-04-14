//
//  KSSubaccountDeleteApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/18.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSSubaccountDeleteApi.h"
#import "KSActivity.h"

@interface KSSubaccountDeleteApi()

@property (nonatomic,copy) NSString* account;

@end

@implementation KSSubaccountDeleteApi


- (instancetype)initWithAccount:(NSString*)account
{
    self = [super init];
    if (self) {
        self.account = [account copy];
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/users/subaccount";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodDelete;
}

- (id)requestArgument {
    KSActivity *act = [KSUtil getCurrentActivity];
    NSDictionary *params =  @{
                              @"hash":act.hashCode,
                              @"username":_account,
                              };
    return [self getSource:params];
}

@end
