//
//  KSPopToolMenuView.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/14.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KSPopToolMenuViewDelegate;

@interface KSPopToolMenuView : UIView

@property (nonatomic, strong) NSArray *funTitles;
@property (nonatomic, strong) NSArray *funImages;
@property (nonatomic, assign) BOOL isButtonShow;
@property (nonatomic, strong) UIFont *buttonFont;

@property (nonatomic, weak) id <KSPopToolMenuViewDelegate> delegate;

- (void)showButtons;
- (void)hidenButtons;

@end

@protocol KSPopToolMenuViewDelegate <NSObject>

@optional

- (void)KSPopToolMenuView:(KSPopToolMenuView *)PopToolMenuView didSelectButtonAtIndex:(NSUInteger)index;

@end
