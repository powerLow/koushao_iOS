//
//  KSTicketButton.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSTicketButton.h"
#import "Masonry.h"


@interface KSTicketButton ()
@property(nonatomic,strong)UIView* topbg;
@property(nonatomic,strong)UIView* bottombg;
@property(nonatomic,strong)UIImageView* ticket_icon;
@property(nonatomic,strong)UILabel* titleUILabel;
@property(nonatomic,strong)UILabel* bottomLeftLabel;
@property(nonatomic,strong)UILabel* subTitleLabel;
@property(nonatomic,strong)UIButton* deleteButton;
@property(nonatomic,strong) UILabel* bottomRightLabel;

@end

@implementation KSTicketButton

- (id)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
-(void)hideDeleButton
{
    _deleteButton.hidden=YES;
}
-(void)setTitleText:(NSString *)titleText
{
    _titleText=titleText;
    self.titleUILabel.text=titleText;
}
-(void)setSubtitleText:(NSString *)subtitleText
{
    _subtitleText=subtitleText;
    self.subTitleLabel.text=subtitleText;
}
-(void)setTicketIconImage:(UIImage*)image
{
    if(self.ticket_icon)
        self.ticket_icon.image=image;
}
-(void)setBottomLeftText:(NSString *)bottomLeftText
{
    _bottomLeftText=bottomLeftText;
    self.bottomLeftLabel.text=bottomLeftText;
}
-(void)setButtonStyle:(KSTicketButtonStyle)buttonStyle
{
    _buttonStyle=buttonStyle;
    if(buttonStyle==KSTicketButtonStyleAdd)
    {
        self.ticket_icon.image=[UIImage imageNamed:@"bantoumingzengjia"];
        [self.titleUILabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(190);
            make.centerY.mas_equalTo(self.topbg.mas_centerY);
            make.centerX.mas_equalTo(self.topbg.mas_centerX);
            
        }];
        self.titleUILabel.textAlignment=NSTextAlignmentCenter;
        self.topbg.backgroundColor=[KSUtil colorWithHexString:@"#FCA461"];
        
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
            make.width.mas_equalTo(0);
            make.right.mas_equalTo(self.mas_right).with.offset(0);
            make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
        }];
    }
    else
    {
        self.ticket_icon.image=[UIImage imageNamed:@"bantoumingpiao"];
        if(buttonStyle==KSTicketButtonStyleRed)
        {
            self.topbg.backgroundColor=[KSUtil colorWithHexString:@"#DC5047"];
        }
        
        if(buttonStyle==KSTicketButtonStyleGreen)
        {
            self.topbg.backgroundColor=[KSUtil colorWithHexString:@"#34BC87"];
        }
        
        
        [self.titleUILabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(190);
            make.right.mas_equalTo(self.topbg.mas_right).with.offset(-10);
            make.centerY.mas_equalTo(self.topbg.mas_centerY).with.offset(-15);
        }];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(160);
            make.right.mas_equalTo(self.topbg.mas_right).with.offset(-10);
            make.centerY.mas_equalTo(self.topbg.mas_centerY).with.offset(15);
        }];
        
        
        self.bottomLeftLabel=[[UILabel alloc]init];
        self.bottomLeftLabel.textColor=[UIColor grayColor];
        self.bottomLeftLabel.textAlignment=NSTextAlignmentLeft;
        self.bottomLeftLabel.font=[UIFont fontWithName:@"Arial" size:12];
        [self.bottombg addSubview:self.bottomLeftLabel];
        [self.bottomLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(180);
            make.left.mas_equalTo(self.bottombg.mas_left).with.offset(16);
            make.centerY.mas_equalTo(self.bottombg.mas_centerY);
        }];
        
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(180);
            make.right.mas_equalTo(self.bottombg.mas_right).with.offset(-24);
            make.centerY.mas_equalTo(self.bottombg.mas_centerY);
        }];
    }
}


- (void)initialize {
    
    self.backgroundColor=[UIColor whiteColor];
    self.clipsToBounds=YES;
    self.layer.shadowOffset=CGSizeMake(3, 3);
    self.layer.shadowColor=[UIColor blackColor].CGColor;
    self.layer.shadowOpacity=0.8f;
    self.layer.cornerRadius=10.0;
    self.layer.borderWidth=0.7;
    self.layer.borderColor=[KSUtil colorWithHexString:@"#C7C8CC"].CGColor;
    
    self.topbg=[[UIView alloc]init];
    [self.topbg setUserInteractionEnabled:NO];
    [self addSubview: self.topbg];
    [self.topbg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.height.mas_equalTo(self.mas_height).with.multipliedBy(0.67);
        make.top.mas_equalTo(self.mas_top);
        make.right.mas_equalTo(self.mas_right);
    }];
    
    self.bottombg=[[UIView alloc]init];
    [self addSubview: self.bottombg];
    [self.bottombg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.height.mas_equalTo(self.mas_height).with.multipliedBy(0.33);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
    }];
    
    self.ticket_icon=[[UIImageView alloc]init];
    self.ticket_icon.contentMode=UIViewContentModeScaleToFill;
    [self.topbg addSubview:self.ticket_icon];
    [self.ticket_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topbg.mas_left).with.offset(20);
        make.height.mas_equalTo(55);
        make.width.mas_equalTo(55);
        make.centerY.mas_equalTo(self.topbg.mas_centerY);
    }];
    
    self.titleUILabel=[[UILabel alloc]init];
    self.titleUILabel.textColor=[UIColor whiteColor];
    self.titleUILabel.font=[UIFont fontWithName:@"Arial" size:24];
    self.titleUILabel.textAlignment=NSTextAlignmentRight;
    [self.topbg addSubview:self.titleUILabel];
    
    self.subTitleLabel=[[UILabel alloc]init];
    self.subTitleLabel.textColor=[UIColor whiteColor];
    self.subTitleLabel.alpha=0.8;
    self.subTitleLabel.textAlignment=NSTextAlignmentRight;
    self.subTitleLabel.font=[UIFont fontWithName:@"Arial" size:14];
    [self.topbg addSubview: self.subTitleLabel];
    
    UIImageView* arrow=[[UIImageView alloc]init];
    [self.bottombg addSubview:arrow];
    arrow.image=[UIImage imageNamed:@"ic_arrow"];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(7);
        make.right.mas_equalTo(self.bottombg.mas_right).with.offset(-9);
        make.centerY.mas_equalTo(self.bottombg.mas_centerY);
    }];
    self.bottomRightLabel=[[UILabel alloc]init];
    self.bottomRightLabel.textColor=[UIColor grayColor];
    self.bottomRightLabel.textAlignment=NSTextAlignmentRight;
    self.bottomRightLabel.font=[UIFont fontWithName:@"Arial" size:12];
    self.bottomRightLabel.text=@"删除";
    self.deleteButton=[[UIButton alloc]init];
    [self.bottombg addSubview:self.deleteButton];
    [self.deleteButton addSubview: self.bottomRightLabel];
    [self.bottomRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.deleteButton.mas_left);
        make.right.mas_equalTo(self.deleteButton.mas_right);
        make.top.mas_equalTo(self.deleteButton.mas_top);
        make.bottom.mas_equalTo(self.deleteButton.mas_bottom);
    }];
    [[self.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        if(self.deleteButtonPressed)
        {self.deleteButtonPressed();}
    }];
}
@end
