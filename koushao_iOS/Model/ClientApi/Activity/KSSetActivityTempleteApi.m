//
//  KSSetActivityTempleteApi.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/18.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSSetActivityTempleteApi.h"
#import "KSActivityCreatManager.h"

@implementation KSSetActivityTempleteApi
- (NSString *)requestUrl {
    return @"/activity/template";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    KSActivityCreatManager* activityCreatManager=[KSActivityCreatManager sharedManager];
    NSString* detailPosterPath=[activityCreatManager.detailPosterArray objectAtIndex:activityCreatManager.detailStyle];
    NSString* coverPosterPath=activityCreatManager.coverPosterPath;
    
    NSString* poster=[activityCreatManager.detailPosterHashMap objectForKey:detailPosterPath];
    NSString* cover_pic=[activityCreatManager.coverPosterHashMap objectForKey:coverPosterPath];
    if(!cover_pic&&[cover_pic hasPrefix:@"http://"])
    {
        cover_pic=activityCreatManager.coverPosterPath;
    }
    if(cover_pic&&poster)
    {
        NSMutableDictionary *params=[NSMutableDictionary dictionaryWithDictionary:
                                     @{
                                       @"hash": activityCreatManager.hashCode,
                                       @"cover_pic": cover_pic,
                                       @"poster" :poster,
                                       @"detail":@(activityCreatManager.detailStyle+1),
                                       @"cover":@(activityCreatManager.coverStyle+1)
                                       }];
        return [self getSource:params];
    }
    return nil;
}
@end
