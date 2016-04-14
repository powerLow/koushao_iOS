//
//  KSEnrollRecordDetailViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/5.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSEnrollRecordDetailViewController.h"
#import "Masonry.h"

#define vPadding 15
@interface KSEnrollRecordDetailViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong,readwrite) KSEnrollRecordDetailViewModel *viewModel;

@property (nonatomic,strong,readwrite) NSArray *dataSource;

@end

@implementation KSEnrollRecordDetailViewController
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    @weakify(self)
    [self.viewModel.requestRemoteDataCommand.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self)
        if (executing.boolValue) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = MBPROGRESSHUD_LABEL_TEXT;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = RGB(243, 243, 243);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    [RACObserve(self.viewModel, info) subscribeNext:^(KSActivityEnrollRecordItemInfo *info) {
        if (info != nil) {
            NSMutableArray *texts = [NSMutableArray new];
            if (info.nickname != nil) {
                //姓名:  马云
                //性别:  女
                //电话:  13216708954
                //报名时间:  2015-11-04 15:52
                //签到状态:  未签到
                //--
                //公司:  阿里巴巴
                [texts addObject:@[
                        [NSString stringWithFormat:@"姓名:  %@",info.nickname],
                        [NSString stringWithFormat:@"性别:  %@",[info.gender  isEqual: @"male"] ? @"男":@"女"],
                        [NSString stringWithFormat:@"电话:  %@",info.mobilePhone],
                        [NSString stringWithFormat:@"报名时间:  %@",[KSUtil StringTimeFromNumber:info.signup_time withSeconds:YES]],
                        //[NSString stringWithFormat:@"签到状态:  %@",[info.bsign boolValue] ? @"已签到":@"未签到"]
                    ]];
                if (info.custom_info.count > 0) {
                    NSMutableArray *custom_array = [NSMutableArray new];
                    for (int i =0; i<info.custom_info.count; ++i) {
                        NSDictionary *dict = info.custom_info[i];
                        NSString *key = dict.allKeys[0];
                        NSString *value = dict.allValues[0];
                        [custom_array addObject:[NSString stringWithFormat:@"%@:  %@",
                                                 key,value]];
                    }
                    
                    [texts addObject:custom_array];
                }
                if (info.fee_name != nil) {
                    [texts addObject:@[
                                       [NSString stringWithFormat:@"费用名称:  %@",info.fee_name],
                                       [NSString stringWithFormat:@"费用金额:  %@元",info.fee_price],
                                       ]];
                }
            }else{
                if (info.fee_name != nil) {
                    [texts addObject:@[
                                       [NSString stringWithFormat:@"票务名称:  %@",info.fee_name],
                                       [NSString stringWithFormat:@"票务金额:  %@元",info.fee_price],
                                       [NSString stringWithFormat:@"购票时间:  %@",[KSUtil StringTimeFromNumber:info.signup_time withSeconds:YES]],
                                       //[NSString stringWithFormat:@"使用状态:  %@",[info.bsign boolValue] ? @"已使用":@"未使用"],
                                       ]];
                }
            }
            
            self.dataSource = [texts copy];
            
        }
    }];
    [RACObserve(self, dataSource) subscribeNext:^(id x) {
        [tableView reloadData];
    }];
}
#pragma mark-  UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.textColor = RGB(102, 102, 102);
    cell.textLabel.font = KS_FONT_15;
    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
        view.backgroundColor = KS_GrayColor_BackColor;
        return view;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        view.backgroundColor = KS_GrayColor_BackColor;
        return view;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section > 0 ?  8 : 0;
}
@end
