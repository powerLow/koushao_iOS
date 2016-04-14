//
//  KSActivityAdminListViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/18.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityAdminListViewController.h"
#import "KSActivityAdminListViewModel.h"
#import "KSActivityAdminItemCell.h"
#import "Masonry.h"
@interface KSActivityAdminListViewController ()<SWTableViewCellDelegate>

@property (nonatomic,strong) KSActivityAdminListViewModel *viewModel;

@end

@implementation KSActivityAdminListViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView registerClass:[KSActivityAdminItemCell class] forCellReuseIdentifier:@"KSActivityAdminItemCell"];
    self.tableView.mj_footer  = nil;
    @weakify(self)
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    
    [[[self.navigationController rac_signalForSelector:@selector(popViewControllerAnimated:)]
      takeUntil:self.rac_willDeallocSignal]
     subscribeNext:^(id x) {
         @strongify(self)
         NSLog(@"重新去请求刷新g管理员列表");
         [self.viewModel.requestRemoteDataCommand execute:@1];
     }];
}
#pragma mark - 
- (KSActivityAdminItemCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:@"KSActivityAdminItemCell" forIndexPath:indexPath];
}

- (void)configureCell:(KSActivityAdminItemCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    [cell bindViewModel:object];
    cell.delegate = self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel.dataSource[indexPath.section][indexPath.row] cellHeight];
}
//#pragma mark - edit
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    [tableView setEditing:YES animated:YES];
//    return UITableViewCellEditingStyleDelete;
//}
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView setEditing:NO animated:YES];
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"删除";
//}
#pragma mark - SWTableViewCellDelegate
// click event on right utility button
- (void)swipeableTableViewCell:(KSActivityAdminItemCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            NSLog(@"编辑被点击");
            [self.viewModel.didClickItemEditBtn execute:cell.viewModel];
            break;
        case 1:
        {
            NSLog(@"删除被点击");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定删除该账号" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber *x) {
                NSLog(@"x = %@",x);
                if ([x integerValue] == 1) {
                    NSLog(@"确定");
                    [self.viewModel.didClickItemDeleteBtn execute:cell.viewModel];
                }
                [cell hideUtilityButtonsAnimated:YES];
            }];
            [alert show];
        }
            break;
        default:
            break;
    }
}
// prevent multiple cells from showing utilty buttons simultaneously
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell{
    return YES;
}
// utility button open/close event
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state{
//    NSLog(@"scrollingToState = %ld",(long)state);
}
@end
