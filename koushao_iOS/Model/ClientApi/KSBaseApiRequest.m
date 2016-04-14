//
//  KSBaseApiRequest.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/13.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSBaseApiRequest.h"
#import <CommonCrypto/CommonDigest.h>

@implementation KSBaseApiRequest

-(NSDictionary*)getSource:(NSDictionary *)args{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:args copyItems:YES];
    
    NSNumber *time = [NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]];
    [dict setObject:time forKey:@"t"];
    
    NSArray *myKeys = [dict allKeys];
    NSArray *sortedKeys = [myKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    NSString *salt = @"8fbd1f48f57585874528afe622f241eadd54ff5a";
    NSMutableString *str = [[NSMutableString alloc] initWithString:salt];
    
    for (NSString *key in sortedKeys) {
        id value = dict[key];
        if ([value isKindOfClass:[NSString class]]) {
            [str appendString:key];
            [str appendString:value];
        }
        if ([value isKindOfClass:[NSNumber class]]) {
            NSString *strValue = [NSString stringWithFormat:@"%@",value];
            [str appendString:key];
            [str appendString:strValue];
        }
    }
    [str appendString:salt];
    
    
    NSString *md5 = [self getMd5_32Bit_String:str];
    //    NSLog(@"md5 source :%@\n,md5:[%@]\n",str,md5);
    [dict setObject:md5 forKey:@"source"];
    
    return [dict copy];
};

//32位MD5加密方式
- (NSString *)getMd5_32Bit_String:(NSString *)srcString{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    unsigned int length = (unsigned int)strlen(cStr);
    CC_MD5( cStr,length , digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (NSDictionary *)requestHeaderFieldValueDictionary{
    KSUser *user = [KSUser currentUser];
    if ([user isLogin]) {
        return @{
                 @"X-Koushao-Username":user.username,
                 @"X-Koushao-Session-Token":user.sessionToken,
                 };
    }
    return nil;
}
- (id)jsonValidator {
    return @{
             @"error": @{
                     @"errorno":[NSNumber class],
                     @"msg":[NSString class],
                     }
             };
}

@end
