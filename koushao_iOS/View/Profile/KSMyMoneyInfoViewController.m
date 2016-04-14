//
//  KSMyMoneyInfoViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/22.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSMyMoneyInfoViewController.h"
#import "KSMyMoneyInfoTableViewCell.h"
#import "KSMyMoneyInfoViewModel.h"
#import "KSButton.h"
#import "Masonry.h"

@interface KSMyMoneyInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong, readwrite) KSMyMoneyInfoViewModel *viewModel;
@property(nonatomic, strong) UITableView *tableView;
//@property (strong, nonatomic,readonly) IBOutlet UITableView *tableView;

@end

@implementation KSMyMoneyInfoViewController
@dynamic viewModel;

- (instancetype)initWithViewModel:(id <KSViewModelProtocol>)viewModel {
    self = [super initWithViewModel:viewModel];
    if (self) {
        if ([viewModel shouldRequestRemoteDataOnViewDidLoad]) {
            @weakify(self)
            [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
                @strongify(self)
                [self.viewModel.requestRemoteDataCommand execute:@1];
            }];
        }

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.sectionIndexColor = [UIColor darkGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexMinimumDisplayRowCount = 20;
    self.tableView.tableFooterView = [[UIView alloc] init];

    [self.tableView registerClass:[KSMyMoneyInfoTableViewCell class] forCellReuseIdentifier:@"KSMyMoneyInfoTableViewCell"];

    @weakify(self)
    [[self.viewModel.requestRemoteDataCommand.executing take:3] subscribeNext:^(NSNumber *executing) {
        //只出现一次加载
        @strongify(self)
        if (executing.boolValue) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = MBPROGRESSHUD_LABEL_TEXT;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];

    RAC(self.viewModel, dataSource) = [[RACObserve(self.viewModel, datas)
            map:^(NSArray *datas) {
                @strongify(self)
                return [self.viewModel dataSourceWithDatas:datas];
            }]
            map:^id(NSArray *viewModels) {
                return viewModels;
            }];
    [RACObserve(self.viewModel, datas) subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];

    [[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.requestRemoteDataCommand execute:@1];
    }];

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KSMyMoneyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KSMyMoneyInfoTableViewCell" forIndexPath:indexPath];
    id object = self.viewModel.dataSource[indexPath.section][indexPath.row];
    [self configureCell:cell atIndexPath:indexPath withObject:(id) object];
    return cell;
}

- (void)configureCell:(KSMyMoneyInfoTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(KSMyMoneyInfoViewModel *)viewModel {
    [cell bindViewModel:viewModel];
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return SCREEN_HEIGHT / 2.5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = @"";
    if (section == 0) {
        title = @"活动金额数据";
    }
    return title;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGRect frame = tableView.frame;
    frame.size.height = 30;
    UIView *footerView = [[UIView alloc] initWithFrame:tableView.frame];
    KSButton *btn = [[KSButton alloc] init];
    [btn setTitle:@"提现" forState:UIControlStateNormal];
    [footerView addSubview:btn];

    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(footerView);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];

    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"申请提现被点击");
        [self.viewModel.didDrawMoneyBtnClick execute:nil];
    }];

    [self.view addSubview:footerView];
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < 2) {
        [self.viewModel.didSelectCommand execute:indexPath];
    }

}
@end
