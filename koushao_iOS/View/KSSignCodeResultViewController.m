//
//  KSSignCodeResultViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/7.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSSignCodeResultViewController.h"
#import "KSSignCodeResultViewModel.h"
#import "Masonry.h"
#import "KSButton.h"
@interface KSSignCodeResultViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong,readonly) KSSignCodeResultViewModel* viewModel;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray* dataSource;
@end

@implementation KSSignCodeResultViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    
    @weakify(self)
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    UIView *container = [UIView new];
    [scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    
    [RACObserve(self.viewModel, result) subscribeNext:^(KSSignResultModel *model) {
        if (model != nil) {
            for (UIView *view in container.subviews) {
                [view removeFromSuperview];
            }
            
            UIImageView *imageView = [UIImageView new];
            [container addSubview:imageView];
            
            @weakify(self)
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self)
                make.height.width.equalTo(@35);
                make.centerX.equalTo(self.view).offset(-SCREEN_WIDTH/6);
                make.top.equalTo(self.mas_topLayoutGuideBottom).offset(SCREEN_HEIGHT / 10);
            }];
            
            KSButton *okBtn = [KSButton new];
            [okBtn setTitle:@"确认" forState:UIControlStateNormal];
            [container addSubview:okBtn];
            [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self)
                make.centerX.equalTo(self.view);
                make.width.equalTo(self.view).multipliedBy(0.8);
                make.height.equalTo(self.view).multipliedBy(0.07);
                make.top.equalTo(imageView.mas_bottom).offset(SCREEN_HEIGHT / 10);
            }];
            okBtn.rac_command = self.viewModel.didClickOkBtnCommand;
            UIView *sp = [UIView new];
            sp.backgroundColor = KS_GrayColor;
            
            [container addSubview:sp];
            [sp mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self)
                make.left.right.equalTo(self.view);
                make.height.equalTo(@1);
                make.top.equalTo(okBtn.mas_bottom).offset(SCREEN_HEIGHT / 10);
            }];
            UILabel *label = [UILabel new];
            [container addSubview:label];
            label.font = KS_NORMAL_FONT;
            
            self.tableView = [UITableView new];
            [container addSubview:_tableView];
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
            
            UILabel *textLabel  = [UILabel new];
            textLabel.text = [model.type  isEqual: @0] ? @"报名信息" : @"票务信息";
            textLabel.textColor = KS_GrayColor4;
            textLabel.font = KS_FONT_16;
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];
            [headerView addSubview:textLabel];
            
            [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headerView);
                make.left.equalTo(headerView).offset(15);
            }];
            
            self.tableView.tableHeaderView = headerView;
            
            NSMutableArray *texts = [NSMutableArray new];
            if (model.isSuccess) {
                imageView.image = [UIImage imageNamed:@"icon_success"];
                label.textColor = BASE_COLOR;
                label.text = @"签到成功!";
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(imageView.mas_right).offset(10);
                    make.height.equalTo(imageView);
                    make.top.equalTo(imageView);
                }];
                
            }else{
                imageView.image = [UIImage imageNamed:@"icon_fail"];
                label.textColor = [UIColor redColor];
                label.text = @"签到失败!";
                
                UILabel *label2 = [UILabel new];
                [container addSubview:label2];
                if ([model.type  isEqual: @0]) {
                    label2.text = @"该用户已签到";
                }else{
                    label2.text = @"该票券已使用";
                }
                
                label2.textColor = KS_GrayColor4;
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(imageView.mas_right).offset(10);
//                    make.height.equalTo(imageView);
                    make.top.equalTo(imageView);
                }];
                [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(label);
                    make.top.equalTo(label.mas_bottom);
                }];
            }
            
            if([model.type  isEqual: @0]){
                //报名
                if (model.userinfo.name != nil) {
                    [texts addObjectsFromArray:@[
                                                 [NSString stringWithFormat:@"姓       名:  %@",model.userinfo.name],
                                                 [NSString stringWithFormat:@"报名账号:%@",model.mobilePhone]
                                                 ]];
                }
                if (model.ticket_info.allKeys.count > 0) {
                    [texts addObjectsFromArray:@[
                                                 [NSString stringWithFormat:@"费用名称:  %@",model.ticket_title],
//                                                 [NSString stringWithFormat:@"费用金额:  %@元",model.ticket_price],
                                                 [NSString stringWithFormat:@"购票账号:  %@",model.mobilePhone],
                                                 ]];
                    
                }
            }else{
                //售票
                if (model.ticket_info.allKeys.count > 0) {
                    [texts addObjectsFromArray:@[
                                                 [NSString stringWithFormat:@"票务名称:  %@",model.ticket_title],
                                                 [NSString stringWithFormat:@"购票账号:  %@",model.mobilePhone]
                                                 ]];
                    
                }
            }
            
            
            
            if (model.signinTime != nil) {
                [texts addObject:[NSString stringWithFormat:@"签到时间:  %@",[KSUtil StringTimeFromNumber:model.signinTime withSeconds:YES]]];
                [texts addObject:[NSString stringWithFormat:@"签 到 人:  %@",model.signinAdmin]];
            }
            self.dataSource = [texts copy];
            
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(sp.mas_bottom).offset(5);
                make.left.right.equalTo(container);
                make.height.mas_equalTo(texts.count * 44 + 25);
            }];
            
            [self.tableView reloadData];
            
            [container mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_tableView.mas_bottom).offset(20);
            }];
        }
    }];
    
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.textLabel.font = KS_FONT_16;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
