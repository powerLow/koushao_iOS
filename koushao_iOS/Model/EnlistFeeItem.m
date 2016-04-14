//
//  EnlistFeeItem.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/3.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "EnlistFeeItem.h"

@implementation EnlistFeeItem
-(id)initWithTitle:(NSString*)title andPrice:(float)price andAmount:(NSInteger)amount
{
    if(self=[super init])
    {
        self.title=title;
        self.price=price;
        self.amount=amount;
    }
    return self;
}
@end
