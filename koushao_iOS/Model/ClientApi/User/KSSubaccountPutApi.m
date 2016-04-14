//
//  KSSubaccountPutApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/18.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSSubaccountPutApi.h"
#import "KSActivity.h"

@interface KSSubaccountPutApi()

@property (nonatomic,copy) NSString* account;
@property (nonatomic,copy) NSString* password;
@property (nonatomic,assign) BOOL open_signin;
@property (nonatomic,assign) BOOL open_question;
@property (nonatomic,assign) BOOL open_welfare;
@end


@implementation KSSubaccountPutApi

- (instancetype)initWithAccount:(NSString*)account
                       Password:(NSString*)password
                         signin:(BOOL)signin
                       question:(BOOL)question
                        welfare:(BOOL)welfare
{
    self = [super init];
    if (self) {
        self.account = [account copy];
        self.password = [password copy];
        self.open_signin = signin;
        self.open_question = question;
        self.open_welfare = welfare;
    }
    return self;
}
- (NSString *)requestUrl {
    return @"/users/subaccount";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPut;
}

- (id)requestArgument {
    KSActivity *act = [KSUtil getCurrentActivity];
    NSDictionary *params =  @{
                              @"hash":act.hashCode,
                              @"username":_account,
                              @"password":_password,
                              @"signin":@((int)_open_signin),
                              @"question":@((int)_open_question),
                              @"welfare":@((int)_open_welfare)
                              };
    return [self getSource:params];
}

@end
