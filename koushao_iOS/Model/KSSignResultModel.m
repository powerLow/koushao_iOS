//
//  KSSignResultModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/7.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSSignResultModel.h"
@implementation KSSignUserInfo
@end

@interface KSSignResultModel()

@property (nonatomic,copy,readwrite) NSString *phone;
@property (nonatomic,copy,readwrite) NSString *ticket_title;
@property (nonatomic,copy,readwrite) NSString *ticket_id;
@property (nonatomic,strong,readwrite) NSNumber *ticket_price;
@end

@implementation KSSignResultModel

-(NSString*)phone{
    return self.ticket_info[@"phone"];
}

-(NSString*)ticket_title{
    return self.ticket_info[@"ticket_title"];
}
-(NSString*)ticket_id{
    return self.ticket_info[@"ticket_id"];
}
-(NSNumber*)ticket_price{
    return self.ticket_info[@"ticket_price"];
}
@end
