//
//  KSStartpageVC.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/13.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSStartpageViewController.h"
#import "KSStartpageViewModel.h"
#import "KSLoginViewModel.h"
#import "KSLoginViewController.h"
#import "KSButton.h"
#import "Masonry.h"
#import "CustomIOSAlertView.h"
#import "KSActivityCreatManager.h"
#import "KSCreateActivityViewNavController.h"
#import "ActivityFunctionViewController.h"
#import "APService.h"
#import "KSHomepageViewModel.h"
@interface KSStartpageViewController ()
@property(strong, nonatomic) IBOutlet UIButton *loginWithPhoneBtn;
@property(strong, nonatomic) IBOutlet UIButton *loginWithSubAccountBtn;
@property(strong, nonatomic) KSButton *beginActivityBtn;
@property(strong, nonatomic) KSActivityCreatManager *activityManager;
@property(strong, nonatomic, readonly) KSStartpageViewModel *viewModel;
@end

@implementation KSStartpageViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(250,250,250);
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.beginActivityBtn = [[KSButton alloc] init];
    self.activityManager = [KSActivityCreatManager sharedManager];
    [self.beginActivityBtn setTitle:@"发起活动" forState:UIControlStateNormal];
    [self.view addSubview:_beginActivityBtn];
    [self.beginActivityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(SCREEN_WIDTH*0.6);//375
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).with.offset(SCREEN_HEIGHT * 0.13);//667
    }];
    self.navigationController.navigationBar.hidden = YES;
    [self.loginWithSubAccountBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.loginWithPhoneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //手机号登陆
    [[self.loginWithPhoneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if([KSUser currentUser])
        {
            [self dismissSelf];
        }
        else
            [self.viewModel.loginWithPhoneCommand execute:nil];
    }];
    //子账号登陆
    [[self.loginWithSubAccountBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if([KSUser currentUser])
        {
            [self dismissSelf];
        }
        else
            [self.viewModel.loginWithSubAccountCommand execute:nil];
    }];
    //创建活动
    [[self.beginActivityBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if([KSUser currentUser])
        {
            //说明有储存在本地的活动
            if (self.activityManager.hashCode && self.activityManager.hashCode.length > 0) {
                [self initAlertView];
            }
            //说明没有活动
            else {
                KSCreateActivityViewNavController *ksCreateActivityViewNavController = [[KSCreateActivityViewNavController alloc] init];
                [self presentViewController:ksCreateActivityViewNavController animated:YES completion:nil];
            }
        }
        else
            [self createLoginAlertView];
    }];
}


-(void)createNewActivityAlertView
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    UIView *customView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 260, 110)];
    UILabel* textLabel=[[UILabel alloc]init];
    [customView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(customView.mas_centerY).with.offset(30);
        make.left.mas_equalTo(customView.mas_left).with.offset(16);
        make.right.mas_equalTo(customView.mas_right).with.offset(-16);
        make.height.mas_equalTo(50);
    }];
    
    textLabel.textAlignment = NSTextAlignmentLeft;
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"是否创建新活动,此操作会清除所有的未发布的活动草稿"];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor redColor]
     
                          range:NSMakeRange(8, 17)];
    
    textLabel.attributedText = AttributedStr;
    textLabel.lineBreakMode=NSLineBreakByCharWrapping;
    textLabel.numberOfLines = 0;
    
    UILabel* titleLabel=[[UILabel alloc]init];
    [customView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(customView.mas_top).with.offset(30);
        make.left.mas_equalTo(customView.mas_left).with.offset(16);
        make.right.mas_equalTo(customView.mas_right).with.offset(-16);
        make.height.mas_equalTo(50);
    }];
    titleLabel.text=@"创建新活动";
    titleLabel.font=[UIFont boldSystemFontOfSize:19];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    
    [alertView setContainerView:customView];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
    [alertView setButtonColors:[NSMutableArray arrayWithObjects:[UIColor blackColor], KS_Maintheme_Color, nil]];
    
    [alertView show];
    
    @weakify(self);
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        @strongify(self);
        if(buttonIndex==0)
            [alertView close];
        else
        {
            KSCreateActivityViewNavController *ksCreateActivityViewNavController = [[KSCreateActivityViewNavController alloc] init];
            [self.activityManager clearInfo];
            [self.activityManager ks_delete];
            self.activityManager = [KSActivityCreatManager sharedManager];
            [self presentViewController:ksCreateActivityViewNavController animated:YES completion:nil];
            [alertView close];
            
        }
    }];
}

-(void)createLoginAlertView
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    UIView *customView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, 260)];
    UILabel* titleLabel=[[UILabel alloc]init];
    [customView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(customView.mas_top).with.offset(30);
        make.left.mas_equalTo(customView.mas_left).with.offset(16);
        make.right.mas_equalTo(customView.mas_right).with.offset(-16);
        make.height.mas_equalTo(50);
    }];
    titleLabel.text=@"快速登陆，发布活动";
    titleLabel.font=[UIFont systemFontOfSize:20];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UITextField* _mobilePhoneField=[[UITextField alloc]init];
    _mobilePhoneField.placeholder=@"输入手机号";
    _mobilePhoneField.keyboardType=UIKeyboardTypePhonePad;
    
    UITextField* _smsCodeField=[[UITextField alloc]init];
    _smsCodeField.placeholder=@"输入验证码";
    _smsCodeField.keyboardType=UIKeyboardTypeNumberPad;
    
    KSButton* _loginBtn=[[KSButton alloc]init];
    [_loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    
    KSButton* _requestSmsCodeBtn=[[KSButton alloc]init];
    _requestSmsCodeBtn.buttonColor=KS_Maintheme_Color2;
    [_requestSmsCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    UIImageView* phoneIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone"]];
    UIImageView* veryfyCodeIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"veryfy_code"]];
    UIView* line_1=[[UIView alloc]init];
    line_1.backgroundColor=KS_GrayColor0;
    
    UIView* line_2=[[UIView alloc]init];
    line_2.backgroundColor=KS_GrayColor0;
    [customView addSubview:phoneIcon];
    [customView addSubview:veryfyCodeIcon];
    [customView addSubview:line_1];
    [customView addSubview:line_2];
    [customView addSubview:_mobilePhoneField];
    [customView addSubview:_smsCodeField];
    [customView addSubview:_loginBtn];
    [customView addSubview:_requestSmsCodeBtn];
    @weakify(self);
    [phoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(customView.mas_top).with.offset(70);
        make.left.mas_equalTo(customView.mas_left).with.offset(20);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [_mobilePhoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneIcon.mas_right).with.offset(20);
        make.right.mas_equalTo(customView.mas_right).with.offset(-20);
        make.centerY.mas_equalTo(phoneIcon.mas_centerY);
        make.height.mas_equalTo(45);
    }];
    [veryfyCodeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_mobilePhoneField.mas_bottom).with.offset(40);
        make.left.mas_equalTo(customView.mas_left).with.offset(20);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    [_requestSmsCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(110);
        make.right.mas_equalTo(customView.mas_right).with.offset(-20);
        make.centerY.mas_equalTo(veryfyCodeIcon.mas_centerY);
        make.height.mas_equalTo(_mobilePhoneField);
    }];
    [_smsCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(veryfyCodeIcon.mas_right).with.offset(20);
        make.right.mas_equalTo(_requestSmsCodeBtn.mas_left).with.offset(-10);
        make.centerY.mas_equalTo(veryfyCodeIcon.mas_centerY);
        make.height.mas_equalTo(45);
    }];
    [line_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_mobilePhoneField.mas_bottom).with.offset(0);
        make.left.mas_equalTo(_mobilePhoneField);
        make.right.mas_equalTo(_mobilePhoneField);
        make.height.mas_equalTo(1);
    }];
    [line_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_smsCodeField.mas_bottom).with.offset(0);
        make.left.mas_equalTo(_smsCodeField);
        make.right.mas_equalTo(_requestSmsCodeBtn.mas_left);
        make.height.mas_equalTo(1);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line_2.mas_bottom).with.offset(20);
        make.left.mas_equalTo(customView.mas_left).with.offset(20);
        make.right.mas_equalTo(customView.mas_right).with.offset(-20);
        make.height.mas_equalTo(44);
    }];
    [alertView setContainerView:customView];
    [alertView setButtonColors:[NSMutableArray arrayWithObjects:[UIColor blackColor], KS_Maintheme_Color, nil]];
    
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [_smsCodeField resignFirstResponder];
        [_mobilePhoneField resignFirstResponder];
        
        [_loginBtn setTitle:@"登陆中" forState:UIControlStateNormal];
        _loginBtn.enabled=NO;
        [[KSClientApi loginWithPhone:_mobilePhoneField.text SmsCode:_smsCodeField.text]subscribeNext:^(id x) {
            @strongify(self);
            KSUser *user = [KSUser currentUser];
            NSLog(@"登陆成功 = %@",user.mobilePhone);
            SSKeychain.rawLogin = user.username;
            SSKeychain.accessToken = user.sessionToken;
            [APService setAlias:user.username callbackSelector:nil object:nil];
            [user ks_saveOrUpdate];
            [[KSClientApi registerDevice:user.username]subscribeNext:^(id x) {
                
            } error:^(NSError *error) {
                
            }];
            NSDictionary* params=@{@"isStartButtonPressed":@"YES"};
            KSHomepageViewModel *viewModel = [[KSHomepageViewModel alloc] initWithServices:self.viewModel.services params:params];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.viewModel.services resetRootViewModel:viewModel];
            });
            
            [alertView close];
            
        } error:^(NSError *error) {
            [_loginBtn setTitle:@"重新登陆" forState:UIControlStateNormal];
            _loginBtn.enabled=YES;
            KSError([error.userInfo objectForKey:@"tips"]);
        }];
    }];
    
    [[_requestSmsCodeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        NSString *title = [NSString stringWithFormat:@"发送中"];
        [_requestSmsCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_requestSmsCodeBtn setEnabled:NO];
        [_requestSmsCodeBtn setTitle:title forState:UIControlStateNormal];
        
        [[KSClientApi requestSMSCode:_mobilePhoneField.text withType:1]subscribeNext:^(id x) {
            __block int timeout=60;
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_requestSmsCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                        [_requestSmsCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        _requestSmsCodeBtn.enabled = YES;
                    });
                }else{
                    //int seconds = timeout % 60;
                    int seconds = timeout;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:1];
                        [_requestSmsCodeBtn setTitle:[NSString stringWithFormat:@"%@s剩余",strTime] forState:UIControlStateNormal];
                        [UIView commitAnimations];
                        _requestSmsCodeBtn.enabled = NO;
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
            
        } error:^(NSError *error) {
            KSError([error.userInfo objectForKey:@"tips"]);
            NSString *title = [NSString stringWithFormat:@"重新获取"];
            [_requestSmsCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_requestSmsCodeBtn setEnabled:YES];
            [_requestSmsCodeBtn setTitle:title forState:UIControlStateNormal];
        }];
        
    }];
    
    RAC(_loginBtn, enabled) =[[RACSignal
                               combineLatest:@[[_mobilePhoneField rac_textSignal], [_smsCodeField rac_textSignal]] reduce:^id(NSString *mobilePhone, NSString *smscode) {
                                   return @(mobilePhone.length == 11 && smscode.length > 0);
                               }]
                              distinctUntilChanged];
    [alertView show];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissSelf)
                                                 name:REFRESH_ACTIVITY_LIST
                                               object:nil];
}

- (void)dismissSelf {
    [self dismissViewControllerAnimated:YES completion:^(void){
        [[NSNotificationCenter defaultCenter]postNotificationName:ACTIVITY_PUBLISH_FINISH object:nil userInfo:nil];
    }];
    //在这里跳转登陆成功
    [self.viewModel.loginCommand execute:nil];
}


- (void)initAlertView {
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 160)];
    UIButton *button1 = [[UIButton alloc] init];
    [customView addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(customView.mas_centerY).with.offset(10);
        make.left.mas_equalTo(customView.mas_left).with.offset(16);
        make.right.mas_equalTo(customView.mas_right).with.offset(-16);
        make.height.mas_equalTo(50);
    }];
    [button1 setTitle:@"不，我要创建新的活动" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [[button1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self createNewActivityAlertView];
        [alertView close];
        
    }];
    
    UIButton *button2 = [[UIButton alloc] init];
    [customView addSubview:button2];
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(customView.mas_centerY).with.offset(45);
        make.left.mas_equalTo(customView.mas_left).with.offset(16);
        make.right.mas_equalTo(customView.mas_right).with.offset(-16);
        make.height.mas_equalTo(50);
    }];
    [button2 setTitle:@"返回上次活动编辑" forState:UIControlStateNormal];
    [button2 setTitleColor:BASE_COLOR forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:20];
    button2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [[button2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        KSCreateActivityViewNavController *ksCreateActivityViewNavController = [[KSCreateActivityViewNavController alloc] init];
        if(self.activityManager.isTempleteSettingComplete)
        {
            ActivityFunctionViewController *activityFunctionViewNavController = [[ActivityFunctionViewController alloc] init];
            ksCreateActivityViewNavController.startViewController = activityFunctionViewNavController;
        }
        [self presentViewController:ksCreateActivityViewNavController animated:YES completion:nil];
        [alertView close];
    }];
    UILabel *titleLabel = [[UILabel alloc] init];
    [customView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(customView.mas_top).with.offset(30);
        make.left.mas_equalTo(customView.mas_left).with.offset(16);
        make.right.mas_equalTo(customView.mas_right).with.offset(-16);
        make.height.mas_equalTo(50);
    }];
    titleLabel.text = @"是否返回上次编辑";
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [alertView setContainerView:customView];
    [alertView setButtonColors:[NSMutableArray arrayWithObjects:[UIColor blackColor], KS_Maintheme_Color, nil]];
    
    [alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
