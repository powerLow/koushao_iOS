//
//  KSEnrollRecordViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSEnrollRecordViewController.h"
#import "KSEnrollRecordViewModel.h"
#import "KSEnrollRecordItemViewModel.h"
#import "KSEnrollRecordViewCell.h"
#import "Masonry.h"
@interface KSEnrollRecordViewController()

@property (strong, nonatomic,readwrite) KSEnrollRecordViewModel *viewModel;

@end

@implementation KSEnrollRecordViewController

@dynamic viewModel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableView registerClass:[KSEnrollRecordViewCell class] forCellReuseIdentifier:@"KSEnrollRecordViewCell"];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [self.view addSubview:headerView];
    //headerView.backgroundColor = HexRGB(BASE_COLOR);
    
    UILabel *label = [UILabel new];
    label.text = @"总计报名人数: 0人";
    label.textColor = HexRGB(0x969696);
    label.font = KS_SMALL_FONT;
    [headerView addSubview:label];
    
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@8);
    }];
    
    UIView *sp = [UIView new];
    sp.backgroundColor = HexRGB(0x969696);
    [headerView addSubview:sp];
    [sp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerView);
        make.bottom.equalTo(headerView);
        make.height.equalTo(@1);
    }];
    
    @weakify(self)
    
    self.tableView.tableHeaderView = headerView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self)
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [RACObserve(self.viewModel, items) subscribeNext:^(NSArray *tickets) {
        @strongify(self)
        if (self.viewModel.isEnroll) {
            label.text = [NSString stringWithFormat:@"总计报名人数: %lu人",(unsigned long)tickets.count];
        }else{
            label.text = [NSString stringWithFormat:@"总计售票数量: %lu张",(unsigned long)tickets.count];
        }
        
    }];
    
}

- (UIEdgeInsets)contentInset {
    return UIEdgeInsetsMake(64, 0, 0, 0);
}

- (KSEnrollRecordViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:@"KSEnrollRecordViewCell" forIndexPath:indexPath];
}

- (void)configureCell:(KSEnrollRecordViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    [cell bindViewModel:object];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel.dataSource[indexPath.section][indexPath.row] cellHeight];
}

@end
