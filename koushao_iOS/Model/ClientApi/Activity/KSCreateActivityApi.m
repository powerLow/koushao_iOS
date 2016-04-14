//
//  KSCreateActivity.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/10.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSCreateActivityApi.h"
#import "KSActivityCreatManager.h"

@implementation KSCreateActivityApi
- (NSString *)requestUrl {
    return @"/activity";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    KSActivityCreatManager* activityCreatManager=[KSActivityCreatManager sharedManager];
    BOOL hasEndTime=activityCreatManager.hasEndTime==0;
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithDictionary: @{ @"title": activityCreatManager.title, @"location": activityCreatManager.location,@"startTime" :@(activityCreatManager.startTime),@"endTime":@(hasEndTime?activityCreatManager.endTime:0),@"isday":@(activityCreatManager.allDay)}];
    if(activityCreatManager.longitude!=0)
    {
        [params setObject:[NSNumber numberWithFloat:activityCreatManager.longitude] forKey:@"longitude"];
        [params setObject:[NSNumber numberWithFloat:activityCreatManager.latitude] forKey:@"latitude"];
    }
    return [self getSource:params];
}

@end
