//
//  KSActivityWelfareRecordViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityWelfareRecordViewController.h"
#import "KSActivityWelfareRecordViewModel.h"
#import "KSWelfareVerifyLogsResultModel.h"
#import "KSWelfareRecordItemViewModel.h"
#import "KSWelfareRecordItemCell.h"
#import "Masonry.h"
#import "KSDropDownMenu.h"
@interface KSActivityWelfareRecordViewController ()<UITableViewDelegate,UITableViewDataSource,KSDropDownMenuDelegate,KSDropDownMenuDataSource>

@property (nonatomic,strong,readwrite) KSActivityWelfareRecordViewModel *viewModel;

//下拉选择菜单
@property (nonatomic,strong,readwrite) KSDropDownMenu *topMenu;
@property (nonatomic,strong,readwrite) NSArray *menuData;
@property (nonatomic,assign,readwrite) NSUInteger currentDataIndex;

@end

@implementation KSActivityWelfareRecordViewController
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

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self)
    //分类菜单
    _currentDataIndex = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.menuData = [NSMutableArray arrayWithObjects:@"全部分类",@"奖券形式发放",@"实物形式发放", nil];
    KSDropDownMenu *menu = [[KSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:45];
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
    //列表
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    
    UILabel *total_label = [UILabel new];
    [headerView addSubview:total_label];
    total_label.text = @"总计抽取: 0个";
    total_label.font = KS_SMALL_FONT;
    total_label.textColor = KS_GrayColor4;
    
    UILabel* send_label = [UILabel new];
    [headerView addSubview:send_label];
    send_label.text = @"总计发放: 0个";
    send_label.font = KS_SMALL_FONT;
    send_label.textColor = KS_GrayColor4;
    
    [total_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(headerView).offset(8);
    }];
    [send_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-8);
        make.top.equalTo(headerView).offset(8);
    }];
    
    
    UIView *sp = [UIView new];
    [headerView addSubview:sp];
    headerView.backgroundColor = KS_GrayColor_BackColor;
    sp.backgroundColor = KS_GrayColor0;
    [sp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerView);
        make.height.equalTo(@1);
        make.bottom.equalTo(headerView.mas_bottom);
    }];
    
    self.tableView.backgroundColor = KS_GrayColor_BackColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = headerView;
    [self.tableView registerClass:[KSWelfareRecordItemCell class] forCellReuseIdentifier:@"KSWelfareRecordItemCell"];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(menu.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [RACObserve(self.viewModel, model) subscribeNext:^(KSWelfareVerifyLogsResultModel *x) {
        if (x != nil) {
            total_label.text = [NSString stringWithFormat:@"总计抽取: %@个",x.draw_count];
            send_label.text = [NSString stringWithFormat:@"总计发放: %@个",x.verified_count];
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
#pragma mark - UITableViewDelegate
- (KSWelfareRecordItemCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KSWelfareRecordItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KSWelfareRecordItemCell" forIndexPath:indexPath];
    id object = self.viewModel.dataSource[indexPath.section][indexPath.row];
    [self configureCell:cell atIndexPath:indexPath withObject:(id)object];
    return cell;
}
- (void)configureCell:(KSWelfareRecordItemCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    [cell bindViewModel:object];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel.dataSource[indexPath.section][indexPath.row] cellHeight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewModel.didSelectCommand execute:indexPath];
}

#pragma mark - KSDropDownMenuDelegate
- (NSInteger)numberOfColumnsInMenu:(KSDropDownMenu *)menu {
    return 1;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    return NO;
}
-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    return NO;
}
-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    return 1;
}
-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    return _currentDataIndex;
}
- (NSInteger)menu:(KSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    return _menuData.count;
}
#pragma mark - KSDropDownMenuDataSource
- (NSString *)menu:(KSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    return [_menuData objectAtIndex:_currentDataIndex];
}
- (NSString *)menu:(KSDropDownMenu *)menu titleForRowAtIndexPath:(KSIndexPath *)indexPath {
    return _menuData[indexPath.row];
}
- (void)menu:(KSDropDownMenu *)menu didSelectRowAtIndexPath:(KSIndexPath *)indexPath{
    NSLog(@"didSelectRowAtIndexPath = %@",indexPath);
    _currentDataIndex = indexPath.row;
    [self.viewModel.didSwitchCommand execute:@(_currentDataIndex)];
}
@end
