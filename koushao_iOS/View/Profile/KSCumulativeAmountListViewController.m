//
//  KSCumulativeAmountListViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSCumulativeAmountListViewController.h"
#import "KSCumulativeAmountListViewModel.h"
#import "KSCumulativeAmountItemViewModel.h"
#import "Masonry.h"
#import "KSCumulativeAmountCell.h"

@interface KSCumulativeAmountListViewController ()

@property(nonatomic, strong, readwrite) KSCumulativeAmountListViewModel *viewModel;

@end

@implementation KSCumulativeAmountListViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self)
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self.tableView registerClass:[KSCumulativeAmountCell class] forCellReuseIdentifier:@"KSCumulativeAmountCell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KSCumulativeAmountCell" forIndexPath:indexPath];
    id object = self.viewModel.dataSource[indexPath.section][indexPath.row];
    [self configureCell:cell atIndexPath:indexPath withObject:(id) object];
    return cell;
}

- (void)configureCell:(KSCumulativeAmountCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    [cell bindViewModel:object];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [self.viewModel.dataSource[indexPath.section][indexPath.row] cellHeight];
    return 75;
}
@end
