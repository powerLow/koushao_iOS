//
//  KSRefreshTableViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSRefreshTableViewController.h"
#import "KSRefreshTableViewModel.h"
#import "Masonry.h"
@interface KSRefreshTableViewController(){
    BOOL _isRequested;
}

@property (nonatomic, strong, readwrite) UITableView *tableView;

@property (nonatomic, strong, readonly) KSRefreshTableViewModel *viewModel;

@end

@implementation KSRefreshTableViewController

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
    _isRequested = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.sectionIndexColor = [UIColor darkGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexMinimumDisplayRowCount = 20;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    @weakify(self)
    //下拉
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.viewModel.requestRemoteDataCommand execute:@(KSRequestRefreshTypePullDown)];
    }];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    //上拉
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        [self.viewModel.requestRemoteDataCommand execute:@(KSRequestRefreshTypePullUp)];
    }];
    [RACObserve(self.viewModel, isNoMoreData) subscribeNext:^(id x) {
        @strongify(self)
        if ([x boolValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer resetNoMoreData];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
    
    //没有数据的提示
    UIView* nodataView =  [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:nodataView];
    nodataView.hidden = YES;
    
    UIImageView *person = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nodata"]];
    [nodataView addSubview:person];
    
    NSLog(@"class = %@",[NSString stringWithUTF8String:object_getClassName(self)]);
    if ([[NSString stringWithUTF8String:object_getClassName(self)] isEqualToString:@"KSActivityListViewController_RACSelectorSignal"]) {
        
        [person mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(nodataView);
            make.top.equalTo(nodataView).offset(30);
        }];
        
        UILabel *tips1 = [UILabel new];
        tips1.font = KS_FONT_16;
        tips1.textColor = KS_GrayColor4;
        tips1.text = @"暂时没有活动哦╮(╯▽╰)╭";
        tips1.textAlignment = NSTextAlignmentCenter;
        [nodataView addSubview:tips1];
        [tips1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(nodataView);
            make.top.equalTo(person.mas_bottom).offset(15);
        }];
        
        UILabel *tips2 = [UILabel new];
        tips2.font = KS_FONT_16;
        tips2.textColor = KS_GrayColor4;
        tips2.text = @"去创建新活动吧";
        tips2.textAlignment = NSTextAlignmentCenter;
        [nodataView addSubview:tips2];
        [tips2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(nodataView);
            make.top.equalTo(tips1.mas_bottom).offset(5);
        }];
        
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nodata_arrow"]];
        [nodataView addSubview:arrowView];
        [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tips2.mas_bottom).offset(5);
            make.centerX.equalTo(nodataView);
        }];
    }else{
        [person mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(nodataView);
            make.centerY.equalTo(nodataView).offset(-10);
        }];
        
        UILabel *tips1 = [UILabel new];
        tips1.font = KS_FONT_16;
        tips1.textColor = KS_GrayColor4;
        tips1.text = @"暂时没有内容哦╮(╯▽╰)╭";
        tips1.textAlignment = NSTextAlignmentCenter;
        [nodataView addSubview:tips1];
        [tips1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(nodataView);
            make.top.equalTo(person.mas_bottom).offset(15);
        }];
    }
    
    [[RACObserve(self.viewModel, dataSource) skipUntilBlock:^BOOL(id x) {
        return _isRequested;
    }] subscribeNext:^(NSArray* x) {
        if (x != nil) {
            nodataView.hidden = YES;
            if (x.count == 0) {
                NSLog(@"一个活动都没有...");
                
            }
        }else{
            nodataView.hidden = NO;
        }
    }];
    
    
    [self.viewModel.requestRemoteDataCommand.executing subscribeNext:^(NSNumber *executing) {
        NSLog(@"requestRemoteDataCommand");
        @strongify(self)
        if (executing.boolValue && self.viewModel.dataSource == nil) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = MBPROGRESSHUD_LABEL_TEXT;
            nodataView.hidden = YES;
            _isRequested = YES;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView.mj_header endRefreshing];
        }
    }];
    RAC(self.viewModel, dataSource) = [[RACObserve(self.viewModel, items)
                                        map:^(NSArray *items) {
                                            @strongify(self)
                                            return [self.viewModel dataSourceWithItems:items];
                                        }]
                                       map:^(NSArray *viewModels) {
                                           return viewModels;
                                       }];
}

- (void)dealloc {
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self)
    [RACObserve(self.viewModel, dataSource).distinctUntilChanged.deliverOnMainThread subscribeNext:^(id x) {
        @strongify(self)
//        NSLog(@"self.items = %@",self.viewModel.items);
        [self.tableView reloadData];
    }];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataSource ? self.viewModel.dataSource.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"rows = %ld",(unsigned long)[self.viewModel.dataSource[section] count]);
    return [self.viewModel.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    id object = self.viewModel.dataSource[indexPath.section][indexPath.row];
    [self configureCell:cell atIndexPath:indexPath withObject:(id)object];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section >= self.viewModel.sectionIndexTitles.count) return nil;
    return self.viewModel.sectionIndexTitles[section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.viewModel.sectionIndexTitles;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewModel.didSelectCommand execute:indexPath];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    [self.refreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //    [self.refreshControl scrollViewDidEndDragging];
}


@end
