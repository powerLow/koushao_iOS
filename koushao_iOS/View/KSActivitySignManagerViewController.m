//
//  KSActivitySignManagerViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/26.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivitySignManagerViewController.h"
#import "KSActivitySignManagerViewModel.h"
//#import "Masonry.h"
@interface KSActivitySignManagerViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) KSActivitySignManagerViewModel *viewModel;

@end

@implementation KSActivitySignManagerViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    
    //    @weakify(self)
    //    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        @strongify(self)
    //        make.top.equalTo(self.mas_topLayoutGuideBottom);
    //        make.left.right.bottom.equalTo(self.view);
    //    }];
    
    self.tableView = tableView;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SignManagerCell"];
    if (indexPath.section == 0) {
        NSArray *titles = @[@"扫码签到",@"验证码签到",@"用户主动签到"];
        NSArray *imageNames= @[@"qrcode_icon",@"sms_icon",@"sign_up"];
        cell.textLabel.text = titles[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:imageNames[indexPath.row]];
    }else{
        cell.textLabel.text = @"签到记录";
        cell.imageView.image = [UIImage imageNamed:@"record_icon"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSArray *commands = @[self.viewModel.didClickQrcodeScanCommand,
                              self.viewModel.didClickSmsCodeCommand,
                              self.viewModel.didClickUserSignCommand];
        RACCommand *command = commands[indexPath.row];
        [command execute:@1];
    }else{
        [self.viewModel.didClickSignRecordCommand execute:@1];
    }
}

@end
