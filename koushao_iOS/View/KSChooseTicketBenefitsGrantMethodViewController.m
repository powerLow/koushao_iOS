//
//  KSChooseTicketBenefitsGrantMethodViewController.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/12/9.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSChooseTicketBenefitsGrantMethodViewController.h"
#import "TicketBenefitsTipsViewController.h"
#import "Masonry.h"
@interface KSChooseTicketBenefitsGrantMethodViewController ()
@property(nonatomic, strong, readwrite) UITableView *tableView;
@property (nonatomic, assign) NSUInteger curType;
@end

@implementation KSChooseTicketBenefitsGrantMethodViewController
-(instancetype)initWithType:(NSUInteger)type{
    self = [super init];
    if (self) {
        self.curType = type;
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"选择发放形式";
    _tableView=[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
//    _tableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    UIButton *button = [UIButton new];
    [button setBackgroundImage:[UIImage imageNamed:@"wenhao"] forState:UIControlStateNormal];
    [cell.contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView).offset(-20);
        make.centerY.equalTo(cell.contentView);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
    cell.imageView.image = [UIImage imageNamed:@"cell_selected"];
    if(indexPath.row==0)
    {
        cell.imageView.hidden = self.curType == 0 ? NO : YES;

        cell.textLabel.text=@"以奖券形式兑换";
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            TicketBenefitsTipsViewController *vc = [[TicketBenefitsTipsViewController alloc] initWithType:1];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    else
    {
        cell.imageView.hidden = self.curType == 1 ? NO : YES;
        cell.textLabel.text=@"以实物形式寄送";
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                TicketBenefitsTipsViewController *vc = [[TicketBenefitsTipsViewController alloc] initWithType:2];
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }];
    }
    
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        [self.delegate onDeliverySelectFinished:0];
    }
    else
    {
        [self.delegate onDeliverySelectFinished:2];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
