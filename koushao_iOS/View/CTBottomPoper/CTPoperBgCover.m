//
//  CTPoperBgCover.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/12/24.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "CTPoperBgCover.h"
#include "CTConst.h"

@implementation CTPoperBgCover

+(CTPoperBgCover *)share{
    static CTPoperBgCover * view = nil;
    if(view == nil){
        view = [[CTPoperBgCover alloc]initDefault];
    }
    return view;
}

-(id)initDefault{
    self =[super initWithFrame:CGRectMake(0, 0, (int)[UIScreen mainScreen].bounds.size.width, CT_SCREEN_HEIGHT)];
    if(self){
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0;
        self.CTPoperArray=[[NSMutableArray alloc]init];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for(UIView* view in _CTPoperArray)
    {
        if([view isKindOfClass:[CTBottomPoper class]])
        {
            CTBottomPoper* poper=(CTBottomPoper*)view;
            [poper dismiss];
        }
    }
}
@end
