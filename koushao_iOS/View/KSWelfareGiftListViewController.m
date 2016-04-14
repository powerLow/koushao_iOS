//
//  KSWelfareGiftListViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/16.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSWelfareGiftListViewController.h"
#import "KSActivityWelfareGiftListViewModel.h"
#import "Masonry.h"
#import "KSAwardItemViewModel.h"
#import "KSAwardItemCell.h"
@interface KSWelfareGiftListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong,readwrite) KSActivityWelfareGiftListViewModel *viewModel;
@end

@implementation KSWelfareGiftListViewController
@dynamic viewModel;
- (instancetype)initWithViewModel:(id<KSViewModelProtocol>)viewModel {
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
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)setupView
{
    [self.tableView registerClass:[KSAwardItemCell class] forCellReuseIdentifier:@"KSAwardItemCell"];
    self.tableView.backgroundColor = KS_GrayColor_BackColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"未发放",@"已发放",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedData];
    segmentedControl.tintColor = [UIColor whiteColor];
    segmentedControl.selectedSegmentIndex = 0;//默认选中的按钮索引
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [[segmentedControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISegmentedControl *Seg) {
        //切换
        NSLog(@"切换 = %ld",(long)Seg.selectedSegmentIndex);
        NSInteger Index = Seg.selectedSegmentIndex;
        [self.viewModel.didSwitchTypeCommand execute:@(Index)];
    }];
    NSInteger height = 40;
    @weakify(self)
    UIView* topBackgroundView = [[UIView alloc] init];
    [self.view addSubview:topBackgroundView];
    topBackgroundView.backgroundColor = BASE_COLOR;
    [topBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(height);
    }];
    
    [topBackgroundView addSubview:segmentedControl];
    
    [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(height * 0.15);
        make.height.equalTo(topBackgroundView).multipliedBy(0.7);
        make.left.equalTo(topBackgroundView).offset(25);
        make.right.equalTo(topBackgroundView).offset(-25);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(topBackgroundView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewModel.didSelectCommand execute:indexPath];
}

#pragma mark -  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel.dataSource[section] count];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,20)];
    titleView.backgroundColor = KS_GrayColor_BackColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.frame.size.width, 20)];
    label.text = self.viewModel.sectionIndexTitles[section];
    label.font = KS_SMALL_FONT;
    label.textColor = KS_GrayColor4;
    [titleView addSubview:label];
    return titleView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KSAwardItemCell" forIndexPath:indexPath];
    id object = self.viewModel.dataSource[indexPath.section][indexPath.row];
    [self configureCell:cell atIndexPath:indexPath withObject:(id)object];
    return cell;
}
- (void)configureCell:(KSAwardItemCell*)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    [cell bindViewModel:object];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellHeight = %@,%lf",indexPath,[self.viewModel.dataSource[indexPath.section][indexPath.row] cellHeight]);
    return [self.viewModel.dataSource[indexPath.section][indexPath.row] cellHeight];
}

@end
