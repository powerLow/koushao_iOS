//
//  KSLoginSubViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/13.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSLoginSubViewModel.h"
#import "KSButton.h"
#import "Masonry.h"
#import "KSHomepageViewModel.h"
#import "KSLoginSubViewController.h"

@interface KSLoginSubViewController ()
@property(nonatomic,strong)KSLoginSubViewModel* viewModel;
@end

@implementation KSLoginSubViewController
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}


-(void)initView
{
    UITextField* _mobilePhoneField=[[UITextField alloc]init];
    _mobilePhoneField.placeholder=@"输入帐号";
    
    UITextField* _passwordField=[[UITextField alloc]init];
    _passwordField.placeholder=@"输入密码";
    _passwordField.keyboardType=UIKeyboardTypeDefault;
    _passwordField.secureTextEntry = YES;
    
    
    KSButton* _loginBtn=[[KSButton alloc]init];
    [_loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    
    @weakify(self);

    UIImageView* phoneIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone"]];
    UIImageView* passwordIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password"]];
    UIView* line_1=[[UIView alloc]init];
    line_1.backgroundColor=KS_GrayColor0;
    
    UIView* line_2=[[UIView alloc]init];
    line_2.backgroundColor=KS_GrayColor0;
    [ self.view addSubview:phoneIcon];
    [ self.view addSubview:passwordIcon];
    [ self.view addSubview:line_1];
    [ self.view addSubview:line_2];
    [ self.view addSubview:_mobilePhoneField];
    [ self.view addSubview:_passwordField];
    [ self.view addSubview:_loginBtn];
    CGFloat marginX = SCREEN_WIDTH * 0.08;
    [phoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo( self.view.mas_top).with.offset(104);
        make.left.mas_equalTo(self.view.mas_left).with.offset(marginX);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [_mobilePhoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(phoneIcon.mas_right).with.offset(20);
        make.right.mas_equalTo( self.view.mas_right).with.offset(-marginX);
        make.centerY.mas_equalTo(phoneIcon.mas_centerY);
        make.height.mas_equalTo(45);
    }];
    [passwordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(_mobilePhoneField.mas_bottom).with.offset(40);
        make.left.mas_equalTo( self.view.mas_left).with.offset(marginX);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(passwordIcon.mas_right).with.offset(20);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-marginX);
        make.centerY.mas_equalTo(passwordIcon.mas_centerY);
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
        make.top.mas_equalTo(_passwordField.mas_bottom).with.offset(0);
        make.left.mas_equalTo(_passwordField);
        make.right.mas_equalTo(_passwordField);
        make.height.mas_equalTo(1);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(line_2.mas_bottom).with.offset(35);
        make.left.mas_equalTo(self.view.mas_left).with.offset(marginX);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-marginX);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.08);
    }];
    
    [[_loginBtn
      rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self)
         [self.viewModel.loginCommand execute:nil];
     }];
    
    
    UILabel *tip_label = [UILabel new];
    tip_label.text = @"子账号是活动举办方创建的专门管理活动的操作人员账号，该账号仅具备部分操作权限，并不能发起活动及查看数据记录";
    tip_label.font = KS_FONT_16;
    tip_label.textColor = [UIColor orangeColor];
    tip_label.lineBreakMode=NSLineBreakByCharWrapping;
    tip_label.numberOfLines = 0;
    [self.view addSubview:tip_label];
    
    [tip_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(_loginBtn);
        make.top.equalTo(_loginBtn.mas_bottom).offset(30);
        make.height.mas_equalTo(100);
        
    }];
    
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [_passwordField resignFirstResponder];
        [_mobilePhoneField resignFirstResponder];
        
        [_loginBtn setTitle:@"登陆中……" forState:UIControlStateNormal];
        _loginBtn.enabled=NO;
        [[KSClientApi loginWithSubAccount:_mobilePhoneField.text password:_passwordField.text]subscribeNext:^(id x) {
            KSUser *user = [KSUser currentUser];
            NSLog(@"登陆成功 = %@",user.mobilePhone);
            SSKeychain.rawLogin = user.username;
            SSKeychain.accessToken = user.sessionToken;
            [user ks_saveOrUpdate];
            KSHomepageViewModel *viewModel = [[KSHomepageViewModel alloc] initWithServices:self.viewModel.services params:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.viewModel.services resetRootViewModel:viewModel];
            });
            
            //Todo 登陆后跳转
        } error:^(NSError *error) {
            [_loginBtn setTitle:@"重新登陆" forState:UIControlStateNormal];
            _loginBtn.enabled=YES;
            KSError([error.userInfo objectForKey:@"tips"]);
        }];
    }];
    
    
    RAC(_loginBtn, enabled) =[[RACSignal
                               combineLatest:@[[_mobilePhoneField rac_textSignal], [_passwordField rac_textSignal]] reduce:^id(NSString *mobilePhone, NSString *smscode) {
                                   return @(mobilePhone.length >11 && smscode.length > 0);
                               }]
                              distinctUntilChanged];
    
    RAC(self.viewModel,username) = [_mobilePhoneField.rac_textSignal map:^(NSString *username) {
        return [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }];
    
    RAC(self.viewModel, password) = _passwordField.rac_textSignal;
    
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
    
    
    
    [[_loginBtn
      rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self)
         [self.viewModel.loginCommand execute:nil];
     }];
    
    
}

@end
