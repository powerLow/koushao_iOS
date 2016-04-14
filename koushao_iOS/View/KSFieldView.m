//
//  KSFieldView.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/6.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSFieldView.h"
#import "UIView+Extension.h"
@interface KSFieldView ()
@property (assign, nonatomic) NSInteger num;
@property (nonatomic, strong) NSArray* string;
@end

@implementation KSFieldView

- (instancetype)initWithFrame:(CGRect)frame fieldNum:(NSNumber*)fieldNum
{
    if (self = [super initWithFrame:frame]) {
        
        _num =[fieldNum integerValue];
        CGFloat pointW = 1;
        CGFloat pointH = frame.size.height;
        CGFloat pointY = 0;
        CGFloat pointX;
        CGFloat margin = frame.size.width / _num;
        
        for (int i = 0; i < (_num-1); i++) {
            pointX = i * margin + margin;
            UIView *line = [[UIView alloc]init];
            line.frame = CGRectMake(pointX, pointY, pointW, pointH);
            line.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
            [self addSubview:line];
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //    UIImage *pointImage = [UIImage imageNamed:@"yuan"];
    CGFloat pointW = self.width / _num * 0.618;
    CGFloat pointH = pointW*1.05;
    CGFloat pointY = (self.height - pointH ) /2;
    CGFloat pointX;
    CGFloat padding = (self.width / _num  - pointW) / 2;
    for (int i = 0; i < _string.count; i++) {
        pointX = padding + i * (pointW + 2 * padding);
        //[pointImage drawInRect:CGRectMake(pointX, pointY, pointW, pointH)];
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setAlignment:NSTextAlignmentCenter];
        
        NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:
                                         KS_BIG_FONT,
                                         NSFontAttributeName,
//                                         [NSNumber numberWithFloat:1.0],
//                                         NSBaselineOffsetAttributeName,
                                         style,
                                         NSParagraphStyleAttributeName,
                                         nil];
        
        [_string[i] drawInRect:CGRectMake(pointX, pointY, pointW, pointH) withAttributes:attr];
    }
}

- (void)drawRect:(CGRect)rect string:(NSArray*)string
{
    self.string = [string copy];
    [self setNeedsDisplay];
}

@end
