//
//  Express.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/8.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Express : NSObject

@property (nonatomic, copy)NSString *expressName;
@property (nonatomic, copy)NSString *phone;
@property (nonatomic, copy)NSString *imageName;
@property (nonatomic, copy)NSString *expressWebUrl;
@property (nonatomic, copy)NSString *pinyin;
@property (nonatomic, copy)NSString *index;


-(instancetype)initWithExpressDic:(NSDictionary*)dic;

+(NSString*)keyName;

@end
