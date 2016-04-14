//
//  EnlistFeeItem.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/3.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnlistFeeItem : NSObject
@property(nonatomic,copy)NSString* title;
@property(nonatomic,assign)float price;
@property(nonatomic,assign)NSInteger amount;
-(id)initWithTitle:(NSString*)title andPrice:(float)price andAmount:(NSInteger)amount;
@end
