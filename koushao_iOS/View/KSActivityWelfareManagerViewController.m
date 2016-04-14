//
//  KSActivityWelfareManagerViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/26.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityWelfareManagerViewController.h"
#import "KSActivityWelfareManagerViewModel.h"
#import "KSWelfareStopModel.h"
#import "KSWelfareStatusModel.h"
#import "Masonry.h"
#import "KSActivity.h"
@interface KSActivityWelfareManagerViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    BOOL rowIsSelectable;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) KSActivityWelfareManagerViewModel *viewModel;
@end

@implementation KSActivityWelfareManagerViewController
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    
    
    self.tableView = tableView;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    UIButton *stopBtn = [UIButton new];
    [stopBtn setHidden:YES];
    [self.view addSubview:stopBtn];
    
    
    KSActivity *curAct = [KSUtil getCurrentActivity];
    if (curAct.status == KSActivityStatusEnd) {
        rowIsSelectable = NO;
        NSString *title = [NSString stringWithFormat:@"福利已停止 : %@",[KSUtil StringTimeFromNumber:curAct.endTime withSeconds:NO]];
        stopBtn.layer.borderColor = [UIColor grayColor].CGColor;
        stopBtn.backgroundColor = [UIColor whiteColor];
        [stopBtn setTitle:title forState:UIControlStateNormal];
        //[stopBtn setTitle:title forState:UIControlStateDisabled];
        [stopBtn setTitleColor:KS_GrayColor4 forState:UIControlStateDisabled];
        [stopBtn setEnabled:NO];
        [stopBtn setHidden:NO];
    }else{
        [[KSClientApi getWelfareStatus] subscribeNext:^(KSWelfareStatusModel *model) {
            [stopBtn setHidden:NO];
            if ([model.status isEqual:@0]) {
                rowIsSelectable = NO;
                NSString *title = [NSString stringWithFormat:@"福利已停止 : %@",
                                   [KSUtil StringTimeFromNumber:model.endtime withSeconds:NO]];
                [stopBtn setTitle:title forState:UIControlStateNormal];
                [stopBtn setTitleColor:KS_GrayColor4 forState:UIControlStateDisabled];
                [stopBtn setEnabled:NO];
            }else{
                rowIsSelectable = YES;
                stopBtn.backgroundColor = [UIColor whiteColor];
                stopBtn.layer.borderColor = [UIColor grayColor].CGColor;
                [stopBtn setTitle:@"停止福利" forState:UIControlStateNormal];
                [stopBtn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
            }
        }];
    }
    
    
    
    
    @weakify(self)
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.bottom.equalTo(stopBtn.mas_top);
    }];
    
    
    [stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@49);
    }];
    
    [[stopBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你确定停止该福利吗?" message:@"福利停止后将不可再次启动" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber *x) {
            NSLog(@"x = %@",x);
            if ([x integerValue] == 1) {
                NSLog(@"确定");
                [[KSClientApi stopWelfare] subscribeNext:^(KSWelfareStopModel* model) {
                    rowIsSelectable = NO;
                    NSString *title = [NSString stringWithFormat:@"福利已停止 : %@",[KSUtil StringTimeFromNumber:model.endtime withSeconds:NO]];
                    [stopBtn setTitle:title forState:UIControlStateNormal];
                    [stopBtn setTitleColor:KS_GrayColor4 forState:UIControlStateDisabled];
                    [stopBtn setEnabled:NO];
                } error:^(NSError *error) {
                    [KSUtil filterError:error params:nil];
                }];
            }
        }];
        [alert show];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 2;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    //根据 NSIndexPath判定行是否可选。
//    if (rowIsSelectable)
//    {
//        return path;
//    }
//        return nil;
    return path;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WelfareManagerCell"];
    if (indexPath.section == 0) {
        NSArray *titles = @[@"扫码发放",@"验证码发放",@"实物奖品发放"];
        NSArray *imageNames= @[@"qrcode_icon",@"sms_icon",@"real_gift"];
        cell.textLabel.text = titles[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:imageNames[indexPath.row]];
    }else{
        NSArray *titles = @[@"发放记录",@"福利统计"];
        NSArray *imageNames= @[@"record_icon",@"welfare_record"];
        cell.textLabel.text = titles[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:imageNames[indexPath.row]];
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
                              self.viewModel.didClickRealGiftCommand];
        RACCommand *command = commands[indexPath.row];
        [command execute:@1];
    }else{
        NSArray *commands = @[self.viewModel.didClickWelfareRecordCommand,
                              self.viewModel.didClickWelfareStatisticsCommand];
        RACCommand *command = commands[indexPath.row];
        [command execute:@1];
    }
}
@end
