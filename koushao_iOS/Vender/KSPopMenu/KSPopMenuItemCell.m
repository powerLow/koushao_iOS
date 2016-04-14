//
//  KSPopMenuItemCell.M
//  koushao
//
//  Created by 廖哲琦 on 15-3-30.
//  Copyright (c) 2015年 Liao. All rights reserved.
//

#import "KSPopMenuItemCell.h"

#import "KSPopMenuItemCell.h"

@interface KSPopMenuItemCell ()
@property (nonatomic, strong) UIView *menuSelectedBackgroundView;

@property (nonatomic, strong) UIImageView *separatorLineImageView;
@end

@implementation KSPopMenuItemCell
- (void)setupPopMenuItem:(KSPopMenuItem *)popMenuItem atIndexPath:(NSIndexPath *)indexPath isBottom:(BOOL)isBottom {
    self.popMenuItem = popMenuItem;
    self.textLabel.text = popMenuItem.title;
//    self.textLabel.textColor = [UIColor whiteColor];
    self.imageView.image = popMenuItem.image;
    self.separatorLineImageView.hidden = isBottom;
}

#pragma mark - Propertys

- (UIView *)menuSelectedBackgroundView {
    if (!_menuSelectedBackgroundView) {
        _menuSelectedBackgroundView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        _menuSelectedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _menuSelectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.916 green:0.942 blue:0.963 alpha:0.9];
    }
    return _menuSelectedBackgroundView;
}

- (UIImageView *)separatorLineImageView {
    if (!_separatorLineImageView) {
        _separatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCDMenuItemViewImageSapcing, kCDMenuItemViewHeight - kCDSeparatorLineImageViewHeight, kCDMenuTableViewWidth - kCDMenuItemViewImageSapcing * 2, kCDSeparatorLineImageViewHeight)];
        _separatorLineImageView.backgroundColor = [UIColor colorWithRed:0.468 green:0.519 blue:0.549 alpha:0.900];
    }
    return _separatorLineImageView;
}

#pragma mark - Life Cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont systemFontOfSize:16];
        
        self.selectedBackgroundView = self.menuSelectedBackgroundView;
        [self.contentView addSubview:self.separatorLineImageView];
    }
    return self;
}

@end

