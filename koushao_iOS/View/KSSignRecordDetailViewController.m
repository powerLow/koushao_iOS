//
//  KSSignRecordDetailViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/10.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSSignRecordDetailViewController.h"
#import "Masonry.h"
#import "KSSignRecordDetailViewModel.h"
@interface KSSignRecordDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong,readwrite) KSSignRecordDetailViewModel *viewModel;
@property (nonatomic,strong,readwrite) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;

@end

@implementation KSSignRecordDetailViewController
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
    self.dataSource = [NSArray new];
    [self.viewModel.requestRemoteDataCommand.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self)
        if (executing.boolValue) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = MBPROGRESSHUD_LABEL_TEXT;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.backgroundColor = RGB(243, 243, 243);
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [RACObserve(self.viewModel, model) subscribeNext:^(KSSigninDetailModel  *x) {
        
        if (x != nil) {
//            for (UIView *view in self.view.subviews) {
//                [view removeFromSuperview];
//            }
            NSMutableArray *texts = [[NSMutableArray alloc] init];
            
            if (x.signup_name != nil) {
                //实名制购票
                NSMutableArray *arr = [[NSMutableArray alloc]
                                       initWithArray:@[
                    [NSString stringWithFormat:@"报名账号:  %@",x.signup_user],
                    [NSString stringWithFormat:@"姓       名:  %@",x.signup_name],
                    [NSString stringWithFormat:@"性       别:  %@", [x.gender isEqualToNumber:@0] ? @"男" : @"女"],
                    [NSString stringWithFormat:@"电       话:  %@",x.signup_mobile],
                                                       ]];
                
                if ([x.signin_admin length] > 0) {
                    //签到过才显示
                    
                    [arr addObjectsFromArray:@[[NSString stringWithFormat:@"签到时间:  %@",[KSUtil StringTimeFromNumber:x.signin_time withSeconds:YES]],
                                               [NSString stringWithFormat:@"签  到  人:  %@",x.signin_admin]]];
                }
                [texts addObject:arr];
                //如果有自定义信息
                if (x.custom_info != nil) {
                    NSMutableArray *arr2 = [[NSMutableArray alloc] initWithCapacity:x.custom_info.count];
                    for (NSDictionary* info in x.custom_info) {
                        [arr2 addObject:[NSString stringWithFormat:@"%@:  %@",
                                         [info.allKeys firstObject],
                                         [info.allValues firstObject]]];
                    }
                    [texts addObject:arr2];
                }
                //如果有自定义费用
                if (x.ticket_name != nil) {
                    NSMutableArray *arr3 = [[NSMutableArray alloc]
                                            initWithArray:@[
                                            [NSString stringWithFormat:@"费用名称:  %@",x.ticket_name],
                                            [NSString stringWithFormat:@"费用金额:  %@ 元",x.ticket_price]
                                                                                  ]];
                    [texts addObject:arr3];
                }
            }else{
                //非实名制购票
                if (x.ticket_name != nil) {
                    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:@[
                        [NSString stringWithFormat:@"票务名称:  %@",x.ticket_name],
                        [NSString stringWithFormat:@"票务金额:  %@ 元",x.ticket_price],
                        [NSString stringWithFormat:@"购票账号:  %@",x.signup_user],
                                                                                  ]];
                    if ([x.signin_admin length] > 0) {
                        //签到过才显示
                        [arr addObjectsFromArray:@[
                                                   [NSString stringWithFormat:@"签到时间:  %@",
                                                    [KSUtil StringTimeFromNumber:x.signin_time withSeconds:YES]],
                                                   [NSString stringWithFormat:@"签  到  人:  %@",x.signin_admin]
                                                   ]];
                    }
                    [texts addObject:arr];
                }else{
                    NSMutableArray *arr = [[NSMutableArray alloc]
                                           initWithArray:@[
                            [NSString stringWithFormat:@"报名账号:  %@",x.signup_user],
                            [NSString stringWithFormat:@"姓名:  %@",x.signup_name],
                            [NSString stringWithFormat:@"性别:  %@", [x.gender isEqualToNumber:@0] ? @"男" : @"女"],
                            [NSString stringWithFormat:@"电话:  %@",x.signup_mobile],
                                                           ]];
                    
                    if ([x.signin_admin length] > 0) {
                        //签到过才显示
                        [arr addObjectsFromArray:@[[NSString stringWithFormat:@"签到时间:  %@",x.signup_time],
                                                   [NSString stringWithFormat:@"签  到  人:  %@",x.signin_admin]]];
                    }
                    
                    [texts addObject:arr];
                    
                    //自定义信息
                    if (x.custom_info != nil) {
                        NSMutableArray *arr4 = [[NSMutableArray alloc] initWithCapacity:x.custom_info.count];
                        for (NSDictionary* info in x.custom_info) {
                            [arr4 addObject:[NSString stringWithFormat:@"%@:  %@",
                                             [info.allKeys firstObject],
                                             [info.allValues firstObject]]];
                        }
                        [texts addObject:arr4];
                    }
                }
            }
            self.dataSource = [texts copy];
        }
        
        [self.tableView reloadData];
    }];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource[section] count];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    NSString *title = self.dataSource[indexPath.section][indexPath.row];
    cell.textLabel.text = title;
    cell.textLabel.font = KS_FONT_15;
    cell.textLabel.textColor = RGB(102, 102, 102);
    //    NSLog(@"sub = %@",[title substringToIndex:3]);
    title = [title stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([[title substringToIndex:2] isEqualToString:@"电话"]) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [btn setBackgroundImage:[UIImage imageNamed:@"icon_call"]  forState:UIControlStateNormal];
        cell.accessoryView = btn;
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            NSString *pureNumbers = [[title componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",pureNumbers];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
