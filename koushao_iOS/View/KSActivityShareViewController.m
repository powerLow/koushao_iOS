//
//  KSActivityShareViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/26.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityShareViewController.h"
#import "KSActivityShareViewModel.h"
#import "Masonry.h"
@interface KSActivityShareViewController ()


@property (nonatomic,strong) UIButton *weixinBtn;
@property (nonatomic,strong) UIButton *friendBtn;
@property (nonatomic,strong) UIButton *weiboBtn;
@property (nonatomic,strong) UIButton *qqBtn;
@property (nonatomic,strong) UIButton *qzoneBtn;
@property (nonatomic,strong) UIButton *LinkBtn;
@property (nonatomic,strong) UIButton *sendBtn;

@property (nonatomic,strong,readwrite) KSActivityShareViewModel *viewModel;
@end

@implementation KSActivityShareViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel.vc = self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label1 = [UILabel new];
    label1.text = @"第三方平台";
    label1.textColor = [UIColor grayColor];
    [self.view addSubview:label1];
    UIView *sp1 = [UIView new];
    sp1.backgroundColor = HexRGB(0xDEDEDE);
    [self.view addSubview:sp1];
    
    @weakify(self)
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.height.equalTo(@25);
    }];
    [sp1 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.right.equalTo(self.view);
        make.height.equalTo(@1);
        make.top.equalTo(label1.mas_bottom).offset(10);
    }];
    
    self.weixinBtn = [UIButton new];
    self.friendBtn = [UIButton new];
    self.weiboBtn = [UIButton new];
    self.qqBtn = [UIButton new];
    self.qzoneBtn = [UIButton new];
    self.LinkBtn = [UIButton new];
    self.sendBtn = [UIButton new];
    
    self.weixinBtn.rac_command = self.viewModel.didClickWeixinBtnCommand;
    self.friendBtn.rac_command = self.viewModel.didClickFriendBtnCommand;
    self.weiboBtn.rac_command = self.viewModel.didClickWeiboBtnCommand;
    self.qqBtn.rac_command = self.viewModel.didClickQQBtnCommand;
    self.qzoneBtn.rac_command = self.viewModel.didClickQzoneBtnCommand;
    self.LinkBtn.rac_command = self.viewModel.didClickCopyLinkBtnCommand;
    self.sendBtn.rac_command = self.viewModel.didClickSendContactBtnCommand;
    
    NSArray *snsBtns = @[_weixinBtn,_friendBtn,_weiboBtn,_qqBtn,_qzoneBtn,_LinkBtn,_sendBtn];
    NSArray *names = @[@"weixin_icon",@"pengyouquan_icon",@"weibo_icon",@"qq_icon",@"qzone_icon",@"copy_link_icon",@"send_to_phone_contact"];
    NSArray *titles = @[@"微信",@"朋友圈",@"新浪微博",@"QQ",@"QQ空间",@"复制链接",@"发送至联系人"];
    
    for (int i=0; i<snsBtns.count; ++i) {
        UIButton* btn = snsBtns[i];
        [self.view addSubview:btn];
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:names[i]];
        [btn addSubview:imageView];
        
        UILabel *label = [UILabel new];
        label.textColor = [UIColor grayColor];
        label.text = titles[i];
        label.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:label];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.centerY.equalTo(btn).offset(-10);
            make.width.equalTo(@37.3);
            make.height.equalTo(@32);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.top.equalTo(imageView.mas_bottom).offset(8);
            make.left.right.equalTo(btn);
        }];
    }
    //微信
    [_weixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(sp1.mas_bottom);
        make.left.equalTo(self.view);
        make.width.equalTo(_friendBtn);
        make.height.equalTo(_weixinBtn.mas_width);
    }];
    //朋友圈
    [_friendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weixinBtn);
        make.height.width.equalTo(_weixinBtn);
        make.left.equalTo(_weixinBtn.mas_right);
    }];
    //微博
    [_weiboBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(_weixinBtn);
        make.left.equalTo(_friendBtn.mas_right);
        make.right.equalTo(self.view);
        make.height.width.equalTo(_weixinBtn);
    }];
    //QQ
    [_qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self)
        make.left.equalTo(_weixinBtn);
        make.top.equalTo(_weixinBtn.mas_bottom);
        make.height.width.equalTo(_weixinBtn);
    }];
    //QQ空间
    [_qzoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        @strongify(self)
        make.left.equalTo(_weixinBtn.mas_right);
        make.top.equalTo(_weixinBtn.mas_bottom);
        make.height.width.equalTo(_weixinBtn);
    }];
    
    //发布操作
    UILabel *label2 = [UILabel new];
    label2.text = @"发布操作";
    label2.textColor = [UIColor grayColor];
    [self.view addSubview:label2];
    UIView *sp2 = [UIView new];
    sp2.backgroundColor = HexRGB(0xDEDEDE);
    [self.view addSubview:sp2];

    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.equalTo(self.view).offset(10);
        make.height.equalTo(@25);
        make.top.equalTo(_qqBtn.mas_bottom).offset(30);
    }];
    [sp2 mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self)
        make.left.right.equalTo(self.view);
        make.top.equalTo(label2.mas_bottom).offset(10);
        make.height.equalTo(@1);
    }];
    
    //复制链接
    [_LinkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(sp2.mas_bottom).offset(10);
        make.left.equalTo(self.view);
        make.height.width.equalTo(_weixinBtn);
    }];
    //发送至联系人
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_LinkBtn.mas_right);
        make.top.equalTo(_LinkBtn);
        make.height.width.equalTo(_weixinBtn);
    }];
    
//    [self.viewModel.didClickWeiboBtnCommand.errors subscribeNext:^(id x) {
//        NSLog(@"微博分享失败");
//        KSError(@"微博分享失败");
//    }];
//    [self.viewModel.didClickWeiboBtnCommand.executionSignals subscribeCompleted:^{
//        NSLog(@"微博分享成功");
//        KSSuccess(@"微博分享成功");
//    }];
}




@end
