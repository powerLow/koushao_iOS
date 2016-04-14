//
//  KSTabbar.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/14.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSTabbar.h"
#import "UIView+Extension.h"
@implementation KSTabbar

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self initTextAttr];

    [self initBarButtonPosition];
    
    [self addComposeButton];
}

/** 设置文本属性 */
- (void) initTextAttr {
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = BASE_COLOR;
    
    for (UITabBarItem *item in self.items) {
        // 设置字体颜色
        [item setTitleTextAttributes:attr forState:UIControlStateSelected];
    }
}

/** 设置BarButton的位置 */
- (void) initBarButtonPosition {
    
    // 创建一个位置所以，用来定位
    int index = 0;
    
    for (UIView *tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            // 计算尺寸，预留一个“+”号空间
            CGFloat width = self.width / (self.items.count + 1);
            tabBarButton.width = width;
            
            // 计算位置
            if (index < (int)(self.items.count / 2)) {
                tabBarButton.x = width * index;
            } else {
                tabBarButton.x = width * (index + 1);
            }
            
            index++;
        }
    }
}

/** 添加"+"按钮 */
- (void) addComposeButton {
    // 初始化按钮
    UIButton *composeButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [composeButton setImage:[UIImage imageNamed:@"compose_add"] forState:UIControlStateNormal];
    [composeButton setImage:[UIImage imageNamed:@"compose_add"] forState:UIControlStateHighlighted];
    
    // 设置位置尺寸
    CGFloat width = self.width / (self.items.count + 1);
    CGFloat height = self.height;
    CGFloat x = (self.items.count / 2) * width;
    CGFloat y = 0;
    composeButton.frame = CGRectMake(x, y, width, height);
    
    // 监听事件
    [composeButton addTarget:self action:@selector(composeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加到tabBar上
    [self addSubview:composeButton];
}

/** “+"按钮点击事件 */
- (void) composeButtonClicked {
    if ([self.ksTabBarDelegate respondsToSelector:@selector(tabBarDidComposeButtonClick:)]) {
        [self.ksTabBarDelegate tabBarDidComposeButtonClick:self];
    }
}
@end
