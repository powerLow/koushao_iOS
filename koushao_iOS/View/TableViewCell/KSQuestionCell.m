//
//  KSQuestionCell.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/23.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSQuestionCell.h"

#import "Masonry.h"
#import <YYWebImage/YYWebImage.h>
#import <YYText.h>
#import "NSDate+Category.h"
#import <CoreText/CoreText.h>
#import "KSPopToolMenuView.h"
@interface KSQuestionCell()<KSPopToolMenuViewDelegate>

@property (nonatomic,strong,readwrite) KSQuestionReplyItemViewModel* viewModel;
@property (nonatomic,strong,readwrite) KSPopToolMenuView * funBtnView;

@end


@implementation KSQuestionCell

- (void) bindViewModel:(KSQuestionReplyItemViewModel*)viewModel{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    self.viewModel = viewModel;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    NSUInteger lineSpace = 5;
    [paragraphStyle setLineSpacing:lineSpace];//调整行间距
    paragraphStyle.alignment = NSTextAlignmentLeft;
    //头像
    UIImageView *avatarView = [UIImageView new];
    [self.contentView addSubview:avatarView];
    
    NSUInteger height = SCREEN_HEIGHT / 13;
    NSUInteger left_margin = 15;
    NSUInteger top_margin = 10;
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(left_margin);
        make.width.height.mas_equalTo(height);
    }];
    avatarView.layer.masksToBounds = YES;
    avatarView.layer.cornerRadius = height / 2;
    
    [avatarView yy_setImageWithURL:[NSURL URLWithString:viewModel.itemModel.user_avatar]
                       placeholder:KS_GrayColor.color2Image
                           options:YYWebImageOptionSetImageWithFadeAnimation
                          progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                          }
                         transform:^UIImage *(UIImage *image, NSURL *url) {
                             return image;
                         }
                        completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                            if (from == YYWebImageFromDiskCache) {
                                NSLog(@"load from disk cache");
                            }
                        }];
    UIFont *text_font = KS_SMALL_FONT;
    
    //账号
    UILabel *username_label = [UILabel new];
    [self.contentView addSubview:username_label];
    username_label.text = viewModel.itemModel.user;
    username_label.font = text_font;
    //时间
    UILabel *time_label = [UILabel new];
    [self.contentView addSubview:time_label];
    NSDate *postTime = [NSDate dateWithTimeIntervalSince1970:[viewModel.itemModel.create_time unsignedIntegerValue]];
    time_label.text = [[NSDate date] prettyDateWithReference:postTime];
    time_label.font = text_font;
    time_label.textColor = KS_GrayColor4;
    //内容
    
    NSDictionary * textAttr = @{
                                NSFontAttributeName:text_font,
                                NSParagraphStyleAttributeName:paragraphStyle
                                };
    CGSize titleSize = [viewModel.itemModel.question boundingRectWithSize:CGSizeMake(SCREEN_WIDTH*0.78, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttr context:nil].size;
    UILabel *content_label = [UILabel new];
    [self.contentView addSubview:content_label];
//    content_label.text = viewModel.itemModel.question;
    NSMutableAttributedString *content_str = [[NSMutableAttributedString alloc] initWithString:viewModel.itemModel.question attributes:textAttr];
    content_label.attributedText = content_str;
    content_label.numberOfLines = 0;
    content_label.lineBreakMode = NSLineBreakByWordWrapping;
    
    [username_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatarView.mas_right).offset(left_margin);
        make.top.equalTo(avatarView);
    }];
    [time_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(username_label);
        make.top.equalTo(username_label.mas_bottom).offset(top_margin);
    }];
    [content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(username_label);
        make.top.equalTo(time_label.mas_bottom).offset(top_margin);
        make.width.mas_equalTo(titleSize.width+5);
    }];
    
    CGSize textSize = [viewModel.itemModel.user boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:text_font} context:nil].size;
    
    if ([viewModel.itemModel.answer length] == 0) {
        //右边评论按钮
        KSPopToolMenuView *postBtn = [[KSPopToolMenuView alloc] initWithFrame:CGRectMake(0, 0, 180, 30)];
        
        postBtn.buttonFont = KS_SMALL_FONT;
        postBtn.funTitles = @[@"删除", @"回复"];
        postBtn.funImages = @[[UIImage imageNamed:@"icon_question_delete"],[UIImage imageNamed:@"icon_question_reply"]];
        postBtn.delegate = self;
        self.funBtnView = postBtn;
        [self.contentView addSubview:postBtn];
        
        @weakify(self)
        [postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.top.mas_equalTo(8);
            make.right.equalTo(self.contentView).offset(-10);
            make.width.mas_equalTo(180);
            make.height.mas_equalTo(30);
        }];
        
        viewModel.cellHeight = textSize.height*2 + top_margin * 5 + titleSize.height;
    }else{
        //有回复的
        @weakify(self)
        UIImage *deleteImage = [UIImage imageNamed:@"icon_del"];
        //删除问题按钮
        UIButton *deleteQuestionBtn = [UIButton new];
        [deleteQuestionBtn setImage:deleteImage forState:UIControlStateNormal];
        [self.contentView addSubview:deleteQuestionBtn];
        [deleteQuestionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.top.equalTo(username_label);
            make.right.equalTo(self.contentView).offset(-10);
        }];
        [[deleteQuestionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            if (_deleteQuestionClickedBlock) {
                _deleteQuestionClickedBlock(self);
            }
        }];
        //分割线
        UIView *sp = [UIView new];
        sp.backgroundColor = KS_GrayColor;
        [self.contentView addSubview:sp];
        
        
        [sp mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.left.equalTo(username_label);
            make.right.equalTo(self.contentView);
            make.height.equalTo(@1);
            make.top.equalTo(content_label.mas_bottom).offset(top_margin);
        }];
        
        
        NSUInteger MaxWidth = SCREEN_WIDTH*0.75;
        
        
        NSMutableDictionary *attr = [[NSMutableDictionary alloc] initWithDictionary:@{
//                               NSForegroundColorAttributeName : BASE_COLOR,
                               NSFontAttributeName : text_font,
                               NSParagraphStyleAttributeName : paragraphStyle,
                               }];
        //回复人名字(绿色)
        [attr setObject:BASE_COLOR forKey:NSForegroundColorAttributeName];
        NSString *str = [NSString stringWithFormat:@"%@: ",viewModel.itemModel.answerer];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str attributes:attr];
        //回复的内容(黑色)
        [attr setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        NSMutableAttributedString *answer = [[NSMutableAttributedString alloc] initWithString:viewModel.itemModel.answer attributes:attr];
        //时间(灰色)
        [attr setObject:KS_GrayColor4 forKey:NSForegroundColorAttributeName];
        NSDate *replyDate = [NSDate dateWithTimeIntervalSince1970:[viewModel.itemModel.answer_time unsignedIntegerValue]];
        str = [NSString stringWithFormat:@"   %@ ",[[NSDate date] prettyDateWithReference:replyDate]];
        
        NSMutableAttributedString *timestr = [[NSMutableAttributedString alloc] initWithString:str attributes:attr];
        YYLabel *attentionLabel = [YYLabel new];
        attentionLabel.numberOfLines = 0;
        [text appendAttributedString:answer];
        [text appendAttributedString:timestr];
        
        [self.contentView addSubview:attentionLabel];
        
        NSMutableAttributedString *attachment = nil;
        //删除回复按钮
        UIButton *deleteReplyBtn = [UIButton new];
        [deleteReplyBtn setImage:deleteImage forState:UIControlStateNormal];
//        [self.contentView addSubview:deleteReplyBtn];
        [[deleteReplyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            if (_deleteReplyClickedBlock) {
                _deleteReplyClickedBlock(self);
            }
        }];
        [deleteReplyBtn sizeToFit];
        attachment = [NSMutableAttributedString yy_attachmentStringWithContent:deleteReplyBtn contentMode:UIViewContentModeBottom attachmentSize:deleteReplyBtn.frame.size alignToFont:text_font alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString: attachment];
        attentionLabel.userInteractionEnabled = YES;
        attentionLabel.attributedText = text;
        
        //自适应高度
//        CGSize replySize = [answerer.string boundingRectWithSize:CGSizeMake(MaxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttr context:nil].size;
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(MaxWidth, CGFLOAT_MAX) text:text];
        // 获取文本显示位置和大小
//        layout.textBoundingRect; // get bounding rect
//        layout.textBoundingSize; // get bounding size
//        NSLog(@"size = %@",NSStringFromCGSize(layout.textBoundingSize));
        attentionLabel.textLayout = layout;
        [attentionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sp.mas_bottom).offset(top_margin);
            make.left.equalTo(username_label);
            make.height.mas_equalTo(layout.textBoundingSize.height);
            make.width.mas_equalTo(layout.textBoundingSize.width+5);
        }];
        
        viewModel.cellHeight = textSize.height*2 + top_margin * 7 + titleSize.height + layout.textBoundingSize.height;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
#pragma mark - KSOptionFunViewDelegate
- (void)KSPopToolMenuView:(KSPopToolMenuView *)OptionFunView didSelectButtonAtIndex:(NSUInteger)index{
    if (index == 1) {
        if (_commentClickedBlock) {
            _commentClickedBlock(self);
        }
    }else{
        if (_deleteQuestionClickedBlock) {
            _deleteQuestionClickedBlock(self);
        }
    }
}
#pragma mark - 
- (void)hiddenBtns {
    [self.funBtnView hidenButtons];
}
@end
