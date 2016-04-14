//
//  KSProfileDetailViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/30.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSProfileDetailViewController.h"
#import "Masonry.h"
#import <YYWebImage.h>
#import "ImageUploader.h"
#import "KSSetGenderViewController.h"
#import "KSSetNicknameViewController.h"
#import "KSButton.h"
#import "KSProfileDetailViewModel.h"

@interface KSProfileDetailViewController ()

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UILabel *genderLabel;
@property(nonatomic, strong) UILabel *nicknameLabel;
@property(nonatomic, strong) UIImageView *avatarImageView;
@property(nonatomic, strong, readwrite) KSProfileDetailViewModel *viewModel;

@end

@implementation KSProfileDetailViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    _genderLabel = [[UILabel alloc] init];
    _nicknameLabel = [[UILabel alloc] init];
    _avatarImageView = [[UIImageView alloc] init];
    _nicknameLabel.textAlignment = NSTextAlignmentRight;
    _nicknameLabel.textColor = [UIColor grayColor];
    _genderLabel.textAlignment = NSTextAlignmentRight;
    _genderLabel.textColor = [UIColor grayColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];


    UIView *logoutButtonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    self.tableView.backgroundColor = RGB(240, 239, 245);
    logoutButtonContainer.backgroundColor = RGB(240, 239, 245);
    KSButton *logouButton = [[KSButton alloc] initWithColor:RGB(237, 88, 76)];
    [logoutButtonContainer addSubview:logouButton];
    [logouButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(logoutButtonContainer.mas_centerX);
        make.centerY.mas_equalTo(logoutButtonContainer.mas_centerY);
        make.width.mas_equalTo(SCREEN_WIDTH - 40);
        make.height.mas_equalTo(48);
    }];
    [logouButton setTitle:@"退出登陆" forState:UIControlStateNormal];
    logouButton.rac_command = self.viewModel.didQuitBtnCommand;
    _tableView.tableFooterView = logoutButtonContainer;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    KSUser *user = [KSUser currentUser];
    if ([user.gender integerValue] == 0)
        _genderLabel.text = @"男";
    else
        _genderLabel.text = @"女";
    _nicknameLabel.text = user.nickname;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //设置选择后的图片可被编辑
        picker.allowsEditing = NO;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else if (indexPath.row == 1) {
        KSSetNicknameViewController *nicknameViewController = [[KSSetNicknameViewController alloc] init];
        [self.navigationController pushViewController:nicknameViewController animated:YES];
    }
    else if (indexPath.row == 2) {
        KSSetGenderViewController *genderViewController = [[KSSetGenderViewController alloc] init];
        [self.navigationController pushViewController:genderViewController animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;

    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = @"头像";
            _avatarImageView.layer.masksToBounds = YES;

            NSString *defaultUrl = [KSUser currentUser].avatar;

            //加载缩略图
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@", defaultUrl, @""];
            NSURL *url = [[NSURL alloc] initWithString:imageUrl];
            [_avatarImageView yy_setImageWithURL:url
                                     placeholder:nil
                                         options:YYWebImageOptionSetImageWithFadeAnimation
                                        progress:^(NSInteger receivedSize, NSInteger expectedSize) {

                                        }
                                       transform:^UIImage *(UIImage *image, NSURL *url) {
                                           return image;
                                       }
                                      completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                          if (from == YYWebImageFromDiskCache) {
                                              NSLog(@"load from disk cache");
                                          }
                                      }];
            [cell.contentView addSubview:_avatarImageView];
            [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(80);
                make.height.mas_equalTo(80);
                make.right.mas_equalTo(cell.contentView.mas_right);
                make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            }];
            _avatarImageView.layer.cornerRadius = 80 / 2;
        }

            break;
        case 1: {
            cell.textLabel.text = @"昵称";
            [cell.contentView addSubview:_nicknameLabel];
            [_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(200);
                make.bottom.mas_equalTo(cell.contentView.mas_bottom);
                make.top.mas_equalTo(cell.contentView.mas_top);
                make.right.mas_equalTo(cell.contentView.mas_right).with.offset(-12);
            }];
            _nicknameLabel.text = [KSUser currentUser].nickname;
        }
            break;
        case 2: {
            cell.textLabel.text = @"性别";
            KSUser *user = [KSUser currentUser];
            [cell.contentView addSubview:_genderLabel];
            [_genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(200);
                make.bottom.mas_equalTo(cell.contentView.mas_bottom);
                make.top.mas_equalTo(cell.contentView.mas_top);
                make.right.mas_equalTo(cell.contentView.mas_right).with.offset(-12);
            }];
            if ([user.gender integerValue] == 0)
                _genderLabel.text = @"男";
            else
                _genderLabel.text = @"女";
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)return 100;
    else return 44;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    [picker dismissViewControllerAnimated:true completion:nil];

    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];

    if (imageURL != nil) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image];
        imageCropVC.delegate = self;
        imageCropVC.dataSource = self;
        imageCropVC.cropMode = RSKImageCropModeCircle;
        [self.navigationController pushViewController:imageCropVC animated:YES];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:true completion:nil];
}

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveCroopedToSandBox:(UIImage *)croppedImage {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filename = [NSString stringWithFormat:@"%@.jpg", [KSUtil getUUIDString]];
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];   // 保存文件的名称
    BOOL result = [UIImagePNGRepresentation(croppedImage) writeToFile:filePath atomically:YES];

    if (result) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].labelText = @"头像正在上传中";
        [self.navigationController popViewControllerAnimated:YES];
        NSString *sandBoxPath = [NSString stringWithFormat:@"%@%@", KS_SANDBOX, filename];
        ImageUploader *imageUploader = [[ImageUploader alloc] init];
        imageUploader.imagePath = sandBoxPath;
        imageUploader.action = 3;
        [imageUploader beginUploadImageWithSuccessBlock:^(NSString *url) {
            [KSUser currentUser].avatar = url;
            [[KSUser currentUser] ks_saveOrUpdate];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadAvatarComplete" object:url];
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [_tableView beginUpdates];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            [_tableView endUpdates];
        }                               andFailureBlock:^{
            KSError(@"天了噜！出现了一个错误！");
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        }];
    }

    else {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect {
    [self saveCroopedToSandBox:croppedImage];
}


- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
                  rotationAngle:(CGFloat)rotationAngle {

    [self saveCroopedToSandBox:croppedImage];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller
                  willCropImage:(UIImage *)originalImage {


}

- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller {
    return CGRectZero;
}

- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller {
    return nil;
}

@end
