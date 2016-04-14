//
//  ViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSLoginViewController.h"
#import "KSLoginViewModel.h"
#import "KSButton.h"
#import "Masonry.h"

@interface KSLoginViewController ()
@property(strong, nonatomic) UITextField *mobilePhoneField;
@property(strong, nonatomic) UITextField *smsCodeField;
@property(strong, nonatomic) KSButton *loginBtn;
@property(strong, nonatomic) KSButton *requestSmsCodeBtn;
@property(assign, nonatomic) NSInteger seconds;
@property(nonatomic, strong, readonly) KSLoginViewModel *viewModel;
@property(nonatomic, strong) NSTimer *timer;

@end

@implementation KSLoginViewController

@dynamic viewModel;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView {
    _mobilePhoneField = [[UITextField alloc] init];
    _mobilePhoneField.placeholder = @"输入手机号";
    _mobilePhoneField.keyboardType = UIKeyboardTypePhonePad;
    
    _smsCodeField = [[UITextField alloc] init];
    _smsCodeField.placeholder = @"输入验证码";
    _smsCodeField.keyboardType = UIKeyboardTypeNumberPad;
    
    _loginBtn = [[KSButton alloc] init];
    [_loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    
    _requestSmsCodeBtn = [[KSButton alloc] init];
    _requestSmsCodeBtn.buttonColor = KS_Maintheme_Color2;
    [_requestSmsCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    UIImageView *phoneIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone"]];
    UIImageView *veryfyCodeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"veryfy_code"]];
    UIView *line_1 = [[UIView alloc] init];
    line_1.backgroundColor = KS_GrayColor0;
    
    UIView *line_2 = [[UIView alloc] init];
    line_2.backgroundColor = KS_GrayColor0;
    [self.view addSubview:phoneIcon];
    [self.view addSubview:veryfyCodeIcon];
    [self.view addSubview:line_1];
    [self.view addSubview:line_2];
    [self.view addSubview:_mobilePhoneField];
    [self.view addSubview:_smsCodeField];
    [self.view addSubview:_loginBtn];
    [self.view addSubview:_requestSmsCodeBtn];
    
    CGFloat marginX = SCREEN_WIDTH * 0.07;
    @weakify(self);
    [phoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.view.mas_top).with.offset(100);
        make.left.mas_equalTo(self.view.mas_left).with.offset(marginX);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [_mobilePhoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(phoneIcon.mas_right).with.offset(20);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-marginX);
        make.centerY.mas_equalTo(phoneIcon.mas_centerY);
        make.height.mas_equalTo(45);
    }];
    [veryfyCodeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        //        @strongify(self);
        make.top.mas_equalTo(_mobilePhoneField.mas_bottom).with.offset(40);
        make.left.mas_equalTo(phoneIcon);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    [_requestSmsCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.mas_equalTo(110);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-marginX);
        make.centerY.mas_equalTo(_smsCodeField);
        make.height.mas_equalTo(_smsCodeField);
    }];
    [_smsCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_mobilePhoneField);
        make.right.mas_equalTo(_requestSmsCodeBtn.mas_left).with.offset(-10);
        make.centerY.mas_equalTo(veryfyCodeIcon.mas_centerY);
        make.height.mas_equalTo(45);
    }];
    [line_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        //        @strongify(self);
        make.top.mas_equalTo(_mobilePhoneField.mas_bottom).with.offset(0);
        make.left.mas_equalTo(_mobilePhoneField);
        make.right.mas_equalTo(_mobilePhoneField);
        make.height.mas_equalTo(1);
    }];
    [line_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        //        @strongify(self);
        make.top.mas_equalTo(_smsCodeField.mas_bottom).with.offset(0);
        make.left.mas_equalTo(_smsCodeField);
        make.right.mas_equalTo(_requestSmsCodeBtn.mas_left);
        make.height.mas_equalTo(1);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        @strongify(self);
        make.top.mas_equalTo(line_2.mas_bottom).with.offset(35);
        make.left.mas_equalTo(phoneIcon);
        make.right.mas_equalTo(_mobilePhoneField);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.08);
    }];
}

- (void)timerFireMethod:(NSTimer *)theTimer {
    if (_seconds == 1) {
        [theTimer invalidate];
        _seconds = 60;
        [_requestSmsCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_requestSmsCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_requestSmsCodeBtn setEnabled:YES];
    } else {
        _seconds--;
        NSString *title = [NSString stringWithFormat:@"剩余%lis", (long)_seconds];
        [_requestSmsCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_requestSmsCodeBtn setEnabled:NO];
        [_requestSmsCodeBtn setTitle:title forState:UIControlStateNormal];
    }
}

//如果登陆成功，停止验证码的倒数，
- (void)releaseTImer {
    if (_timer) {
        if ([_timer respondsToSelector:@selector(isValid)]) {
            if ([_timer isValid]) {
                [_timer invalidate];
                _seconds = 60;
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark

- (BOOL)isValidUsername:(NSString *)text {
    NSLog(@"isValidUsername = %@", text);
    return text.length > 3;
}

- (BOOL)isValidPassword:(NSString *)text {
    NSLog(@"isValidPassword = %@", text);
    return text.length > 3;
}

#pragma - rac

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self)
    
    RAC(self.viewModel, mobilePhone) = [self.mobilePhoneField.rac_textSignal map:^(NSString *mobilePhone) {
        return [mobilePhone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }];
    
    RAC(self.viewModel, smscode) = self.smsCodeField.rac_textSignal;
    
    RAC(self.loginBtn, enabled) = self.viewModel.validLoginSignal;
    
    
    [[self.loginBtn
      rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self)
         [self.viewModel.loginCommand execute:nil];
     }];
    
    [[self.requestSmsCodeBtn
      rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self)
         [self.viewModel.requestSmsCommand execute:nil];
     }];
    
    [self.viewModel.requestSmsCommand.executing
     subscribeNext:^(NSNumber *executing) {
         @strongify(self)
         if (executing.boolValue) {
             [self.view endEditing:YES];
             NSString *title = [NSString stringWithFormat:@"发送中"];
             [_requestSmsCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
             [_requestSmsCodeBtn setEnabled:NO];
             [_requestSmsCodeBtn setTitle:title forState:UIControlStateNormal];
             //                [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].labelText = @"请求中...";
         } else {
             //                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
         }
     }];
    [self.viewModel.requestSmsCommand.errors
     subscribeNext:^(NSError *error) {
         KSError([error.userInfo objectForKey:@"tips"]);
         [_requestSmsCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
         [_requestSmsCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         [_requestSmsCodeBtn setEnabled:YES];
     }];
    
    [RACObserve(self.viewModel, isSmsRequestSuccess) subscribeNext:^(id x) {
        if ([x boolValue]) {
            _seconds = 60;
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        }
    }];
    
    
    [self.viewModel.loginCommand.executing
     subscribeNext:^(NSNumber *executing) {
         @strongify(self)
         if (executing.boolValue) {
             [self.view endEditing:YES];
             [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].labelText = @"登陆中...";
         } else {
             [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
         }
     }];
    
    [self.viewModel.loginCommand.errors
     subscribeNext:^(NSError *error) {
         KSError(@"登陆失败");
     }];
}
@end
