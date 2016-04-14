//
//  KSActivityAdminItemCell.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/19.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityAdminItemCell.h"
#import "Masonry.h"

@interface KSActivityAdminItemCell()

@property (nonatomic,strong,readwrite) KSActivityAdminItemViewModel* viewModel;
@end

@implementation KSActivityAdminItemCell

- (void) bindViewModel:(KSActivityAdminItemViewModel*)viewModel{
    
    self.viewModel = viewModel;
    
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UIFont *text_font = KS_FONT_18;
    NSInteger left_margin = 10;
    
    UIImageView *avatarView = [UIImageView new];
    avatarView.backgroundColor = BASE_COLOR;
    UIImageView *smallView = [UIImageView new];
    [avatarView addSubview:smallView];
    smallView.image = [UIImage imageNamed:@"icon_admin"];
    [self.contentView addSubview:avatarView];
    
    UILabel *username_label = [UILabel new];
    username_label.text = viewModel.itemModel.username;
    username_label.textColor = [UIColor blackColor];
    username_label.font = text_font;
    [self.contentView addSubview:username_label];
    
    UIButton *edit_btn = [UIButton new];
    
    [edit_btn setImage:[UIImage imageNamed:@"icon_edit"] forState:UIControlStateNormal];
    [edit_btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.contentView addSubview:edit_btn];
    
    [[edit_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self showRightUtilityButtonsAnimated:YES];
        //滑动时候隐藏其他的view
        UIView *view = self.superview;
        UITableView *containingTableView = nil;
        do {
            if ([view isKindOfClass:[UITableView class]])
            {
                containingTableView = (UITableView *)view;
                break;
            }
        } while ((view = view.superview));
        
        for (SWTableViewCell *cell in [containingTableView visibleCells]) {
            if (cell != self && [cell isKindOfClass:[SWTableViewCell class]] && [self.delegate swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:cell]) {
                [cell hideUtilityButtonsAnimated:YES];
            }
        }
    }];
    
    
    
    @weakify(self)
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.equalTo(self.contentView).offset(left_margin);
        make.centerY.equalTo(self.contentView);
        make.height.width.equalTo(self.mas_height).multipliedBy(0.7);
    }];
    
    [smallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(avatarView);
        make.height.width.equalTo(avatarView).multipliedBy(0.6);
    }];
    
    [username_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(avatarView);
        make.left.equalTo(avatarView.mas_right).offset(left_margin);
    }];
    
    [edit_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.right.equalTo(self.contentView).offset(-left_margin);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(self);
//        make.width.equalTo(self).multipliedBy(0.3);
    }];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.rightUtilityButtons = [self rightButtons];
    
    NSMutableArray *titles = [NSMutableArray new];
    if ([viewModel.itemModel.attr.signin boolValue]) {
        [titles addObject:@"签到管理"];
    }
    if([viewModel.itemModel.attr.question boolValue]){
        [titles addObject:@"咨询回复"];
    }
    if ([viewModel.itemModel.attr.welfare boolValue]){
        [titles addObject:@"福利发放"];
    }
    UIView *lastView = avatarView;
    for (int i = 0; i < titles.count; ++i) {
        UILabel *label = [UILabel new];
        label.font = KS_FONT_16;
        label.textColor = KS_GrayColor3;
        label.text = titles[i];
        [self.contentView addSubview:label];
        
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastView.mas_right).offset(left_margin);
            make.bottom.equalTo(avatarView.mas_bottom);
        }];
        
        if (i != titles.count -1 ) {
            UIView *sp = [UIView new];
            sp.backgroundColor = KS_GrayColor3;
            [self.contentView addSubview:sp];
            
            [sp mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(label).multipliedBy(0.8);
                make.centerY.equalTo(label);
                make.width.equalTo(@1);
                make.left.equalTo(label.mas_right).offset(left_margin);
            }];
            lastView = sp;
        }
    }
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"编辑"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    
    return rightUtilityButtons;
}

@end
