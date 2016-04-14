//
//  KSSetNicknameViewController.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/12/1.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSSetNicknameViewController.h"
#import "UITextField+maxLength.h"

@interface KSSetNicknameViewController ()

@property(nonatomic, strong, readwrite) UITableView *tableView;
@property(nonatomic, copy) NSString *nickname;
@property(nonatomic, strong) UITextField *nicknameTextField;

@end

@implementation KSSetNicknameViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTitleBar];
    self.title = @"设置昵称";
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];

    self.nicknameTextField = [[UITextField alloc] initWithFrame:CGRectMake(78, 3, [[UIScreen mainScreen] bounds].size.width - 30, 40)];
    self.nicknameTextField.placeholder = @"请输入昵称";
    [self.nicknameTextField setMaxTextLength:20]; //活动名称最多30个字
    self.nicknameTextField.text = [KSUser currentUser].nickname;
    _nickname = [KSUser currentUser].nickname;
    @weakify(self);
    [[self.nicknameTextField rac_textSignal] subscribeNext:^(NSString *x) {
        @strongify(self)
        self.nickname = x;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = @"昵称";
    [cell addSubview:self.nicknameTextField];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)initTitleBar {
    self.navigationItem.backBarButtonItem.title = @"";
    //下一步按钮
    UILabel *rightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    rightTitleLabel.backgroundColor = [UIColor clearColor];
    rightTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    rightTitleLabel.textColor = [UIColor whiteColor];
    rightTitleLabel.text = @"确认";
    rightTitleLabel.textAlignment = NSTextAlignmentRight;
    UIButton *rightTitleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [rightTitleButton addSubview:rightTitleLabel];
    [rightTitleButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightTitleButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)nextStep {
    if (!self.nickname || self.nickname.length == 0) {
        KSError(@"用户昵称不可为空！");
        return;
    }
    KSUser *user = [KSUser currentUser];
    user.nickname = self.nickname;
    @weakify(self);
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].labelText = @"昵称设置中";
    [[KSClientApi setUserProfile:user.nickname andGender:[user.gender integerValue]] subscribeNext:^(id x) {
        @strongify(self)
        [user ks_saveOrUpdate];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }                                                                                        error:^(NSError *error) {
        KSError([error.userInfo objectForKey:@"tips"]);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];

}


@end
