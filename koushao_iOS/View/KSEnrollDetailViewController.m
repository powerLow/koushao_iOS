//
//  KSEnrollDetailViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSEnrollDetailViewController.h"
#import "Masonry.h"
#import "KSEnrollDetailViewModel.h"
#import "KSButton.h"
@interface KSEnrollDetailViewController()

@property (nonatomic,strong) UIScrollView *scrollView;
@property (strong, nonatomic, readwrite) KSEnrollDetailViewModel *viewModel;
@end

@implementation KSEnrollDetailViewController

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

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    @weakify(self)
    [self.viewModel.requestRemoteDataCommand.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self)
        if (executing.boolValue) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = MBPROGRESSHUD_LABEL_TEXT;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.scrollView.hidden = NO;
        }
    }];
    
    //headerView
    UIView *headerView = [UIView new];
    [self.view addSubview:headerView];
    UILabel *enrollCountLabel = [UILabel new];
    UILabel *moneyCountLabel = [UILabel new];
    UIButton *browseBtn = [UIButton new];
    UIButton *interestingBtn = [UIButton new];
    
    
    [headerView addSubview:browseBtn];
    [headerView addSubview:interestingBtn];
    
    [browseBtn addSubview:enrollCountLabel];
    [interestingBtn addSubview:moneyCountLabel];
    
    [browseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(headerView);
        make.width.equalTo(interestingBtn);
    }];
    [interestingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(browseBtn.mas_right);
        make.right.top.bottom.equalTo(headerView);
    }];
    
    enrollCountLabel.textColor = [UIColor whiteColor];
    enrollCountLabel.textAlignment = NSTextAlignmentCenter;
    enrollCountLabel.text = @"0";
    enrollCountLabel.font = [UIFont boldSystemFontOfSize:50.0];
    
    moneyCountLabel.textColor = [UIColor whiteColor];
    moneyCountLabel.textAlignment = NSTextAlignmentCenter;
    moneyCountLabel.text = @"0";
    moneyCountLabel.font = [UIFont boldSystemFontOfSize:50.0];
    
    UILabel *enrollTextLabel = [UILabel new];
    enrollTextLabel.text = @"人报名";
    enrollTextLabel.textAlignment = NSTextAlignmentCenter;
    enrollTextLabel.textColor = [UIColor whiteColor];
    [browseBtn addSubview:enrollTextLabel];
    
    UILabel *moneyTextLabel = [UILabel new];
    moneyTextLabel.text = @"元收款";
    moneyTextLabel.textAlignment = NSTextAlignmentCenter;
    moneyTextLabel.textColor = [UIColor whiteColor];
    [interestingBtn addSubview:moneyTextLabel];
    
    //报名人数
    [enrollCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(browseBtn);
        make.centerY.equalTo(browseBtn).offset(-10);
        make.height.equalTo(browseBtn).multipliedBy(0.5);
    }];
    
    //"人报名" 在下面
    [enrollTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(browseBtn);
        make.top.equalTo(enrollCountLabel.mas_bottom);
    }];
    //元收款
    [moneyCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(interestingBtn);
        make.centerY.equalTo(interestingBtn).offset(-10);
        make.height.equalTo(interestingBtn).multipliedBy(0.5);
    }];
    //"元收款" 在下面
    [moneyTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(interestingBtn);
        make.top.equalTo(moneyCountLabel.mas_bottom);
    }];
    
    headerView.backgroundColor = BASE_COLOR;
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.2);
    }];
    
    UIView *sp = [UIView new];
    sp.backgroundColor = [UIColor blackColor];
    [self.view addSubview:sp];
    [sp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerView);
        make.top.equalTo(headerView.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    
    KSButton *button = [KSButton new];
    [button setTitle:@"查看报名记录" forState:UIControlStateNormal];
    button.layer.cornerRadius = 0;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerView);
        make.top.equalTo(sp.mas_bottom);
        make.height.equalTo(headerView).multipliedBy(0.35);
    }];
    
    button.rac_command = self.viewModel.didClickViewEnrollRecordCommand;
    //图表
    
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(button.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    UIView *container = [UIView new];
    [scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    self.scrollView = scrollView;
    self.scrollView.hidden = YES;
    //男女分布比例
    UIView *subContainer_gender = [UIView new];
    [container addSubview:subContainer_gender];
    
    [subContainer_gender mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(container);
        make.top.equalTo(container);
    }];
    
    
    
    //售票分布比例
    UIView *subContainer_ticket = [UIView new];
    [container addSubview:subContainer_ticket];
    
    [subContainer_ticket mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(container);
        make.top.equalTo(subContainer_gender.mas_bottom);
    }];
    
    //自动计算contentSize
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(subContainer_ticket.mas_bottom);
    }];
    
    //数据绑定
    [RACObserve(self.viewModel, enrollInfo) subscribeNext:^(KSActivityEnrollInfo *info) {
        if (info != nil) {
            KSActivity *act = [KSUtil getCurrentActivity];
            act.enroll = info.enroll;
            moneyCountLabel.text = [NSString stringWithFormat:@"%@",info.money];
            enrollCountLabel.text = [NSString stringWithFormat:@"%@",info.enroll];
        }else{
            moneyCountLabel.text = @"0";
            enrollCountLabel.text = @"0";
        }
    }];
    //男女数据
    [RACObserve(self.viewModel, enrollInfo) subscribeNext:^(KSActivityEnrollInfo *info) {
        if (info!=nil) {
            if ([info.gender[@"male"] unsignedIntegerValue] != 0
                || [info.gender[@"female"] unsignedIntegerValue] != 0) {
                subContainer_gender.hidden = NO;
                for (UIView *view in subContainer_gender.subviews) {
                    [view removeFromSuperview];
                }
                UILabel *label = [UILabel new];
                label.text = @"报名活动的男女比例(%)";
                [subContainer_gender addSubview:label];
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(subContainer_gender).offset(10);
                    make.top.equalTo(subContainer_gender).offset(20);
                }];
                
                UIImageView *maleView = [UIImageView new];
                UIImageView *femaleView = [UIImageView new];
                maleView.image = [UIImage imageNamed:@"icon_male"];
                femaleView.image = [UIImage imageNamed:@"icon_female"];
                [subContainer_gender addSubview:maleView];
                [subContainer_gender addSubview:femaleView];
                
                //317*480
                //self.view.bounds.size.height
                [maleView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(subContainer_gender.mas_centerX).offset(-5);
                    make.top.equalTo(label).offset(50);
                    make.width.equalTo(subContainer_gender.mas_width).multipliedBy(0.5 * 0.65);
                    make.height.equalTo(maleView.mas_width).multipliedBy(1.51419);
                }];
                [femaleView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(subContainer_gender.mas_centerX).offset(5);
                    make.top.equalTo(maleView);
                    make.width.height.equalTo(maleView);
                }];
                
                //显示比例的label
                UILabel *male_label = [UILabel new];
                male_label.text = [NSString stringWithFormat:@"0%%"];
                male_label.textAlignment = NSTextAlignmentRight;
                male_label.font=KS_SMALL_FONT;
                male_label.textColor = HexRGB(0x66a8d7);
                
                UILabel *female_label = [UILabel new];
                female_label.text = [NSString stringWithFormat:@"0%%"];
                female_label.textAlignment  = NSTextAlignmentLeft;
                female_label.font=KS_SMALL_FONT;
                female_label.textColor = HexRGB(0xff69c2);
                
                
                [subContainer_gender addSubview:male_label];
                [subContainer_gender addSubview:female_label];
                
                [male_label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(maleView.mas_left).offset(-3);
                    make.top.equalTo(maleView).offset(-7);
                }];
                
                
                [female_label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(femaleView.mas_right).offset(3);
                    make.top.equalTo(femaleView).offset(-7);
                }];
                
                [subContainer_gender mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(maleView.mas_bottom).offset(10);
                }];
                
                double a = [info.gender[@"male"] doubleValue];
                double b = [info.gender[@"female"] doubleValue];
                NSLog(@"%f,%f",a/(a+b)*100.0,b/(a+b)*100.0);
                male_label.text = [NSString stringWithFormat:@"%d%%",(int)round(a/(a+b)*100.0)];
                female_label.text = [NSString stringWithFormat:@"%d%%",(int)round(b/(a+b)*100.0)];
            }else{
                subContainer_gender.hidden = YES;
            }
            
        }
    }];
    //票务数据
    [RACObserve(self.viewModel, enrollInfo) subscribeNext:^(KSActivityEnrollInfo *info) {
        for (UIView* view in subContainer_ticket.subviews) {
            [view removeFromSuperview];
        }
        if (info != nil) {
            if (info.tickets.count > 0) {
                subContainer_ticket.hidden = NO;
                UILabel *label = [UILabel new];
                label.text = @"报名活动售票分布";
                [subContainer_ticket addSubview:label];
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(subContainer_ticket).offset(10);
                    make.top.equalTo(subContainer_ticket).offset(20);
                }];
                
                NSComparator cmptr = ^(id obj1, id obj2){
                    if ([obj1[@"count"] integerValue] < [obj2[@"count"] integerValue]) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                    
                    if ([obj1[@"count"] integerValue] > [obj2[@"count"] integerValue]) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    return (NSComparisonResult)NSOrderedSame;
                };
                NSArray* sortTicket  = [info.tickets sortedArrayUsingComparator:cmptr];
                
                
                NSUInteger maxCount = [sortTicket[0][@"count"] unsignedIntegerValue];
                NSUInteger maxWidth = subContainer_ticket.bounds.size.width * 0.7;
                UIView *lastView = label;
                
                //记录下所有票的次数,如果都为0,则不显示
                NSMutableArray *countArray = [NSMutableArray new];
                for (int i = 0 ; i<info.tickets.count; ++i) {
                    KSActivityTickets * ticket = [KSActivityTickets mj_objectWithKeyValues:info.tickets[i]] ;
                    [countArray addObject:ticket.count];
                    NSLog(@"ticket =  %d \n,  %@",i,ticket);
                    if ([ticket.count  isEqual: @0]) {
                        continue;
                    }
                    //NSNumber *count = ticket.count;
                    //NSNumber *price = ticket.price;
                    //NSString *name = ticket.name;
                    
                    UILabel *ticket_label = [UILabel new];
                    ticket_label.text = ticket.name;
                    [subContainer_ticket addSubview:ticket_label];
                    
                    [ticket_label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(subContainer_ticket).offset(10);
                        make.top.equalTo(lastView.mas_bottom).offset(8);
                        make.height.offset(25);
                    }];
                    
                    //条状
                    UIColor *redColor = HexRGB(0xfc4563);
                    UIImageView *imageView = [UIImageView new];
                    imageView.image = redColor.color2Image;
                    [subContainer_ticket addSubview:imageView];
                    
                    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(ticket_label);
                        make.top.equalTo(ticket_label.mas_bottom).offset(3);
                        double width = round([ticket.count doubleValue]  * maxWidth / maxCount);
                        //NSLog(@"width = %f",width);
                        
                        make.width.mas_equalTo(MAX(width,1));
                        make.height.equalTo(@25);
                    }];
                    
                    //几张
                    UILabel *countLabel = [UILabel new];
                    countLabel.text = [NSString stringWithFormat:@"%ld张",(long)[ticket.count integerValue]];
                    countLabel.textAlignment = NSTextAlignmentLeft;
                    [subContainer_ticket addSubview:countLabel];
                    
                    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.height.width.top.equalTo(imageView);
                        make.left.equalTo(imageView.mas_right).offset(5);
                    }];
                    
                    lastView = imageView;
                }
                
                //如果票卖的最多的是0，则不显示
                NSNumber *Countmax = [countArray valueForKeyPath:@"@max.self"];
                if ([Countmax isEqual:@0]) {
                    label.hidden = YES;
                }
                
                [subContainer_ticket mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(lastView.mas_bottom).offset(20);
                }];
            }else{
                subContainer_ticket.hidden = YES;
            }
            
        }
    }];
}
@end
