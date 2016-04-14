//
//  CTIconButtonModel.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/12/24.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "CTIconButtonModel.h"

@implementation CTIconButtonModel
-(id)initWithText:(NSString *)text andIcon:(NSString *)icon
{
    if(self=[super init])
    {
        self.buttonText=text;
        self.buttonIcon=icon;
    }
    return self;
}
+(CTIconButtonModel*)buttonWithText:(NSString *)text andIcon:(NSString *)icon
{
    CTIconButtonModel* button=[[CTIconButtonModel alloc]initWithText:text andIcon:icon];
    return button;
}
@end
