//
//  KSActivityManagerViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/25.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityManagerViewController.h"
#import "KSActivityManagerViewModel.h"
#import "Masonry.h"
#import "KSStopActivityResultModel.h"

@interface KSManagerButton()

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,assign) BOOL isOpen;

@end

@implementation KSManagerButton
@end

@interface KSActivityManagerViewController ()
@property (strong, nonatomic)  UIView *headerView;
@property (strong, nonatomic)  UIButton *visitsBtn;
@property (strong, nonatomic)  UIButton *enrollBtn;
@property (strong, nonatomic)  UILabel *visitsLabel;
@property (strong, nonatomic)  UILabel *enrollLabel;

@property (strong, nonatomic, readwrite) KSActivityManagerViewModel *viewModel;
@end

@implementation KSActivityManagerViewController

@dynamic viewModel;
//- (instancetype)initWithViewModel:(id<KSViewModelProtocol>)viewModel {
//    self = [super initWithViewModel:viewModel];
//    if (self) {
//        if ([viewModel shouldRequestRemoteDataOnViewDidLoad]) {
//            @weakify(self)
//            [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
//                @strongify(self)
//                [self.viewModel.requestRemoteDataCommand execute:@1];
//            }];
//        }
//        
//    }
//    return self;
//}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.viewModel.activity = [KSUtil getCurrentActivity];
    //每次进入都刷新一下?
    [self.viewModel.requestRemoteDataCommand execute:@1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view.backgroundColor = HexRGB(0xEDEDED);
    
    @weakify(self)
    
    if(![KSUser currentUser].isSubAccount){
        //headerView
        self.headerView = [UIView new];
        [self.view addSubview:_headerView];
        self.visitsLabel = [UILabel new];
        self.enrollLabel = [UILabel new];
        self.visitsBtn = [UIButton new];
        self.enrollBtn = [UIButton new];
        
        _visitsBtn.rac_command = self.viewModel.didClickBrowseDetailCommand;
        _enrollBtn.rac_command = self.viewModel.didClickEnrollDetailCommand;
        
        [_headerView addSubview:_visitsBtn];
        [_headerView addSubview:_enrollBtn];
        
        [_visitsBtn addSubview:_visitsLabel];
        [_enrollBtn addSubview:_enrollLabel];
        
        [_visitsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(_headerView);
            //        make.right.equalTo(_enrollBtn.mas_left);
            make.width.equalTo(_enrollBtn);
        }];
        [_enrollBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_visitsBtn.mas_right);
            make.right.top.bottom.equalTo(_headerView);
        }];
        
        _visitsLabel.textColor = [UIColor whiteColor];
        _visitsLabel.textAlignment = NSTextAlignmentCenter;
        _visitsLabel.text = @"0";
        _visitsLabel.font = [UIFont boldSystemFontOfSize:50.0];
        
        _enrollLabel.textColor = [UIColor whiteColor];
        _enrollLabel.textAlignment = NSTextAlignmentCenter;
        _enrollLabel.text = @"0";
        _enrollLabel.font = [UIFont boldSystemFontOfSize:50.0];
        
        UILabel *visitsTextLabel = [UILabel new];
        visitsTextLabel.text = @"次浏览";
        visitsTextLabel.textAlignment = NSTextAlignmentCenter;
        visitsTextLabel.textColor = [UIColor whiteColor];
        [_visitsBtn addSubview:visitsTextLabel];
        
        UILabel *enrollTextLabel = [UILabel new];
        enrollTextLabel.text = @"次报名";
        enrollTextLabel.textAlignment = NSTextAlignmentCenter;
        enrollTextLabel.textColor = [UIColor whiteColor];
        [_visitsBtn addSubview:enrollTextLabel];
        
        UIImageView *leftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_down"]];
        UIImageView *rightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_down"]];
        [_visitsBtn addSubview:leftImage];
        [_enrollBtn addSubview:rightImage];
        [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(visitsTextLabel);
            make.left.equalTo(visitsTextLabel.mas_right).offset(3);
        }];
        [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(visitsTextLabel);
            make.left.equalTo(enrollTextLabel.mas_right).offset(3);
        }];
        [RACObserve(self.viewModel, activity) subscribeNext:^(KSActivity* act) {
            if (act != nil) {
                leftImage.hidden = [act.visits integerValue] ==  0;
                rightImage.hidden = [act.enroll integerValue] == 0;
                
                _visitsBtn.enabled = [act.visits integerValue] !=  0;
                _enrollBtn.enabled = [act.enroll integerValue] != 0;
                
                //次报名在下面
                [enrollTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(_enrollBtn).offset([act.enroll integerValue] == 0 ? 0 :-5);
                }];
                //次浏览在下面
                [visitsTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(_visitsBtn).offset([act.visits integerValue] == 0 ? 0 :-5);
                }];
                
            }
        }];
        
        //浏览次数
        [_visitsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_visitsBtn);
            make.centerY.equalTo(_visitsBtn).offset(-10);
            make.height.equalTo(_visitsBtn).multipliedBy(0.5);
        }];
        
        //次浏览在下面
        [visitsTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_visitsBtn).offset(-5);
            make.top.equalTo(_visitsLabel.mas_bottom);
        }];
        //报名人数
        [_enrollLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_enrollBtn);
            make.centerY.equalTo(_visitsBtn).offset(-10);
            make.height.equalTo(_visitsBtn).multipliedBy(0.5);
        }];
        //次报名在下面
        [enrollTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_enrollBtn).offset(-5);
            make.top.equalTo(_enrollLabel.mas_bottom);
        }];
        
        _headerView.backgroundColor = BASE_COLOR;
        
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.top.equalTo(self.mas_topLayoutGuideBottom);
            make.left.right.equalTo(self.view);
            make.height.equalTo(self.view).multipliedBy(0.2);
        }];
    }
    
    
    CGFloat containHeight = SCREEN_HEIGHT*0.8-49-64;
    
    
    //button
    UIView *containView = [UIView new];
    [self.view addSubview:containView];
//    containView.backgroundColor = [UIColor redColor];
    UIImage *unopenImage = [UIImage imageNamed:@"icon_module_unopen"];
    
    NSMutableArray *titles = [NSMutableArray new];
    KSUser *user = [KSUser currentUser];
    if (user.isSubAccount) {
        if ([user.attr.question boolValue]) {
            [titles addObject:@"咨询回复"];
        }
        if ([user.attr.welfare boolValue]) {
            [titles addObject:@"福利管理"];
        }
        if ([user.attr.signin boolValue]) {
            [titles addObject:@"签到管理"];
        }
        [titles addObject:@"查看该活动"];
    }else{
        [titles addObjectsFromArray:@[@"分享活动",@"咨询回复",@"福利管理",@"签到管理",@"添加管理员",@"查看该活动"]];
    }
    
    
    
    NSMutableArray *btns =  [[NSMutableArray alloc] init];
    for (int i = 0; i < titles.count; ++i) {
        KSManagerButton *button = [KSManagerButton new];
        button.title = titles[i];
        if ([button.title isEqualToString:@"分享活动"]) {
            button.isOpen = YES;
            button.imageName = @"icon_share_act";
            button.rac_command = button.isOpen == YES ? self.viewModel.didClickShareBtnCommand : nil;
        }else if ([button.title isEqualToString:@"咨询回复"]) {
            button.isOpen = [self.viewModel.activity.attr.module.question boolValue];
            button.isOpen = user.isSubAccount ? (button.isOpen &  [user.attr.question boolValue]) : button.isOpen;
            button.imageName = @"icon_consult_reply";
            button.rac_command = button.isOpen == YES ? self.viewModel.didClickAskBtnCommand : nil;
        }else if ([button.title isEqualToString:@"福利管理"]) {
            button.isOpen = [self.viewModel.activity.attr.module.welfare boolValue];
            button.isOpen = user.isSubAccount ? (button.isOpen &  [user.attr.welfare boolValue]) : button.isOpen;
            button.imageName = @"icon_welfare_admin";
            button.rac_command = button.isOpen == YES ? self.viewModel.didClickWelfareBtnCommand : nil;
        }else if ([button.title isEqualToString:@"签到管理"]) {
            button.isOpen = [self.viewModel.activity.attr.module.signin boolValue];
            if (user.isSubAccount) {
                button.isOpen = button.isOpen & [user.attr.signin boolValue]
                & [self.viewModel.activity.attr.ticket.verify boolValue];
            }else{
                button.isOpen = button.isOpen & [self.viewModel.activity.attr.ticket.verify boolValue];
            }
            button.imageName = @"icon_sign_admin";
            button.rac_command = button.isOpen == YES ? self.viewModel.didClickSignBtnCommand : nil;
        }else if ([button.title isEqualToString:@"添加管理员"]) {
            button.isOpen = user.isSubAccount ? NO : YES;
            button.imageName = @"icon_add_admin";
            button.rac_command = button.isOpen == YES ? self.viewModel.didClickAdminBtnCommand : nil;
        }else if ([button.title isEqualToString:@"查看该活动"]) {
            button.isOpen = YES;
            button.imageName = @"icon_preview";
            button.rac_command = button.isOpen == YES ? self.viewModel.didClickLookBtnCommand : nil;
        }
        [btns addObject:button];
        
    }
    for (int i = 0; i<btns.count; i++) {
        KSManagerButton* btn = (KSManagerButton*)btns[i];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.borderColor = [UIColor grayColor].CGColor;
        [containView addSubview:btn];
        NSString *imageName =  btn.imageName;
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:imageName];
        [btn addSubview:imageView];
        UILabel *label = [UILabel new];
        label.text = btn.title;
        label.textColor = [UIColor blackColor];
        [btn addSubview:label];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.centerY.equalTo(btn).with.offset(-10);
            make.height.width.equalTo(@35);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.top.equalTo(imageView.mas_bottom).offset(5);
        }];
        if (!btn.isOpen) {
            //没开启
            UIImageView *unopenView = [UIImageView new];
            [btn addSubview:unopenView];
            unopenView.image = unopenImage;
            [unopenView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.equalTo(btn);
//                make.height.width.mas_equalTo(SCREEN_WIDTH * 0.15);
            }];
        }
    }
    //停止按钮
    UIButton *stopBtn = [UIButton new];
    stopBtn.backgroundColor = [UIColor whiteColor];
    stopBtn.layer.borderColor = [UIColor grayColor].CGColor;
    
    if (self.viewModel.activity.status == KSActivityStatusEnd) {

        NSString *title = [NSString stringWithFormat:@"活动已结束: %@",[KSUtil StringTimeFromNumber:self.viewModel.activity.endTime withSeconds:NO]];
        [stopBtn setTitle:title forState:UIControlStateDisabled];
        [stopBtn setEnabled:NO];
        [stopBtn setTitleColor:KS_GrayColor4 forState:UIControlStateDisabled];
    }else{
        if ([KSUser currentUser].isSubAccount) {
            [stopBtn setTitle:@"活动进行中" forState:UIControlStateNormal];
            [stopBtn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
        }else{
            [stopBtn setTitle:@"停止活动" forState:UIControlStateNormal];
            [stopBtn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
            [[stopBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确定停止该活动吗?\n活动停止后将不可再恢复" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber *x) {
                    if ([x integerValue] == 1) {
                        NSLog(@"确定");
                        [self.viewModel.didClickStopBtnCommand execute:@1];
                    }
                }];
                [alert show];
            }];
            [self.viewModel.didClickStopBtnCommand.executing subscribeNext:^(NSNumber *executing) {
                @strongify(self)
                if (executing.boolValue) {
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = @"停止中...";
                } else {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
            }];
            [self.viewModel.didClickStopBtnCommand.executionSignals.switchToLatest subscribeNext:^(KSStopActivityResultModel *x) {
                if (x != nil) {
                    NSLog(@"停止活动成功 = %@",x.endtime);
                    NSString *title = [NSString stringWithFormat:@"活动已结束: %@",[KSUtil StringTimeFromNumber:x.endtime withSeconds:YES]];
                    [stopBtn setTitle:title forState:UIControlStateDisabled];
                    [stopBtn setTitleColor:KS_GrayColor4 forState:UIControlStateDisabled];
                    [stopBtn setEnabled:NO];
                    KSActivity *act = [KSUtil getCurrentActivity];
                    act.status = KSActivityStatusEnd;
                    act.endTime = x.endtime;
                }
            }];
        }
        
    }
    
    
    [self.view addSubview:stopBtn];
    stopBtn.layer.borderWidth = 0.3;
    stopBtn.layer.borderColor = KS_GrayColor.CGColor;
    [stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@49);
    }];
    
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.right.equalTo(self.view);
        if (user.isSubAccount) {
            make.top.equalTo(self.mas_topLayoutGuideBottom);
        }else{
            make.top.equalTo(_headerView.mas_bottom);
        }
        
//        make.bottom.equalTo(stopBtn.mas_top);
        make.height.mas_equalTo(containHeight);
    }];
    //停止按钮和headerView之间等宽排列
    NSUInteger col = 2;
    NSUInteger row = 3;
    UIView *lastView = nil;
    for (int i = 0; i < btns.count; ++i) {
        UIButton *btn = btns[i];
        btn.layer.borderWidth = 0.3;
        btn.layer.borderColor = KS_GrayColor.CGColor;
        if (lastView == nil) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(containView);
                make.left.equalTo(containView);
            }];
        }else{
            if (i % col == 0) {
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(containView);
                    make.top.equalTo(lastView.mas_bottom);
                }];
            }else{
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(containView);
                    make.top.equalTo(lastView);
                }];
            }
        }
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(containHeight* 1.0 / (CGFloat)row);
            make.width.equalTo(containView).multipliedBy(0.5);
        }];
        
        lastView = btn;
    }
    [RACObserve(self.viewModel, activity) subscribeNext:^(KSActivity* act) {
        if (act != nil) {
            NSLog(@"当前活动 = %@",act);
            self.visitsLabel.text = [NSString stringWithFormat:@"%@",act.visits == nil? @0 : act.visits];
            self.enrollLabel.text = [NSString stringWithFormat:@"%@",act.enroll == nil? @0 : act.enroll];
        }else{
            self.visitsLabel.text = @"0";
            self.enrollLabel.text = @"0";
        }
    }];
    [RACObserve(self.viewModel, baseinfo) subscribeNext:^(KSActivityBaseInfoModel* baseinfo) {
        if (baseinfo != nil) {
            self.viewModel.activity.enroll = baseinfo.enroll;
            self.viewModel.activity.visits = baseinfo.visits;
            self.visitsLabel.text = [NSString stringWithFormat:@"%@",baseinfo.visits == nil? @0 : baseinfo.visits];
            self.enrollLabel.text = [NSString stringWithFormat:@"%@",baseinfo.enroll == nil? @0 : baseinfo.enroll];
        }else{
            self.visitsLabel.text = @"0";
            self.enrollLabel.text = @"0";
        }
    }];
}


@end
