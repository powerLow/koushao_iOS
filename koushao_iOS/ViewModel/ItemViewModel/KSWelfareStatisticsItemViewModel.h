//
//  KSWelfareStatisticsItemViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/30.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"

@interface KSWelfareStatisticsItemViewModel : KSViewModel

@property(nonatomic, assign) CGFloat cellHeight;
@property(nonatomic, strong) UIFont *font;
@property(nonatomic, strong) NSNumber *count;
@property(nonatomic, strong) NSNumber *left_offset;
@property(nonatomic, copy) NSString *text;
//是否有下划线分割
@property(nonatomic, assign) BOOL line;
@property(nonatomic, strong) UIColor *bkcolr;
@end
