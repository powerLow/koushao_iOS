//
//  KSActivitySignCodeViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/6.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivitySignCodeViewController.h"
#import "KSActivitySignCodeViewModel.h"
#import "Masonry.h"
#import "KSCodeView.h"
@interface KSActivitySignCodeViewController () <KSInputViewDelegate>

@property (nonatomic,strong) KSActivitySignCodeViewModel *viewModel;
@property (nonatomic,strong) KSCodeView *inputView;

@end

@implementation KSActivitySignCodeViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    @weakify(self)
    [self.viewModel.requestRemoteDataCommand.errors subscribeNext:^(NSError *x) {
        NSLog(@"短信验证出错 = %@",x);
        if (x.code == KSInstantErrorTicketNotFound) {
            KSError(@"验证失败:没有找到该验证码");
        }else{
            
        }
    }];

    
    UILabel *label = [UILabel new];
    label.text = @"请输入五位验证码";
    [self.view addSubview:label];
    
    NSUInteger offset = SCREEN_HEIGHT * 0.05;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.equalTo(@30);
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(offset);
    }];
    
    double w = SCREEN_WIDTH * 0.8;
    double h = w / 5;
    KSCodeView *inputView = [[KSCodeView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    [self.view addSubview:inputView];
    
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.centerX.equalTo(self.view);
        make.top.equalTo(label.mas_bottom).offset(offset);
        make.height.equalTo(@50);
        make.width.equalTo(self.view).multipliedBy(0.8);
    }];
    inputView.delegate =self;
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputViewOnTouch:)];
    
    [inputView addGestureRecognizer:tapGesture];
    self.inputView = inputView;

    UIButton *viewButton = [UIButton new];
    [viewButton setTitle:@"查看本次活动全部签到记录" forState:UIControlStateNormal];
    [viewButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.view addSubview:viewButton];
    viewButton.titleLabel.font = KS_SMALL_FONT;
    
    [viewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.centerX.equalTo(self.view);
        make.top.equalTo(inputView.mas_bottom).offset(offset);
    }];
    
    [[viewButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.didClickViewRecordCommand execute:nil];
    }];
    
    [self.viewModel.requestRemoteDataCommand.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self)
        if (executing.boolValue) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = @"验证中...";
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        [inputView clear];
        [KSUtil runAfterSecs:0.5 block:^{
           [KSUtil runInMainQueue:^{
                [inputView.responsder becomeFirstResponder];
           }];
        }];
       
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_inputView.responsder becomeFirstResponder];
}

- (void)inputViewOnTouch:(UITapGestureRecognizer*)tap{
    KSCodeView* inputView = (KSCodeView*) tap.view;
    [inputView.responsder becomeFirstResponder];
}

#pragma mark - KSInputViewDelegate
- (void)finish:(NSString *)code{
    NSLog(@"code = %@",code);
    [self.viewModel.didSubmitCommand execute:code];
}
@end
