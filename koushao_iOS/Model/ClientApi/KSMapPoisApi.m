//
//  KSMapPoisApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/27.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSMapPoisApi.h"

@interface KSMapPoisApi()

@property (nonatomic,copy) NSString* query;
@property (nonatomic,copy) NSString* longitude;
@property (nonatomic,copy) NSString* latitude;

@end

@implementation KSMapPoisApi

-(instancetype)initWithQuery:(NSString*)query
                   longitude:(NSString*)longitude
                    latitude:(NSString*)latitude{
    self =[super init];
    if (self) {
        self.query = [query copy];
        self.longitude = [longitude copy];
        self.latitude = [latitude copy];
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/pois";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    NSDictionary *params =  @{
                              @"query":_query,
                              @"latitude":_latitude,
                              @"longitude":_longitude,
                              };
    return [self getSource:params];
}

@end
