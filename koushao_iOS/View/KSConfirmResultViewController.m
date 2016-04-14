//
//  KSConfirmResultViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/17.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSConfirmResultViewController.h"
#import "KSConfirmResultViewModel.h"

#import "Masonry.h"
@interface KSConfirmResultViewController ()

@property (nonatomic,strong,readwrite) KSConfirmResultViewModel *viewModel;
@end

@implementation KSConfirmResultViewController
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
    [self.viewModel.requestRemoteDataCommand.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self)
        if (executing.boolValue) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = MBPROGRESSHUD_LABEL_TEXT;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    scrollView.backgroundColor = RGB(250, 250, 250);
    
    UIView *container = [UIView new];
    [scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    UIColor *textColor = RGB(102, 102, 102);
    UIFont *textFont = KS_SMALL_FONT;
    
    [RACObserve(self.viewModel, model) subscribeNext:^(KSAwardDetailModel *x) {
        NSLog(@"x = %@",x);
        if (x == nil) {
            return;
        }
        for(UIView *view in container.subviews)
        {
            [view removeFromSuperview];
        }
        //福利内容:  暴力熊玩具
        //接收账号:  155####1234
        //抽奖时间:  2015年7月8日 19:35
        //--
        //姓   名:  毛阿敏
        //联系电话:  13950392121
        //地   址:  湖南省小区几栋几单元
        //邮政编码:  041000
        //--
        //快递单号:
        //快递公司:
        //快递状态:
        NSArray *texts = @[
                           [NSString stringWithFormat:@"奖品内容:  %@",x.welfare_name],
                           [NSString stringWithFormat:@"接收账号:  %@",x.receiver],
                           [NSString stringWithFormat:@"发放时间:  %@",[KSUtil StringTimeFromNumber:x.time withSeconds:YES]],
                           [NSString stringWithFormat:@"发放人:  %@",x.admin],
                           [NSString stringWithFormat:@"姓       名:  %@",x.delivery_info.name],
                           [NSString stringWithFormat:@"联系电话:  %@",x.delivery_info.phone],
                           [NSString stringWithFormat:@"地       址:  %@",x.delivery_info.address],
                           [NSString stringWithFormat:@"邮政编码:  %@",x.delivery_info.post],
                           [NSString stringWithFormat:@"快递单号:  %@",x.delivery_info.nu],
                           [NSString stringWithFormat:@"快递公司:  %@",x.delivery_info.company],
                           [NSString stringWithFormat:@"快递状态:  %@",@""],
                           ];
        UIView *lastView = nil;
        NSInteger top_margin = SCREEN_HEIGHT / 28;
        NSInteger left_margin = SCREEN_WIDTH / 12;
        for (int i = 0; i < texts.count; ++i) {
            UILabel *label = [UILabel new];
            [container addSubview:label];
            label.font = textFont;
            label.textColor = textColor;
            label.text = texts[i];
            
            
            
            if (lastView == nil) {
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(container.mas_left).offset(left_margin);
                    make.top.equalTo(container).offset(top_margin);
                }];
            }else{
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(container.mas_left).offset(left_margin);
                    make.top.equalTo(lastView.mas_bottom).offset(top_margin);
                }];
            }
            
            
            lastView = label;
            
            if (i == 3 || i == 7) {
                UIView *sp = [UIView new];
                [container addSubview:sp];
                
                sp.backgroundColor = RGB(243, 243, 243);
                
                [sp mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(container);
                    make.top.equalTo(lastView.mas_bottom).offset(top_margin);
                    make.height.equalTo(@2);
                }];
                lastView = sp;
            }
        }
        //自动计算contentSize
        
        UIButton *lookup = [UIButton new];
        [container addSubview:lookup];
        [lookup setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [lookup setTitle:@"查看物流" forState:UIControlStateNormal];
        lookup.titleLabel.font = textFont;
        
        [[lookup rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id a) {
            NSLog(@"查看物流被点击");
            
            [self.viewModel.didClickLoopUpBtn
             execute:RACTuplePack(x.delivery_info.nu,x.delivery_info.company)];
        }];
        
        [lookup mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastView.mas_right);
            make.top.height.equalTo(lastView);
        }];
        
        [container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastView.mas_bottom).offset(top_margin);
        }];
        
    }];
    
}
@end
