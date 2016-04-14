//
//  KSSetGenderViewController.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/12/1.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSSetGenderViewController.h"
#import "KSClientApi.h"

@interface KSSetGenderViewController ()

@property(nonatomic, strong, readwrite) UITableView *tableView;

@end

@implementation KSSetGenderViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择性别";
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"男";
    }
    else {
        cell.textLabel.text = @"女";
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self)

    KSUser *user = [KSUser currentUser];
    user.gender = [NSNumber numberWithInteger:indexPath.row];

    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].labelText = @"性别设置中";
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
