//
//  KSAboutUsViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/30.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSAboutUsViewController.h"
#import "Masonry.h"
#import <MessageUI/MessageUI.h>

@interface KSAboutUsViewController () <MFMailComposeViewControllerDelegate>

@property(nonatomic, strong, readwrite) UITableView *tableView;

@end

@implementation KSAboutUsViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    UIView *logoContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    UIImageView *logoImage = [[UIImageView alloc] init];
    logoImage.image = [UIImage imageNamed:@"whistle_logo"];
    logoImage.contentMode = UIViewContentModeScaleAspectFill;
    [logoContainer addSubview:logoImage];
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(logoContainer.mas_centerX);
        make.centerY.mas_equalTo(logoContainer.mas_centerY);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(140);
    }];
    _tableView.tableHeaderView = logoContainer;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 230, 44)];
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.font = [UIFont systemFontOfSize:15];
    tableViewCell.accessoryView = rightLabel;
    if (indexPath.row == 0) {
        tableViewCell.textLabel.text = @"企业邮箱";
        rightLabel.text = @"service@koushaoapp.com";

    }
    else if (indexPath.row == 1) {
        tableViewCell.textLabel.text = @"联系电话";
        rightLabel.text = @"4006054600";
    }

    return tableViewCell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"有任何产品问题、商务合作、活动定制请联系：";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSLog(@"发邮箱");
        [self displayComposerSheet];
    } else if (indexPath.row == 1) {
        NSLog(@"打电话");
        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@", @"4006054600"];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }

}

- (void)displayComposerSheet {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    NSString *title = [NSString stringWithFormat:@"问题反馈-%@", [KSUser currentUser].mobilePhone];
    [picker setSubject:title];

    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"service@koushaoapp.com"];


    [picker setToRecipients:toRecipients];

    // Attach an image to the email
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"" ofType:@"png"];
//    NSData *myData = [NSData dataWithContentsOfFile:path];
//    [picker addAttachmentData:myData mimeType:@"image/png" fileName:@""];

    // Fill out the email body text

    [self presentViewController:picker animated:YES completion:nil];

}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {

    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
