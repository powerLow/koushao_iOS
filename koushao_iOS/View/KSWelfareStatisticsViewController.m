//
//  KSWelfareStatisticsViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/27.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSWelfareStatisticsViewController.h"
#import "KSWelfareStatisticsViewModel.h"
#import "KSWelfareStatisticsCell.h"
#import "Masonry.h"
#import "KSWelfareAnalyseModel.h"
#import "KSWelfareStatisticsItemViewModel.h"

@interface KSWelfareStatisticsViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong, readwrite) UITableView *tableView;
@property(nonatomic, strong, readwrite) KSWelfareStatisticsViewModel *viewModel;

@end

@implementation KSWelfareStatisticsViewController
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

- (void)initTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = tableView;
    @weakify(self)
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
    }];
    [self.tableView registerClass:[KSWelfareStatisticsCell class] forCellReuseIdentifier:@"KSWelfareStatisticsCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [RACObserve(self.viewModel, model) subscribeNext:^(KSWelfareAnalyseModel *x) {
        if (x != nil) {
            NSLog(@"收到福利统计结果 = %@", x);
            [self.viewModel dataSourceWithModel:x];
            [self.tableView reloadData];
        }
    }];
    
    @weakify(self)
    [self.viewModel.requestRemoteDataCommand.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self)
        if (executing.boolValue) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = MBPROGRESSHUD_LABEL_TEXT;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

#pragma mark - UITableViewDelegate
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.viewModel.model == nil) {
        return 0;
    } else {
        return self.viewModel.model.detail_statistics.count + 1;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 38;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 38)];
    //模仿Group模式
    UIView *spView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    spView.backgroundColor = RGB(242, 242, 242);
    [headerView addSubview:spView];
    
    UILabel *title_label = [UILabel new];
    UILabel *right_label = [UILabel new];
    [headerView addSubview:right_label];
    [headerView addSubview:title_label];
    title_label.textColor = HexRGB(0x990000);
    right_label.textColor = BASE_COLOR;
    title_label.font = KS_FONT_18;
    right_label.font = KS_FONT_18;
    if (section == 0) {
        KSWelfareTotalStatistics *total = self.viewModel.model.total_statistics;
        title_label.text = @"总计";
        right_label.text = [NSString stringWithFormat:@"%@", total.total];
    } else {
        KSWelfareDetailStatistics *detail = self.viewModel.model.detail_statistics[section - 1];
        title_label.text = detail.name;
        right_label.text = [NSString stringWithFormat:@"%@", detail.total];
    }
    
    UILabel *unit_label = [UILabel new];
    unit_label.font = KS_FONT_18;
    unit_label.text = @"份";
    [headerView addSubview:unit_label];
    
    
    [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(10);
        make.centerY.equalTo(headerView).offset(4);
    }];
    [right_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(unit_label.mas_left).offset(-5);
        make.centerY.equalTo(headerView).offset(4);
    }];
    
    [unit_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-10);
        make.centerY.equalTo(headerView).offset(4);
    }];
    
    return headerView;
}
// 去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 30;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (KSWelfareStatisticsCell *)tableView:(KSWelfareStatisticsCell *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KSWelfareStatisticsCell *cell = [[KSWelfareStatisticsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    id object = self.viewModel.dataSource[indexPath.section][indexPath.row];
    [self configureCell:cell atIndexPath:indexPath withObject:(id) object];
    return cell;
}

- (KSWelfareStatisticsCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"KSWelfareStatisticsCell" forIndexPath:indexPath];
}

- (void)configureCell:(KSWelfareStatisticsCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    [cell bindViewModel:object];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [self.viewModel.dataSource[indexPath.section][indexPath.row] cellHeight];
    return 44;
}

@end
