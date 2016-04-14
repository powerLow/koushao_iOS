//
//  KSSigninDetailApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/10.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSSigninDetailApi.h"
#import "KSActivity.h"

@interface KSSigninDetailApi()

@property (nonatomic,copy) NSString* ticket_id;

@end

@implementation KSSigninDetailApi

- (instancetype)initWithTicketId:(NSString*)ticket_id {
    self = [super init];
    if (self) {
        self.ticket_id = [ticket_id copy];
    }
    return self;
}
- (NSString *)requestUrl {
    return @"/activity/signin/detail";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    KSActivity *act = [KSUtil getCurrentActivity];
    NSDictionary *params =  @{
                              @"hash":act.hashCode,
                              @"ticket_id":_ticket_id,
                              };
    return [self getSource:params];
}

@end
