//
//  KSConfirmGfitViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/17.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSConfirmGfitViewController.h"
#import "KSConfirmGfitViewModel.h"
#import "Masonry.h"
#import "KSAwardDetailModel.h"
#import "KSExpressListViewController.h"
@interface KSConfirmGfitViewController ()<UITextFieldDelegate,ExpressListViewDelgate>

@property (nonatomic,strong) UITextField *nu_textField;
@property (nonatomic,strong) UITextField *company_textField;
@property (nonatomic,strong) KSConfirmGfitViewModel *viewModel;

@end


@implementation KSConfirmGfitViewController
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
- (void)initNav {
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确认发放" style:UIBarButtonItemStylePlain target:self action:@selector(confirm)];
    self.navigationItem.rightBarButtonItem = item;

}
- (void)confirm {
    if (_nu_textField.text.length == 0) {
        KSError(@"快递单号不能为空");
        return;
    }
    if (_company_textField.text.length == 0) {
        KSError(@"快递名称不能为空");
        return;
    }
    [self.viewModel.didClickConfirmBtn execute:RACTuplePack(_nu_textField.text,_company_textField.text)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //[IQKeyboardManager sharedManager].enable = NO;
    [self initNav];
    @weakify(self)
    [self.viewModel.requestRemoteDataCommand.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self)
        if (executing.boolValue) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = MBPROGRESSHUD_LABEL_TEXT;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
    [self.viewModel.didClickConfirmBtn.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self)
        if (executing.boolValue) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = @"正在提交...";
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = @"提交成功";
            [KSUtil runAfterSecs:1.0 block:^{
                [KSUtil runInMainQueue:^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }];
            }];
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
        //快递单号
        //
        //快递公司
        //
        NSArray *texts = @[
                           [NSString stringWithFormat:@"奖品内容:  %@",x.welfare_name],
                           [NSString stringWithFormat:@"接收账号:  %@",x.receiver],
                           [NSString stringWithFormat:@"抽奖时间:  %@",[KSUtil StringTimeFromNumber:x.time withSeconds:YES]],
                           [NSString stringWithFormat:@"姓       名:  %@",x.delivery_info.name],
                           [NSString stringWithFormat:@"联系电话:  %@",x.delivery_info.phone],
                           [NSString stringWithFormat:@"地       址:  %@",x.delivery_info.address],
                           [NSString stringWithFormat:@"邮政编码:  %@",x.delivery_info.post],
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
            
            if (i == 2 || i == 6) {
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
        
        
        //快递单号
        UILabel *nu_label = [UILabel new];
        nu_label.text = @"快递单号";
        nu_label.textColor = textColor;
        nu_label.font = textFont;
        [container addSubview:nu_label];
        
        [nu_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(container).offset(left_margin);
            make.top.equalTo(lastView.mas_bottom).offset(top_margin);
        }];
        
        UITextField *nu_textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        nu_textField.placeholder = @"请输入单号";
        [container addSubview:nu_textField];
        
        [nu_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(container).offset(left_margin);
            make.right.equalTo(container).offset(-left_margin);
            make.top.equalTo(nu_label.mas_bottom).offset(10);
            make.height.equalTo(@25);
        }];
        
        UIView *field_bottom_line = [UIView new];
        field_bottom_line.backgroundColor = RGB(243, 243, 243);
        [nu_textField addSubview:field_bottom_line];
        [field_bottom_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.left.right.equalTo(nu_textField);
            make.bottom.equalTo(nu_textField.mas_bottom);
        }];
        
        
        //快递公司
        UILabel *company_label = [UILabel new];
        company_label.text = @"快递公司";
        company_label.textColor = textColor;
        company_label.font = textFont;
        [container addSubview:company_label];
        
        UITextField *company_textField = [UITextField new];
        company_textField.placeholder = @"请输入公司";
        [container addSubview:company_textField];
        
        [company_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(container).offset(left_margin);
            make.top.equalTo(nu_textField.mas_bottom).offset(top_margin);
        }];
        
        [company_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(container).offset(left_margin);
            make.right.equalTo(container).offset(-left_margin);
            make.top.equalTo(company_label.mas_bottom).offset(10);
            make.height.equalTo(@25);
        }];
        
        UIView *company_textField_bottom_line = [UIView new];
        company_textField_bottom_line.backgroundColor = RGB(243, 243, 243);
        [company_textField addSubview:company_textField_bottom_line];
        [company_textField_bottom_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.left.right.equalTo(company_textField);
            make.bottom.equalTo(company_textField.mas_bottom);
        }];
        
        
        lastView = company_textField;
        
        _nu_textField = nu_textField;
        _company_textField = company_textField;
        company_textField.delegate = self;
        
        //自动计算contentSize
        
        [container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastView.mas_bottom).offset(top_margin);
        }];
        
        [[company_textField rac_signalForSelector:@selector(textFieldDidBeginEditing:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(id x) {
            NSLog(@"快递公司编辑开始1111");
        }];
        
    }];
    
    
 
    
}

#pragma mark - 
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    KSExpressListViewController *listView = [[KSExpressListViewController alloc] init];
    listView.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:listView];
    [self presentViewController:nav animated:YES completion:nil];
    return NO;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:_company_textField]) {
        NSLog(@"快递公司编辑开始");
        
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:_company_textField]) {
        NSLog(@"快递公司编辑结束");
    }
}
#pragma mark - ExpressListViewDelgate
- (void)ExpressListView:(KSExpressListViewController*)controller didSelectWithobject:(Express*)express{
    self.company_textField.text = express.expressName;
}
@end
