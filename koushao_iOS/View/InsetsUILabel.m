//
//  InsetsUILabel.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/5.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "InsetsUILabel.h"

@implementation InsetsUILabel
-(id) initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if(self){
        self.insets = insets;
    }
    return self;
}

-(id) initWithInsets:(UIEdgeInsets)insets {
    self = [super init];
    if(self){
        self.insets = insets;
    }
    return self;
}

-(void) drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}
@end
