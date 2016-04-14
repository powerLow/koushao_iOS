//
//  KSActivityAdminManagerViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/26.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityAdminManagerViewController.h"
#import "Masonry.h"
#import "BEMCheckBox.h"
#import "KSActivityAdminManagerViewModel.h"
@interface KSActivityAdminManagerViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UIBarButtonItem *rightBtn;

@property (nonatomic,strong,readwrite) KSActivityAdminManagerViewModel *viewModel;
@property (nonatomic,strong) UITextField *usernameField;
@property (nonatomic,strong) UITextField *passwordField;

@end

static NSString *bottom_line = @"bottom_line";

@implementation KSActivityAdminManagerViewController
@dynamic viewModel;

- (void)initNav {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirm:)];
    self.navigationItem.rightBarButtonItem = item;
    self.rightBtn = item;
}
- (void)confirm:(UIBarButtonItem*)item {
    BEMCheckBox *box1 = (BEMCheckBox *)[self.view viewWithTag:2001];
    BEMCheckBox *box2 = (BEMCheckBox *)[self.view viewWithTag:2002];
    BEMCheckBox *box3 = (BEMCheckBox *)[self.view viewWithTag:2003];
    
    NSLog(@" %d,%d,%d",box1.on,box2.on,box3.on);
    
    [self.view endEditing:YES];
    
    
    if (self.viewModel.item == nil) {
        [self.viewModel.didClickAddBtn execute:RACTuplePack_(_usernameField.text,_passwordField.text,@(box1.on),@(box2.on),@(box3.on))];
    }else{
        [self.viewModel.didClickEditBtn execute:RACTuplePack_(self.viewModel.item.itemModel.nickname,_passwordField.text,@(box1.on),@(box2.on),@(box3.on))];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    
    @weakify(self)
    [self.viewModel.didClickAddBtn.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self)
        self.rightBtn.enabled = !executing.boolValue;
        if (executing.boolValue) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = @"添加中..";
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
    
    
    UIFont *text_font = KS_FONT_16;
    NSInteger top_margin = SCREEN_HEIGHT / 25;
    NSInteger left_margin = SCREEN_WIDTH / 12;
    NSInteger height = SCREEN_HEIGHT / 28;
    
    //登陆账号
    UILabel *account_label = [UILabel new];
    [self.view addSubview:account_label];
    account_label.text  = @"登陆账号";
    account_label.font = text_font;
    
    [account_label mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(top_margin);
        make.left.equalTo(self.view).offset(left_margin);
    }];
    
    
    UIView *view = nil;
    if (self.viewModel.item == nil) {
        UITextField *account_field = [UITextField new];
        [self.view addSubview:account_field];
        account_field.placeholder = @"填写账号";
        
        UIView *account_field_bottom_line = [UIView new];
        [self.view addSubview:account_field_bottom_line];
        account_field_bottom_line.backgroundColor = KS_GrayColor;
        account_field.keyboardType = UIKeyboardTypeASCIICapable;
        account_field.delegate = self;
        
        [account_field mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.top.equalTo(account_label.mas_bottom).offset(8);
            make.left.equalTo(account_label);
            make.width.equalTo(self.view).multipliedBy(0.5);
            make.height.mas_equalTo(height);
        }];
        
        [account_field_bottom_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@2);
            make.left.right.equalTo(account_field);
            make.bottom.equalTo(account_field).offset(3);
        }];
        
        [[account_field rac_signalForControlEvents:UIControlEventEditingDidBegin] subscribeNext:^(id x) {
            account_field_bottom_line.backgroundColor = BASE_COLOR;
        }];
        [[account_field rac_signalForControlEvents:UIControlEventEditingDidEnd] subscribeNext:^(id x) {
            account_field_bottom_line.backgroundColor = KS_GrayColor;
        }];
        
        _usernameField = account_field;
        
        view = account_field;
    }else{
        UILabel *username_label = [UILabel new];
        username_label.text = self.viewModel.item.itemModel.nickname;
        username_label.font = text_font;
        username_label.textColor = BASE_COLOR;
        [self.view addSubview:username_label];
        [username_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(account_label.mas_bottom).offset(8);
            make.left.equalTo(account_label);
            make.height.mas_equalTo(height);
        }];
        view = username_label;
    }
    
    
    
    UILabel *main_label = [UILabel new];
    main_label.text = [NSString stringWithFormat:@"@%@",[KSUser currentUser].mobilePhone];
    main_label.font = text_font;
    [self.view addSubview:main_label];
    
    [main_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(view);
        make.left.equalTo(view.mas_right);
    }];
    
    //密码
    UILabel *pwd_label = [UILabel new];
    [self.view addSubview:pwd_label];
    pwd_label.text = @"密码";
    pwd_label.font = text_font;
    
    [pwd_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(account_label);
        make.top.equalTo(view.mas_bottom).offset(top_margin);
    }];
    
    UITextField *pwd_field = [UITextField new];
    pwd_field.secureTextEntry = YES;
    [self.view addSubview:pwd_field];
    pwd_field.placeholder = @"填写密码";
    
    [pwd_field mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.equalTo(pwd_label);
        make.top.equalTo(pwd_label.mas_bottom).offset(8);
        make.width.equalTo(self.view).multipliedBy(0.75);
    }];
    
    UIView *pwd_field_bottom_line = [UIView new];
    pwd_field_bottom_line.backgroundColor = KS_GrayColor;
    [self.view addSubview:pwd_field_bottom_line];
    
    [pwd_field_bottom_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(pwd_field);
        make.bottom.equalTo(pwd_field).offset(3);
        make.height.equalTo(@2);
    }];

    
    
    [[pwd_field rac_signalForControlEvents:UIControlEventEditingDidBegin] subscribeNext:^(id x) {
        pwd_field_bottom_line.backgroundColor = BASE_COLOR;
    }];
    [[pwd_field rac_signalForControlEvents:UIControlEventEditingDidEnd] subscribeNext:^(id x) {
        pwd_field_bottom_line.backgroundColor = KS_GrayColor;
    }];
    
    if (self.viewModel.item != nil){
        pwd_field.placeholder = @"**********";
    }
    
    _passwordField = pwd_field;
    //分割条
    UIView *sp  = [UIView new];
    [self.view addSubview:sp];
    sp.backgroundColor = KS_GrayColor;
    [sp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwd_field_bottom_line.mas_bottom).offset(top_margin);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    
    //权限选择
    
    UILabel *access_label = [UILabel new];
    [self.view addSubview:access_label];
    access_label.text = @"权限";
    access_label.font = text_font;
    [access_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(account_label);
        make.top.equalTo(sp.mas_bottom).offset(top_margin);
    }];
    
    NSArray *texts = @[@"签到管理",@"咨询回复",@"福利发放"];
    UIView *lastView = nil;
    for (int i = 0; i<texts.count; ++i) {
        BEMCheckBox *checkBox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        checkBox.tag = 2001+i;
        checkBox.onAnimationType = BEMAnimationTypeFill;
        checkBox.offAnimationType = BEMAnimationTypeFill;
        checkBox.tintColor = BASE_COLOR;
        checkBox.onCheckColor = BASE_COLOR;
        checkBox.onTintColor = BASE_COLOR;
        checkBox.boxType = BEMBoxTypeSquare;
        
        [self.view addSubview:checkBox];
        
        UILabel *textLabel = [UILabel new];
        [self.view addSubview:textLabel];
        textLabel.font = text_font;
        textLabel.text = texts[i];
        
        if (lastView == nil) {
            [checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(access_label.mas_bottom).offset(top_margin);
            }];
        }else{
            [checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).offset(top_margin);
            }];
        }
        [checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(account_label);
            make.height.width.mas_equalTo(height);
        }];
        
        
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(checkBox);
            make.left.equalTo(checkBox.mas_right).offset(10);
        }];
        
        lastView = checkBox;
    }
    //查看已添加账号
    UIButton *button = [UIButton new];
    [self.view addSubview:button];
    [button setTitle:@"查看已添加账号" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.bottom.equalTo(self.view).offset(-top_margin);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(height);
        make.width.equalTo(self.view).multipliedBy(0.4);
    }];
    
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"查看已添加账号");
        [self.viewModel.didClickLookBtn execute:@1];
    }];
    
    
    //右上角确定按钮是否启用
    BEMCheckBox *box1 = (BEMCheckBox *)[self.view viewWithTag:2001];
    BEMCheckBox *box2 = (BEMCheckBox *)[self.view viewWithTag:2002];
    BEMCheckBox *box3 = (BEMCheckBox *)[self.view viewWithTag:2003];
    if (self.viewModel.item == nil) {
        //添加管理员
        RAC(self.rightBtn,enabled) = [RACSignal
                                      combineLatest:@[_usernameField.rac_textSignal,
                                                      _passwordField.rac_textSignal,
                                                      box1.rac_StatueChangeSignal,
                                                      box2.rac_StatueChangeSignal,
                                                      box3.rac_StatueChangeSignal,
                                                      ]
                                      reduce:^(NSString *account, NSString *pwd,NSNumber *signin,NSNumber *question,NSNumber *welfare){
                                          
                                          
                                          return @(account.length > 0 && pwd.length > 4
                                          && ([signin boolValue]
                                              || [question boolValue]
                                              || [welfare boolValue]));
                                      }];
        [RACObserve(self.viewModel, resultModel) subscribeNext:^(KSAddSubAccountResultModel *x) {
            NSLog(@"resultModel = %@",x.username);
            if (x != nil) {
                KSSuccess(@"添加成功");
                _usernameField.text = @"";
                _passwordField.text = @"";
                box1.on = NO;
                box2.on = NO;
                box3.on = NO;
            }
        }];
    }else{
        //修改管理员
        button.hidden = YES;
        box1.on = [self.viewModel.item.itemModel.attr.signin boolValue];
        box2.on = [self.viewModel.item.itemModel.attr.question boolValue];
        box3.on = [self.viewModel.item.itemModel.attr.welfare boolValue];
        [box1 reload];
        [box2 reload];
        [box3 reload];
        RAC(self.rightBtn,enabled) = [RACSignal
                                      combineLatest:@[
//                                                      _passwordField.rac_textSignal,
                                                      box1.rac_StatueChangeSignal,
                                                      box2.rac_StatueChangeSignal,
                                                      box3.rac_StatueChangeSignal,
                                                      ]
                                      reduce:^(/*NSString *pwd,*/NSNumber *signin,NSNumber *question,NSNumber *welfare){
                                          return @(
                                          //pwd.length > 4 &&
                                          ([signin boolValue]
                                              || [question boolValue]
                                              || [welfare boolValue]));
                                          }];
    }
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // 此处判断点击的是否是删除按钮,当输入键盘类型为number pad(数字键盘时)准确,其他类型未可知
    if (![string isEqualToString:@""]) {
        //过滤长度大于1的输入
        if (![string length] == 1) {
            return NO;
        }
        //过滤非字母数字
        int a = [string characterAtIndex:0];
        if (!isalnum(a)) {
            
            return NO;
        }
    }
    return YES;
}
@end
