//
//  KSProfileViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/14.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSProfileViewController.h"
#import "KSProfileViewModel.h"
#import <YYWebImage.h>
#import "Masonry.h"


@interface KSProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong, readonly) KSProfileViewModel *viewModel;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIImageView *avatarImageView;
@end

@implementation KSProfileViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;


    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.sectionIndexColor = [UIColor darkGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexMinimumDisplayRowCount = 20;

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.tableFooterView = [[UIView alloc] init];

    @weakify(self)
    [RACObserve(self.viewModel, user)
            subscribeNext:^(id x) {
                @strongify(self)
                [self.tableView reloadData];
            }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAvatarRefresh:) name:@"uploadAvatarComplete" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"uploadAvatarComplete" object:nil];
}

- (void)onAvatarRefresh:(NSString *)avatarUrl {
    NSString *defaultUrl = [KSUser currentUser].avatar;
    //加载缩略图
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@", defaultUrl, @""];
    NSURL *url = [[NSURL alloc] initWithString:imageUrl];
    //[self.posterView sd_setImageWithURL:url];
    [self.avatarImageView yy_setImageWithURL:url
                                 placeholder:nil
                                     options:YYWebImageOptionSetImageWithFadeAnimation
                                    progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                        //                             progress = (float)receivedSize / expectedSize;
                                    }
                                   transform:^UIImage *(UIImage *image, NSURL *url) {
                                       //                            image = [image yy_imageByResizeToSize:CGSizeMake(100, 100) contentMode:UIViewContentModeCenter];
                                       return image;
                                   }
                                  completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                      if (from == YYWebImageFromDiskCache) {
                                          NSLog(@"load from disk cache");
                                      }
                                  }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.tableView beginUpdates];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView endUpdates];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 1 ? 4 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSArray *titles = @[
            @[@"个人资料"],
            @[@"活动统计", @"金额提现", @"意见反馈", @"联系我们"],
            @[@"退出"]
    ];
    NSArray *imageNames = @[
            @[@""],
            @[@"icon_statistics", @"icon_mymoney", @"icon_feedback", @"icon_aboutus"],
            @[@"UMS_share_change_to_account"]
    ];
    if ([imageNames[indexPath.section][indexPath.row] isEqualToString:@""]) {
        cell.imageView.image = KS_GrayColor0.color2Image;
    } else {
        cell.imageView.image = [UIImage imageNamed:imageNames[indexPath.section][indexPath.row]];
    }

    cell.textLabel.text = titles[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        cell.textLabel.text = @"";
        NSString *phoneNumber = [NSString stringWithFormat:@"绑定手机号：%@", [KSUser currentUser].mobilePhone];
        NSString *nickname = [KSUser currentUser].nickname;

        UILabel *nicknameLabel = [[UILabel alloc] init];
        nicknameLabel.text = nickname;
        nicknameLabel.font = [UIFont systemFontOfSize:18];

        UILabel *phonenumberLabel = [[UILabel alloc] init];
        phonenumberLabel.text = phoneNumber;
        phonenumberLabel.font = [UIFont systemFontOfSize:14];

        [cell.contentView addSubview:phonenumberLabel];
        [cell.contentView addSubview:nicknameLabel];

        CGFloat padding = 14;
        CGFloat width = 100 - (padding * 2);
        UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, padding, width, width)];
        avatarImageView.frame = CGRectMake(12, padding, width, width);
        avatarImageView.layer.masksToBounds = YES;
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2;
        NSString *defaultUrl = [KSUser currentUser].avatar;

        //加载缩略图
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@", defaultUrl, @""];
        NSURL *url = [[NSURL alloc] initWithString:imageUrl];
        //[self.posterView sd_setImageWithURL:url];
        [avatarImageView yy_setImageWithURL:url
                                placeholder:nil
                                    options:YYWebImageOptionSetImageWithFadeAnimation
                                   progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                       //                             progress = (float)receivedSize / expectedSize;
                                   }
                                  transform:^UIImage *(UIImage *image, NSURL *url) {
                                      //                            image = [image yy_imageByResizeToSize:CGSizeMake(100, 100) contentMode:UIViewContentModeCenter];
                                      return image;
                                  }
                                 completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                     if (from == YYWebImageFromDiskCache) {
                                         NSLog(@"load from disk cache");
                                     }
                                 }];
        [cell.contentView addSubview:avatarImageView];
        self.avatarImageView = avatarImageView;
        [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.contentView.mas_centerY).with.offset(-15);
            make.left.mas_equalTo(avatarImageView.mas_right).with.offset(20);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(200);
        }];

        [phonenumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.contentView.mas_centerY).with.offset(15);
            make.left.mas_equalTo(avatarImageView.mas_right).with.offset(20);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(200);
        }];

    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 20 : 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (section == tableView.numberOfSections - 1) ? 20 : 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    }
    else
        return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewModel.didSelectCommand execute:indexPath];
}


@end
