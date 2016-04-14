//
//  KSPopMenu.h
//  koushao
//
//  Created by 廖哲琦 on 15-3-30.
//  Copyright (c) 2015年 Liao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import "KSPopMenuItem.h"

typedef void(^PopMenuEventBlock)(NSInteger index, KSPopMenuItem *menuItem);

@interface KSPopMenu : UIView
- (instancetype)initWithMenus:(NSArray *)menus;

- (instancetype)initWithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;

- (void)showMenuAtPoint:(CGPoint)point;

- (void)showMenuOnView:(UIView *)view atPoint:(CGPoint)point;

@property (nonatomic, copy) PopMenuEventBlock popMenuSelected;

@property (nonatomic, copy) PopMenuEventBlock popMenuDismissed;

@end
