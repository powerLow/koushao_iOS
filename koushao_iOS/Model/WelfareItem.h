//
//  WelfareItem.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/3.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WelfareItem : NSObject
@property(nonatomic,copy)NSString* name; //奖券名称
@property(nonatomic,copy)NSString* content; //奖券名称
@property(nonatomic,assign)NSInteger online; //0 线下/1 线上
@property(nonatomic,assign)NSInteger amount; //奖券数量
@property(nonatomic,strong)NSMutableArray* codes; //所对应的兑换码
@property(nonatomic,assign)NSInteger delivery;  //发放形式 0：奖券  2:实物
@end
