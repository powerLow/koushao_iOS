//
//  KSActivityListViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/14.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityListViewController.h"
#import "KSActivityListViewModel.h"
#import "KSActivityListItemViewModel.h"
#import "KSActivityItemTableViewCell.h"
#import "Masonry.h"
@interface KSActivityListViewController ()

@property(nonatomic, strong, readwrite) KSActivityListViewModel *viewModel;


@end

@implementation KSActivityListViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KSActivityItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"KSActivityItemViewCell"];
    
    @weakify(self)
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (self.viewModel.dataSource.count > 0) {
        [self.tableView reloadData];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshMainList)
                                                 name:REFRESH_ACTIVITY_LIST
                                               object:nil];
}

- (void)refreshMainList {
    [self.viewModel.requestRemoteDataCommand execute:@1];
}

- (UIEdgeInsets)contentInset {
    return UIEdgeInsetsMake(0, 0, 49, 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"KSActivityItemViewCell" forIndexPath:indexPath];
}

- (void)configureCell:(KSActivityItemTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(KSActivityListItemViewModel *)viewModel {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell bindViewModel:viewModel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel.dataSource[indexPath.section][indexPath.row] cellHeight];
}
@end
