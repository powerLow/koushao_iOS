//
//  KSActivitySignRecordViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/6.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivitySignRecordViewController.h"
#import "KSActivitySignRecordViewModel.h"
#import "KSSignRecordListItemViewModel.h"
#import "Masonry.h"
#import "KSSignRecordViewCell.h"
@interface KSActivitySignRecordViewController ()

@property (nonatomic,strong) KSActivitySignRecordViewModel *viewModel;

@end

@implementation KSActivitySignRecordViewController
@dynamic viewModel;
- (instancetype)initWithViewModel:(id<KSViewModelProtocol>)viewModel {
    self = [super initWithViewModel:viewModel];
    if (self) {
        if ([viewModel shouldRequestRemoteDataOnViewDidLoad]) {
            @weakify(self)
            [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
                @strongify(self)
                [self.viewModel.requestRemoteDataCommand execute:@0];
            }];
        }
        
    }
    return self;
}
- (void)setupView {
    
    NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"已签到",@"未签到",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedData];
    segmentedControl.tintColor = [UIColor whiteColor];
    segmentedControl.selectedSegmentIndex = 0;//默认选中的按钮索引
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [[segmentedControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISegmentedControl *Seg) {
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
    self.tableView.backgroundColor = KS_GrayColor_BackColor;
    //不要分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self.tableView registerClass:[KSSignRecordViewCell class] forCellReuseIdentifier:@"KSSignRecordViewCell"];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    headerView.backgroundColor = KS_GrayColor_BackColor;
    [self.view addSubview:headerView];
    
    UILabel *enroll_label = [UILabel new];
    enroll_label.text = @"总计报名人数: 0人";
    enroll_label.textColor = KS_GrayColor4;
    enroll_label.font = KS_SMALL_FONT;
    [headerView addSubview:enroll_label];
    
    UILabel *sign_label = [UILabel new];
    sign_label.text = @"总计签到人数: 0人";
    sign_label.textColor = KS_GrayColor4;
    sign_label.font = KS_SMALL_FONT;
    sign_label.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:sign_label];
    
    [enroll_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@8);
    }];
    
    [sign_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@8);
        make.right.equalTo(@(-8));
    }];
    
    UIView *sp = [UIView new];
    sp.backgroundColor = KS_GrayColor;
    [headerView addSubview:sp];
    [sp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerView);
        make.bottom.equalTo(headerView);
        make.height.equalTo(@1);
    }];
    
    
    
    self.tableView.tableHeaderView = headerView;
    
    @weakify(self)
    
    
    [RACObserve(self.viewModel, listModel) subscribeNext:^(KSSigninListModel *x) {
        if (x != nil) {
            @strongify(self)
            enroll_label.text = [NSString stringWithFormat:@"总计报名人数: %@人",x.signup_count];
            if (self.viewModel.curRequestType == KSSigninListApiTypeYes){
                sign_label.text = [NSString stringWithFormat:@"签到人数: %@人",x.signin_count];
            }else{
                sign_label.text = [NSString stringWithFormat:@"未签到人数: %@人",x.signin_count];
            }
            
        }
    }];
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel.dataSource[section] count];
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,20)];
    titleView.backgroundColor = KS_GrayColor_BackColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.frame.size.width, 20)];
    label.text = self.viewModel.sectionSource[section];
    label.font = KS_SMALL_FONT;
    label.textColor = KS_GrayColor4;
    [titleView addSubview:label];
    return titleView;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.viewModel.sectionSource[section];
}
- (KSSignRecordViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KSSignRecordViewCell* cell = (KSSignRecordViewCell*)[self tableView:tableView dequeueReusableCellWithIdentifier:@"KSSignRecordViewCell" forIndexPath:indexPath];
    id object = self.viewModel.dataSource[indexPath.section][indexPath.row];
    [self configureCell:cell atIndexPath:indexPath withObject:object];
    return cell;
}

#pragma mark - UITableViewDelegate
- (KSSignRecordViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:@"KSSignRecordViewCell" forIndexPath:indexPath];
}

- (void)configureCell:(KSSignRecordViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    [cell bindViewModel:object];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel.dataSource[indexPath.section][indexPath.row] cellHeight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.viewModel.didSelectCommand execute:indexPath];
}

@end
