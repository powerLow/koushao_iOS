//
//  Express.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/8.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "Express.h"

@implementation Express

-(instancetype)initWithExpressDic:(NSDictionary*)dic {
    
    if (self = [super init]) {
        
        self.expressName = [dic objectForKey:@"expressName"];
        self.phone = [dic objectForKey:@"phone"];
        self.imageName = [dic objectForKey:@"imageUrl"];
        self.expressWebUrl = [dic objectForKey:@"expressWebUrl"];
        self.pinyin  = [dic objectForKey:@"pinyin"];
        
    }
    
    return self;
    
}

+(NSString*)keyName {
    
    return @"expressName";
    
}

@end
