//
//  KSSegmentView.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/26.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KSSegmentViewDelegate <NSObject>

- (void)segmentViewDidSelected:(NSUInteger)index;
@end

@interface KSSegmentView : UIView

/**
 *  设置风格颜色 默认蓝色风格
 */
@property (nonatomic, strong) UIColor *tintColor;

/**
 *  设置RFSegmentView的左右间距 默认15
 */
@property (nonatomic, assign) CGFloat leftRightMargin;

/**
 *  设置RFSegmentView的每个选项卡的高度 默认30
 */
@property (nonatomic, assign) CGFloat itemHeight;

/**
 *  设置选中项 默认0
 */
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) id<KSSegmentViewDelegate> delegate;

/**
 *  默认构造函数
 *
 *  @param frame frame
 *  @param items title字符串数组
 *
 *  @return 当前实例
 */
- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items backgroundColor:(UIColor*)color;

@end
