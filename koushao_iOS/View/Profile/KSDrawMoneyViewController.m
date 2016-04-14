//
//  KSDrawMoneyViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/30.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSDrawMoneyViewController.h"
#import "KSDrawMoneyViewModel.h"
#import "KSButton.h"
#import "Masonry.h"
#import "UITextField+maxLength.h"
#import "CustomIOSAlertView.h"
#import "KSClientApi.h"
#import "KSAboutUsViewController.h"
#import "ImageUploader.h"

@interface KSDrawMoneyViewController ()
@property(strong, nonatomic) UITextField *alipayAccountField;
@property(strong, nonatomic) UITextField *userNameField;
@property(strong, nonatomic) UITextField *amountOfMoney;
@property(strong, nonatomic) UITextField *smsCodeField;
@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) UIView *scrollViewContainer;
@property(strong, nonatomic) UIView *bottomView;
@property(strong, nonatomic) UILabel *bottomTitleLabel;
@property(strong, nonatomic) KSButton *requestSmsCodeBtn;
@property(assign, nonatomic) NSInteger seconds;
@property(nonatomic, strong) NSTimer *timer;

@property(nonatomic, copy) NSString *alipayAccountStr;
@property(nonatomic, copy) NSString *nameOfApplierStr;
@property(nonatomic, copy) NSString *amountOfMoneyStr;
@property(nonatomic, copy) NSString *smsCodeStr;
@property(nonatomic, copy) NSString *imagePath;

@property(nonatomic, strong) UIView *selectPhoto;
@property(nonatomic, strong) KSDrawMoneyViewModel *viewModel;
@end

@implementation KSDrawMoneyViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initScrollView];
    if ([self.viewModel.moneyinfo.applicant floatValue] > 0) {
        [self initTitleBar];
        [self initDrawCashView];
    }
    else {
        [self initNoMoneyView];
    }
}

/**
 *  可提现金额为0的时候的所要初始化的View
 */
- (void)initNoMoneyView {
    UIImageView *cryImageView = [[UIImageView alloc] init];
    cryImageView.image = [UIImage imageNamed:@"ku"];
    //底部区域
    _bottomView = [[UIView alloc] init];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.text = @"您当前没有可提现的余额";
    tipsLabel.font = [UIFont systemFontOfSize:17];
    tipsLabel.textColor = KS_Maintheme_Color2;
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    
    [_scrollViewContainer addSubview:tipsLabel];
    [_scrollViewContainer addSubview:_bottomView];
    [_scrollViewContainer addSubview:cryImageView];
    
    [cryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_scrollViewContainer.mas_centerX);
        make.top.mas_equalTo(_scrollViewContainer.mas_top).with.offset(60);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cryImageView.mas_bottom);
        make.left.mas_equalTo(_scrollViewContainer.mas_left).with.offset(20);
        make.right.mas_equalTo(_scrollViewContainer.mas_right).with.offset(-20);
        make.height.mas_equalTo(44);
    }];
    _bottomView.backgroundColor = [KSUtil colorWithHexString:@"#EFEFEF"];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipsLabel.mas_bottom).with.offset(60);
        make.bottom.mas_equalTo(_scrollViewContainer.mas_bottom);
        make.left.mas_equalTo(_scrollViewContainer.mas_left);
        make.right.mas_equalTo(_scrollViewContainer.mas_right);
    }];
    
    KSButton *backButton = [[KSButton alloc] init];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [_bottomView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bottomView.mas_top).with.offset(30);
        make.centerX.mas_equalTo(_scrollViewContainer.mas_centerX);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(42);
    }];
    @weakify(self);
    [[backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

/**
 *  初始化提现的表单
 */
- (void)initForm {
    _alipayAccountField = [[UITextField alloc] init];
    _alipayAccountField.placeholder = @"输入支付宝账号";
    [[_alipayAccountField rac_textSignal] subscribeNext:^(NSString *x) {
        _alipayAccountStr = x;
    }];
    
    _userNameField = [[UITextField alloc] init];
    _userNameField.placeholder = @"输入收款人姓名";
    [[_userNameField rac_textSignal] subscribeNext:^(NSString *x) {
        _nameOfApplierStr = x;
    }];
    
    
    _amountOfMoney = [[UITextField alloc] init];
    _amountOfMoney.placeholder = @"输入提现金额";
    _amountOfMoney.keyboardType = UIKeyboardTypeDecimalPad;
    [[_amountOfMoney rac_textSignal] subscribeNext:^(NSString *x) {
        _amountOfMoneyStr = x;
    }];
    
    _smsCodeField = [[UITextField alloc] init];
    _smsCodeField.placeholder = @"输入验证码";
    _smsCodeField.keyboardType = UIKeyboardTypeNumberPad;
    [[_smsCodeField rac_textSignal] subscribeNext:^(NSString *x) {
        _smsCodeStr = x;
    }];
    
    _requestSmsCodeBtn = [[KSButton alloc] init];
    _requestSmsCodeBtn.buttonColor = KS_Maintheme_Color2;
    [_requestSmsCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    UIView *line_1 = [[UIView alloc] init];
    line_1.backgroundColor = BASE_COLOR;
    
    UIView *line_2 = [[UIView alloc] init];
    line_2.backgroundColor = BASE_COLOR;
    
    UIView *line_3 = [[UIView alloc] init];
    line_3.backgroundColor = BASE_COLOR;
    
    UIView *line_4 = [[UIView alloc] init];
    line_4.backgroundColor = BASE_COLOR;
    
    [_scrollViewContainer addSubview:line_1];
    [_scrollViewContainer addSubview:line_2];
    [_scrollViewContainer addSubview:line_3];
    [_scrollViewContainer addSubview:line_4];
    [_scrollViewContainer addSubview:_alipayAccountField];
    [_scrollViewContainer addSubview:_userNameField];
    [_scrollViewContainer addSubview:_amountOfMoney];
    [_scrollViewContainer addSubview:_smsCodeField];
    [_scrollViewContainer addSubview:_requestSmsCodeBtn];
    
    [_alipayAccountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_scrollViewContainer.mas_left).with.offset(20);
        make.right.mas_equalTo(_scrollViewContainer.mas_right).with.offset(-20);
        make.top.mas_equalTo(_scrollViewContainer.mas_top).with.offset(10);
        make.height.mas_equalTo(45);
    }];
    [_userNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_scrollViewContainer.mas_left).with.offset(20);
        make.right.mas_equalTo(_scrollViewContainer.mas_right).with.offset(-20);
        make.top.mas_equalTo(_alipayAccountField.mas_bottom).with.offset(20);
        make.height.mas_equalTo(45);
    }];
    [_amountOfMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_scrollViewContainer.mas_left).with.offset(20);
        make.right.mas_equalTo(_scrollViewContainer.mas_right).with.offset(-20);
        make.top.mas_equalTo(_userNameField.mas_bottom).with.offset(20);
        make.height.mas_equalTo(45);
    }];
    
    [_smsCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_scrollViewContainer.mas_left).with.offset(20);
        make.right.mas_equalTo(_requestSmsCodeBtn.mas_left).with.offset(-10);
        make.top.mas_equalTo(_amountOfMoney.mas_bottom).with.offset(20);
        make.height.mas_equalTo(45);
    }];
    
    [_requestSmsCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(110);
        make.right.mas_equalTo(_scrollViewContainer.mas_right).with.offset(-20);
        make.centerY.mas_equalTo(_smsCodeField.mas_centerY);
        make.height.mas_equalTo(40);
    }];
    
    [line_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_alipayAccountField.mas_bottom).with.offset(0);
        make.left.mas_equalTo(_scrollViewContainer.mas_left).with.offset(20);
        make.right.mas_equalTo(_scrollViewContainer.mas_right).with.offset(-20);
        make.height.mas_equalTo(1);
    }];
    [line_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_userNameField.mas_bottom).with.offset(0);
        make.left.mas_equalTo(_scrollViewContainer.mas_left).with.offset(20);
        make.right.mas_equalTo(_scrollViewContainer.mas_right).with.offset(-20);
        make.height.mas_equalTo(1);
    }];
    [line_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_amountOfMoney.mas_bottom).with.offset(0);
        make.left.mas_equalTo(_scrollViewContainer.mas_left).with.offset(20);
        make.right.mas_equalTo(_scrollViewContainer.mas_right).with.offset(-20);
        make.height.mas_equalTo(1);
    }];
    [line_4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_smsCodeField.mas_bottom).with.offset(0);
        make.left.mas_equalTo(_scrollViewContainer.mas_left).with.offset(20);
        make.right.mas_equalTo(_scrollViewContainer.mas_right).with.offset(-20);
        make.height.mas_equalTo(1);
    }];
    
    
    [[_requestSmsCodeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSString *title = [NSString stringWithFormat:@"发送中"];
        [_requestSmsCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_requestSmsCodeBtn setEnabled:NO];
        [_requestSmsCodeBtn setTitle:title forState:UIControlStateNormal];
        
        [[KSClientApi requestSMSCode:[KSUser currentUser].mobilePhone withType:1] subscribeNext:^(id x) {
            __block int timeout = 60;
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(_time, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_time, ^{
                if (timeout <= 0) { //倒计时结束，关闭
                    dispatch_source_cancel(_time);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_requestSmsCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                        [_requestSmsCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        _requestSmsCodeBtn.enabled = YES;
                    });
                } else {
                    //int seconds = timeout % 60;
                    int seconds = timeout;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:1];
                        [_requestSmsCodeBtn setTitle:[NSString stringWithFormat:@"%@s剩余", strTime] forState:UIControlStateNormal];
                        [UIView commitAnimations];
                        _requestSmsCodeBtn.enabled = NO;
                    });
                    timeout--;
                }
            });
            dispatch_resume(_time);
            
        }                                                                                 error:^(NSError *error) {
            KSError([error.userInfo objectForKey:@"tips"]);
            NSString *title = [NSString stringWithFormat:@"重新获取"];
            [_requestSmsCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_requestSmsCodeBtn setEnabled:YES];
            [_requestSmsCodeBtn setTitle:title forState:UIControlStateNormal];
        }];
        
    }];
}

/**
 *  初始化提现界面底部的视图
 */
- (void)initBottom {
    //底部区域
    _bottomView = [[UIView alloc] init];
    [_scrollViewContainer addSubview:_bottomView];
    _bottomView.backgroundColor = [KSUtil colorWithHexString:@"#EFEFEF"];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_smsCodeField.mas_bottom).with.offset(30);
        make.bottom.mas_equalTo(_scrollViewContainer.mas_bottom);
        make.left.mas_equalTo(_scrollViewContainer.mas_left);
        make.right.mas_equalTo(_scrollViewContainer.mas_right);
    }];
    _bottomTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 45)];
    _bottomTitleLabel.text = @"收款人手持身份证照片";
    [_bottomView addSubview:_bottomTitleLabel];
    
    //上传图片的按钮
    UIButton *uploadPicButton = [[UIButton alloc] init];
    [uploadPicButton setImage:[UIImage imageNamed:@"icon_add_pic"] forState:UIControlStateNormal];
    [_bottomView addSubview:uploadPicButton];
    [uploadPicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bottomView.mas_centerX);
        make.top.mas_equalTo(_bottomTitleLabel.mas_bottom).with.offset(20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    [[uploadPicButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //设置选择后的图片可被编辑
        picker.allowsEditing = NO;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    
    
    //示例图片的按钮
    UIButton *examplePicButton = [[UIButton alloc] init];
    [examplePicButton setTitle:@"点击查看示例图片" forState:UIControlStateNormal];
    [examplePicButton setTitleColor:KS_Maintheme_Color2 forState:UIControlStateNormal];
    examplePicButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_bottomView addSubview:examplePicButton];
    [examplePicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(uploadPicButton.mas_bottom).with.offset(10);
        make.centerX.mas_equalTo(_bottomView.mas_centerX);
        make.left.mas_equalTo(_bottomView.mas_left).with.offset(20);
        make.right.mas_equalTo(_bottomView.mas_right).with.offset(-20);
    }];
    [[examplePicButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self initAlertView];
    }];
    
    //所选中的图片按钮
    _selectPhoto = [[UIView alloc] init];
    [_bottomView addSubview:_selectPhoto];
    _selectPhoto.backgroundColor = [UIColor whiteColor];
    [_selectPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bottomView.mas_centerX);
        make.top.mas_equalTo(_bottomTitleLabel.mas_bottom).with.offset(20);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(90);
    }];
    _selectPhoto.hidden = YES;
    
    //文字介绍的Label
    UILabel *introductionLabel = [[UILabel alloc] init];
    introductionLabel.text = @"提现说明：提现现金超过1万元时，我们会就提现事宜与您进行电话确认沟通，请保持您的联系电话畅通。提现申请确认完毕后，我们会在1-3个工作日内给您进行提现。";
    introductionLabel.numberOfLines = 5;
    [_bottomView addSubview:introductionLabel];
    introductionLabel.font = [UIFont systemFontOfSize:12];
    [introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_selectPhoto.mas_bottom).with.offset(20);
        make.centerX.mas_equalTo(_bottomView.mas_centerX);
        make.left.mas_equalTo(_bottomView.mas_left).with.offset(20);
        make.right.mas_equalTo(_bottomView.mas_right).with.offset(-20);
    }];
}

#pragma mark 相册图片选择完毕回来之后的代理方法

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    [picker dismissViewControllerAnimated:true completion:nil];
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    if (imageURL != nil) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        _imagePath = [imageURL absoluteString];
        [self showSelectImage:image inView:_selectPhoto];
    }
}

/**
 *  初始化ScrollView
 */
- (void)initScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.bounces = NO;
    _scrollViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 400)];
    
    [_scrollView addSubview:_scrollViewContainer];
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64);
}

/**
 *  初始化有可提现余额时所呈现的界面
 */
- (void)initDrawCashView {
    [self initForm];
    [self initBottom];
}


#pragma mark 显示所选择的图片

- (void)showSelectImage:(UIImage *)image inView:(UIView *)view {
    view.hidden = NO;
    while (view.subviews.firstObject) {
        [view.subviews.firstObject removeFromSuperview];
    }
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bottomView.mas_centerX);
        make.top.mas_equalTo(_bottomTitleLabel.mas_bottom).with.offset(20);
        make.width.mas_equalTo(SCREEN_WIDTH - 20);
        make.height.mas_equalTo(SCREEN_WIDTH - 20);
    }];
    UIImageView *selectImage = [[UIImageView alloc] init];
    [view addSubview:selectImage];
    selectImage.contentMode = UIViewContentModeScaleAspectFill;
    [selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).with.insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    selectImage.image = image;
    selectImage.clipsToBounds = YES;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 160);
    //关闭按钮
    UIButton *closedButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 25, 25)];
    [closedButton setImage:[UIImage imageNamed:@"cross_gray"] forState:UIControlStateNormal];
    @weakify(self);
    [[closedButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self hideSelectImage:view];
    }];
    [view addSubview:closedButton];
}

#pragma mark 删除所选择的图片

- (void)hideSelectImage:(UIView *)view {
    while (view.subviews.firstObject) {
        [view.subviews.firstObject removeFromSuperview];
    }
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bottomView.mas_centerX);
        make.top.mas_equalTo(_bottomTitleLabel.mas_bottom).with.offset(20);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(90);
    }];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    view.hidden = YES;
    _imagePath = nil;
}

- (void)showSuccessTips {
    self.navigationItem.rightBarButtonItem = nil;
    _scrollView.hidden = YES;
    UIView *tipsView = [[UIView alloc] init];
    [self.view addSubview:tipsView];
    @weakify(self);
    [tipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(self.view.mas_top).with.offset(150);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    UIImageView *correctImageView = [[UIImageView alloc] init];
    correctImageView.image = [UIImage imageNamed:@"icon_success"];
    [tipsView addSubview:correctImageView];
    [correctImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(tipsView.mas_centerY);
        make.left.mas_equalTo(tipsView.mas_left);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"提现成功";
    titleLabel.textColor = BASE_COLOR;
    titleLabel.font = [UIFont systemFontOfSize:27];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [tipsView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(correctImageView.mas_left).with.offset(36);
        make.centerY.mas_equalTo(tipsView.mas_centerY);
    }];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.font = [UIFont systemFontOfSize:14];
    tipsLabel.textColor = [UIColor grayColor];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(tipsView.mas_bottom).with.offset(50);
    }];
    tipsLabel.text = @"我们会尽快将款项转交给您，或尽快与您联系";
    
    UIButton *tipsButton = [[UIButton alloc] init];
    tipsButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [tipsButton setTitle:@"如有其它问题请点击此处" forState:UIControlStateNormal];
    [tipsButton setTitleColor:KS_Maintheme_Color2 forState:UIControlStateNormal];
    [self.view addSubview:tipsButton];
    [tipsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(tipsLabel.mas_bottom).with.offset(50);
    }];
    [[tipsButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        KSAboutUsViewController *aboutUs = [[KSAboutUsViewController alloc] init];
        [self.navigationController pushViewController:aboutUs animated:YES];
        [self removeFromParentViewController];
    }];
}

- (void)initAlertView {
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 280)];
    UIImageView *demoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 280)];
    demoImageView.image = [UIImage imageNamed:@"fanli.jpg"];
    [customView addSubview:demoImageView];
    [alertView setContainerView:customView];
    [alertView setButtonColors:[NSMutableArray arrayWithObjects:[UIColor blackColor], KS_Maintheme_Color, nil]];
    [alertView show];
}

- (void)initTitleBar {
    self.navigationItem.backBarButtonItem.title = @"";
    //下一步按钮
    UILabel *rightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    rightTitleLabel.backgroundColor = [UIColor clearColor];
    rightTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    rightTitleLabel.textColor = [UIColor whiteColor];
    rightTitleLabel.text = @"提交";
    rightTitleLabel.textAlignment = NSTextAlignmentRight;
    UIButton *rightTitleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [rightTitleButton addSubview:rightTitleLabel];
    [rightTitleButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightTitleButton];
    //设置NavigationBar的相关属性
    // self.navigationItem.leftBarButtonItem=leftBarButtonItem;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)nextStep {
    if (!_alipayAccountStr || _alipayAccountStr.length == 0) {
        KSError(@"支付宝账号不能为空！");
        return;
    }
    if (!_nameOfApplierStr || _nameOfApplierStr.length == 0) {
        KSError(@"收款人姓名不能为空！");
        return;
    }
    if (!_amountOfMoneyStr || _amountOfMoneyStr.length == 0) {
        KSError(@"提款金额不能为空！");
        return;
    }
    if (![_amountOfMoneyStr floatValue] > [self.viewModel.moneyinfo.applicant floatValue]) {
        KSError(@"提款金额超出可申请提款金额的最大限制！");
        return;
    }
    if (!_imagePath || _imagePath.length == 0) {
        KSError(@"请上传收款人手持身份证照片！");
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].labelText = @"正在提交提现申请";
    ImageUploader *imageUploader = [[ImageUploader alloc] init];
    imageUploader.action = 4;
    imageUploader.imagePath = _imagePath;
    [imageUploader beginUploadImageWithSuccessBlock:^(NSString *url) {
        [[KSClientApi drawCash:_alipayAccountStr andName:_nameOfApplierStr andMoney:[_amountOfMoneyStr floatValue] andCode:_smsCodeStr andPic:url]
         subscribeNext:^(id x) {
             [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
             [self showSuccessTips];
         }
         error:^(NSError *error) {
             KSError([error.userInfo objectForKey:@"tips"]);
             [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
         }];
        
    }                               andFailureBlock:^{
        
    }];
}

@end
