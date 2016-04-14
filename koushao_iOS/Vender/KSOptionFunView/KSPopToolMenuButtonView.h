//
//  KSPopToolMenuButtonView.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/14.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KSPopToolMenuButtonViewDataSource;
@protocol KSPopToolMenuButtonViewDelegate;

@interface KSPopToolMenuButtonView : UIView

@property (weak) id <KSPopToolMenuButtonViewDataSource> dataSource;
@property (weak) id <KSPopToolMenuButtonViewDelegate> delegate;

@property (nonatomic, strong) UIFont *titleFont;

- (void)reloadData;
- (void)show;
- (void)hiden;

@end

@protocol KSPopToolMenuButtonViewDataSource <NSObject>

@required
- (NSInteger)numberOfTabs;

- (NSString *)KSPopToolMenuButtonView:(KSPopToolMenuButtonView *)PopToolMenuButtonView titlesForTabIndex:(NSInteger)index;

- (UIImage *)KSPopToolMenuButtonView:(KSPopToolMenuButtonView *)PopToolMenuButtonView imageForTabIndex:(NSInteger)index;

@end

@protocol KSPopToolMenuButtonViewDelegate <NSObject>

@optional

- (void)OptionFunButtonView:(KSPopToolMenuButtonView *)OptionFunButtonView didSelectIndex:(NSUInteger)index;

@end