//
//  KSEnrollRecordDetailApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/5.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSEnrollRecordDetailApi.h"
#import "KSActivity.h"


@interface KSEnrollRecordDetailApi()

@property (nonatomic,copy) NSString* ticket_id;

@end


@implementation KSEnrollRecordDetailApi

- (instancetype)initWithTicketId:(NSString*)ticket_id{
    self = [super init];
    if (self) {
        self.ticket_id = [ticket_id copy];
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/analyse/enrollrecord/detail";
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
