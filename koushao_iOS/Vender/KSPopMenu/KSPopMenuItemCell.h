//
//  KSPopMenuItemCell.H
//  koushao
//
//  Created by 廖哲琦 on 15-3-30.
//  Copyright (c) 2015年 Liao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSPopMenuItem.h"

@interface KSPopMenuItemCell : UITableViewCell
@property (nonatomic, strong) KSPopMenuItem *popMenuItem;

- (void)setupPopMenuItem:(KSPopMenuItem *)popMenuItem atIndexPath:(NSIndexPath *)indexPath isBottom:(BOOL)isBottom;

@end