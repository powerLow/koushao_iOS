//
//  KSActivityUserSignViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/6.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityUserSignViewController.h"
#import "KSActivityUserSignViewModel.h"
#import <YYWebImage.h>
#import "Masonry.h"
#import "KSActivityOpenInPCView.h"
@interface KSActivityUserSignViewController ()


@property (nonatomic,strong,readwrite) KSActivityUserSignViewModel *viewModel;

@end

@implementation KSActivityUserSignViewController

@dynamic viewModel;

- (instancetype)initWithViewModel:(id<KSViewModelProtocol>)viewModel {
    self = [super initWithViewModel:viewModel];
    if (self) {
        if ([viewModel shouldRequestRemoteDataOnViewDidLoad]) {
            @weakify(self)
            [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
                @strongify(self)
                [self.viewModel.requestRemoteDataCommand execute:@1];
            }];
        }
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    @weakify(self)
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-49);
    }];
    
    UIView *container = [UIView new];
    [scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    UILabel *title_label  = [UILabel new];
    title_label.text = self.viewModel.activity.title;
    title_label.textAlignment = NSTextAlignmentCenter;
    title_label.textColor = [UIColor blackColor];
    title_label.font = KS_NORMAL_BOLD_FONT;
    title_label.numberOfLines = 0;
    title_label.lineBreakMode = NSLineBreakByWordWrapping;
    [container addSubview:title_label];
    
    CGSize titleSize = [title_label.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH*0.75, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KS_NORMAL_BOLD_FONT} context:nil].size;
    
    NSLog(@"计算的size = %@",NSStringFromCGSize(titleSize));
    [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(container).offset(SCREEN_HEIGHT*0.05);
        make.centerX.equalTo(container);
        make.width.mas_equalTo(SCREEN_WIDTH*0.75);
        make.height.mas_equalTo(titleSize.height+10);
    }];
    
    UIImageView *QRCodeImageView = [[UIImageView alloc] init];
    [container addSubview:QRCodeImageView];
    
    QRCodeImageView.layer.borderColor = BASE_COLOR.CGColor;
    QRCodeImageView.layer.borderWidth = 1.3;
    QRCodeImageView.layer.cornerRadius = 3.0f;
    
    
    [QRCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.centerX.equalTo(container);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.6);
        make.height.equalTo(QRCodeImageView.mas_width).multipliedBy(1.2);
        make.top.equalTo(title_label.mas_bottom).offset(SCREEN_HEIGHT*0.05);
    }];
    
    UIImageView *QRCode = [UIImageView new];
    QRCode.image = KS_PLACEHOLDER_IMAGE;
    [QRCodeImageView addSubview:QRCode];
    [QRCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(QRCodeImageView).offset(SCREEN_HEIGHT*0.05);
        make.centerX.equalTo(QRCodeImageView);
        make.width.height.equalTo(QRCodeImageView.mas_width).multipliedBy(0.8);
    }];
    
    UILabel *text_label = [UILabel new];
    text_label.textColor = BASE_COLOR;
    text_label.textAlignment = NSTextAlignmentCenter;
    text_label.text = @"扫描二维码,签到本活动";
    text_label.font = KS_SMALL_FONT;
    [QRCodeImageView addSubview:text_label];
    [text_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(QRCodeImageView);
        make.top.equalTo(QRCode.mas_bottom).offset(15);
    }];
    
    UILabel *start_time_text_label = [UILabel new];
    [container addSubview:start_time_text_label];
    start_time_text_label.text = @"开始时间";
    start_time_text_label.textAlignment = NSTextAlignmentCenter;
    start_time_text_label.font = KS_SMALL_FONT;
    
    [start_time_text_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(QRCodeImageView.mas_bottom).offset(20);
        make.centerX.equalTo(QRCodeImageView);
    }];
    
    UILabel *start_time_label = [UILabel new];
    [container addSubview:start_time_label];
    start_time_label.textAlignment = NSTextAlignmentCenter;
    start_time_label.font = KS_SMALL_FONT;
    start_time_label.text = [KSUtil StringTimeFromNumber:self.viewModel.activity.startTime withSeconds:YES];
    [start_time_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(start_time_text_label.mas_bottom).offset(5);
        make.centerX.equalTo(QRCodeImageView);
    }];
    
    UILabel *location_text_label = [UILabel new];
    [container addSubview:location_text_label];
    location_text_label.text = @"活动地点";
    location_text_label.textAlignment = NSTextAlignmentCenter;
    location_text_label.font = KS_SMALL_FONT;
    [location_text_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(start_time_label.mas_bottom).offset(10);
        make.centerX.equalTo(QRCodeImageView);
    }];
    
    
    
    CGSize location_Size = [self.viewModel.activity.location boundingRectWithSize:CGSizeMake(SCREEN_WIDTH*0.9, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KS_SMALL_FONT} context:nil].size;
    
//    UILabel *location_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)];
    UILabel *location_label = [UILabel new];
    [container addSubview:location_label];
    location_label.text = self.viewModel.activity.location;
    location_label.textAlignment = NSTextAlignmentCenter;
    location_label.font = KS_SMALL_FONT;
    location_label.numberOfLines = 0;
    location_label.lineBreakMode = NSLineBreakByWordWrapping;
    [location_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(location_text_label.mas_bottom).offset(5);
        make.centerX.equalTo(QRCodeImageView);
        make.width.equalTo(@(location_Size.width));
    }];
    
    //两个button
    //在电脑端打开
    UIButton *openpc_btn = [UIButton new];
//    openpc_btn.titleLabel.textColor = BASE_COLOR;
//    openpc_btn.titleLabel.text = @"在电脑端打开";
    [openpc_btn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
    [openpc_btn setTitle:@"在电脑端打开" forState:UIControlStateNormal];
    openpc_btn.layer.borderColor = KS_GrayColor.CGColor;
    openpc_btn.layer.borderWidth = 0.3;
    [self.view addSubview:openpc_btn];
    [[openpc_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"在电脑端打开");
        KSActivityOpenInPCView *view = [[KSActivityOpenInPCView alloc] initWithFrame:self.view.frame];
        [view showWithUrl:self.viewModel.model.shorturl copyBlock:^{
            NSLog(@"复制链接");
            [view removeViewFromSuperView];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.viewModel.model.shorturl;
            KSSuccess(@"成功复制到剪贴板");
        } shareBlock:^{
            NSLog(@"分享链接 = %@",self.viewModel.model.shorturl);
            [view removeViewFromSuperView];
            [UMSocialQQHandler setQQWithAppId:QQID appKey:QQKey url:self.viewModel.model.shorturl];
            [UMSocialWechatHandler setWXAppId:WeixinID appSecret:WeixinSecretKey url:self.viewModel.model.shorturl];
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:@"5545d79a67e58eac900024cc"
                                              shareText:self.viewModel.model.shorturl
                                             shareImage:self.viewModel.activity.thumbnail
                                        shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToTencent,UMShareToQQ,UMShareToQzone,UMShareToSms,nil]
                                               delegate:nil];
        }];
    }];
    
    //发送二维码至电脑
    UIButton *sendpc_btn = [UIButton new];
//    sendpc_btn.titleLabel.textColor = BASE_COLOR;
//    sendpc_btn.titleLabel.text = @"发送二维码至电脑";
    [sendpc_btn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
    [sendpc_btn setTitle:@"发送二维码至电脑" forState:UIControlStateNormal];
    sendpc_btn.layer.borderColor = KS_GrayColor.CGColor;
    sendpc_btn.layer.borderWidth = 0.3;
    [self.view addSubview:sendpc_btn];
    [[sendpc_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"发送二维码至电脑 = %@",QRCode.image);
        [UMSocialQQHandler setQQWithAppId:QQID appKey:QQKey url:self.viewModel.model.shorturl];
        [UMSocialWechatHandler setWXAppId:WeixinID appSecret:WeixinSecretKey url:self.viewModel.model.shorturl];
        [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
        
//        [UMSocialSnsService presentSnsIconSheetView:self
//                                             appKey:@"5545d79a67e58eac900024cc"
//                                          shareText:self.viewModel.model.shorturl
//                                         shareImage:QRCodeImageView.image
//                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToQQ,nil]
//                                           delegate:nil];
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:nil image:QRCode.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                KSSuccess(@"分享成功！");
            }
        }];
    }];
    
    [openpc_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.equalTo(container);
        make.height.equalTo(@49);
        make.width.equalTo(sendpc_btn);
        make.right.equalTo(sendpc_btn.mas_left);
        make.bottom.equalTo(self.view);
    }];
    
    [sendpc_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(container);
        make.height.equalTo(openpc_btn);
        make.width.equalTo(openpc_btn);
        make.top.equalTo(openpc_btn);
    }];
    
    //自动计算contentSize
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(location_label.mas_bottom);
    }];
    
    
    [self.viewModel.requestRemoteDataCommand.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self)
        if (executing.boolValue) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = @"请稍等";
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
    [RACObserve(self.viewModel, model) subscribeNext:^(KSQRCodeResultModel *x) {
        if (x != nil) {
            
            NSString *strUrl = [NSString stringWithFormat:@"%@?imageView2/0/h/%d",
                                x.url,
                                (int)QRCode.frame.size.width*2];
//            QRCode.yy_imageURL = [NSURL URLWithString:x.url];
            NSURL *url = [NSURL URLWithString:strUrl];
            NSLog(@"二维码下载地址:%@",strUrl);
            [QRCode yy_setImageWithURL:url options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
