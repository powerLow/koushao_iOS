//
//  KSMyDataViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/15.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSMyDataViewController.h"
#import "KSMyDataViewModel.h"
#import "KSMyDataTableViewCell.h"

@interface KSMyDataViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong, readwrite) KSMyDataViewModel *viewModel;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation KSMyDataViewController
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
    [self.tableView registerNib:[UINib nibWithNibName:@"KSMyDataTableViewCell" bundle:nil] forCellReuseIdentifier:@"KSMyDataTableViewCell"];

    @weakify(self)
    [self.viewModel.requestRemoteDataCommand.executing subscribeNext:^(NSNumber *executing) {
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

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (void)configureCell:(KSMyDataTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(KSMyDataViewModel *)viewModel {
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell bindViewModel:viewModel];
}

#pragma mark -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KSMyDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KSMyDataTableViewCell" forIndexPath:indexPath];
    id object = self.viewModel.dataSource[indexPath.section][indexPath.row];
    [self configureCell:cell atIndexPath:indexPath withObject:(id) object];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = @"";
    if (section == 0) {
        title = @"活动总数据";
    }
    return title;
}
@end
