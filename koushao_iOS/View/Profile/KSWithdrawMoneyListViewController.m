//
//  KSWithdrawMoneyListViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSWithdrawMoneyListViewController.h"
#import "KSWithdrawMoneyListViewModel.h"
#import "KSWithdrawMoneyItemViewModel.h"
#import "Masonry.h"
#import "KSWithDrawCell.h"

@interface KSWithdrawMoneyListViewController ()

@property(nonatomic, strong, readwrite) KSWithdrawMoneyListViewModel *viewModel;
@end

@implementation KSWithdrawMoneyListViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self)
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.equalTo(self.view);
    }];

    [self.tableView registerClass:[KSWithDrawCell class] forCellReuseIdentifier:@"KSWithDrawCell"];
}

- (KSWithDrawCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KSWithDrawCell *cell = (KSWithDrawCell *) [self tableView:tableView dequeueReusableCellWithIdentifier:@"KSWithDrawCell" forIndexPath:indexPath];
    id object = self.viewModel.dataSource[indexPath.section][indexPath.row];
    [self configureCell:cell atIndexPath:indexPath withObject:(id) object];
    return cell;
}

- (void)configureCell:(KSWithDrawCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    [cell bindViewModel:object];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel.dataSource[indexPath.section][indexPath.row] cellHeight];
}
@end
