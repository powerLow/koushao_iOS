//
//  KSTableViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/14.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSTableViewController.h"
#import "KSTableViewModel.h"
@interface KSTableViewController ()

@property (nonatomic, strong, readwrite) UITableView *tableView;

@property (nonatomic, strong, readonly) KSTableViewModel *viewModel;

@end

@implementation KSTableViewController

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

- (void)setView:(UIView *)view {
    [super setView:view];
    if ([view isKindOfClass:UITableView.class]) {
        self.tableView = (UITableView *)view;
    }
}

- (UIEdgeInsets)contentInset {
    return UIEdgeInsetsZero;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.tabBarController.tabBar.frame.size.height-self.navigationController.navigationBar.frame.size.height) style:UITableViewStylePlain];
        self.view = tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
//        self.tableView.backgroundColor = [UIColor grayColor];
    }
    self.tableView.contentOffset = CGPointMake(0, -self.contentInset.top);
    self.tableView.contentInset  = self.contentInset;
    self.tableView.scrollIndicatorInsets = self.contentInset;
    
    self.tableView.sectionIndexColor = [UIColor darkGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexMinimumDisplayRowCount = 20;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
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
