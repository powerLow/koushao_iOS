//
//  IMYCustomURLProtocol.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/23.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSURLProtocol.h"
#import "KSActivityCreatManager.h"

@implementation KSURLProtocol
+(void)load
{
    [NSURLProtocol registerClass:self];
}

+ (BOOL)canInitWithRequest:(NSMutableURLRequest *)request
{
    if ([request isKindOfClass:[NSMutableURLRequest class]]) {
        if([request.URL.absoluteString containsString:@"http://m.koushaoapp.com"])
        {
            [(id)request setValue:[KSActivityCreatManager sharedManager].hashCode forHTTPHeaderField:@"X-Koushao-Hash"];
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a=[dat timeIntervalSince1970]*1000;
            NSString *timeString = [NSString stringWithFormat:@"%f", a];
            NSString *url=[NSString stringWithFormat:@"%@?t=%@",request.URL.absoluteString,timeString];
            request.URL=[NSURL URLWithString:url];
        }
    }
    return NO;
}
@end
