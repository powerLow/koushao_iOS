//
//  KSFeedBackViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/30.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSFeedBackViewController.h"
#import "Masonry.h"
#import "KSPlaceHolderTextView.h"


@interface KSFeedBackViewController ()

@property(nonatomic, assign) CGFloat textViewHeight;
@property(nonatomic, strong, readwrite) UITableView *tableView;
@property(nonatomic, copy) NSString *emailAddress;
@property(nonatomic, copy) NSString *feedbackContent;
@end

@implementation KSFeedBackViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _textViewHeight = 130;
    [self.view addSubview:_tableView];
    [self initTitleBar];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 1: {
            KSPlaceHolderTextView *textView = [[KSPlaceHolderTextView alloc] initWithFrame:CGRectMake(0, 0, tableViewCell.contentView.frame.size.width, self.textViewHeight)];
            textView.placeholder = @"请输入您的建议";
            textView.scrollEnabled = NO;
            [tableViewCell.contentView addSubview:textView];
            textView.font = [UIFont fontWithName:@"Arial" size:14];
            [[textView rac_textSignal] subscribeNext:^(NSString *x) {
                self.feedbackContent = x;
            }];
            @weakify(self)
            [textView.rac_textSignal subscribeNext:^(NSString *x) {
                @strongify(self)
                CGFloat nowHeight = [KSUtil textHeight:x withFont:textView.font targetWidth:[UIScreen mainScreen].bounds.size.width];
                if (nowHeight > self.textViewHeight) {
                    self.textViewHeight = nowHeight;
                    textView.frame = CGRectMake(0, 0, tableViewCell.contentView.frame.size.width, self.textViewHeight);
                    [self.tableView beginUpdates];
                    [self.tableView endUpdates];
                }
                else if (nowHeight <= 130 && self.textViewHeight != 130) {
                    self.textViewHeight = 130;
                    textView.frame = CGRectMake(0, 0, tableViewCell.contentView.frame.size.width, self.textViewHeight);
                    [self.tableView beginUpdates];
                    [self.tableView endUpdates];
                }
            }];
        }
            break;

        case 0: {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, [UIScreen mainScreen].bounds.size.width, 44)];
            [tableViewCell.contentView addSubview:textField];
            textField.font = [UIFont systemFontOfSize:14];
            textField.keyboardType = UIKeyboardTypeEmailAddress;
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入你的联系邮箱，我们会尽快予以回复" attributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
            [[textField rac_textSignal] subscribeNext:^(NSString *x) {
                self.emailAddress = x;
            }];

        }
            break;

        default:
            break;
    }
    return tableViewCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)return 44;
    else return self.textViewHeight;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"联系邮箱";
    else return @"意见建议";
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)return 44;
    else return self.textViewHeight;
}

- (void)initTitleBar {
    self.navigationItem.backBarButtonItem.title = @"";
    //下一步按钮
    UILabel *rightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    rightTitleLabel.backgroundColor = [UIColor clearColor];
    rightTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    rightTitleLabel.textColor = [UIColor whiteColor];
    rightTitleLabel.text = @"提交";
    rightTitleLabel.textAlignment = NSTextAlignmentRight;
    UIButton *rightTitleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [rightTitleButton addSubview:rightTitleLabel];
    [rightTitleButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightTitleButton];
    //设置NavigationBar的相关属性
    // self.navigationItem.leftBarButtonItem=leftBarButtonItem;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)nextStep {
    [self.view endEditing:YES];
    if (!_emailAddress || _emailAddress.length == 0) {
        KSError(@"联系方式不能为空！");
        return;
    }
    if (!_feedbackContent || _feedbackContent.length == 0) {
        KSError(@"反馈内容不能为空！");
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].labelText = @"正在提交反馈";
    [[KSClientApi FeedbackCommit:_feedbackContent withContact:_emailAddress] subscribeNext:^(id x) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提交成功" message:@"您提交的反馈信息我们已经收到，感谢您的支持！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alertView.delegate = self;
        [alertView show];

    }                                                                                error:^(NSError *error) {
        KSError([error.userInfo objectForKey:@"tips"]);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
