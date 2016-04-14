//
//  KSActivityItemTableViewCell.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/15.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityItemTableViewCell.h"
#import "KSActivityListItemViewModel.h"
#import <YYWebImage.h>
@interface KSActivityItemTableViewCell()

@property (nonatomic, strong) KSActivityListItemViewModel *viewModel;
@property (strong, nonatomic) IBOutlet UIImageView *posterView;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *visistContLabel;
@property (strong, nonatomic) IBOutlet UILabel *enrollCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyCountLabel;

@end
@implementation KSActivityItemTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma -KSReactiveView

- (void)bindViewModel:(KSActivityListItemViewModel *)viewModel {
    self.viewModel = viewModel;
    self.titleLabel.text = viewModel.activity.title;
    self.visistContLabel.text = [NSString stringWithFormat:@"%@",viewModel.activity.visits];
    self.moneyCountLabel.text = [NSString stringWithFormat:@"%@",viewModel.activity.totalmoney];
    self.enrollCountLabel.text = [NSString stringWithFormat:@"%@",viewModel.activity.enroll];
    //活动时间
    NSDate* startTime = [NSDate dateWithTimeIntervalSince1970:[viewModel.activity.startTime unsignedIntegerValue]];
    NSDateFormatter *ft = [NSDateFormatter new];
    if (viewModel.activity.isday) {
        ft.dateFormat = @"yyyy-MM-dd 全天";
    }else{
        ft.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    NSString *strStartTime = [ft stringFromDate:startTime];
    self.timeLabel.text = strStartTime;
    
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970];
    if (![viewModel.activity.endTime  isEqual:@0] &&  nowtime > [viewModel.activity.endTime unsignedIntegerValue]) {
        viewModel.activity.status = KSActivityStatusEnd;
    }
    //活动状态
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    switch (viewModel.activity.status) {
        case KSActivityStatusStart:
        {
            self.statusLabel.text = @"进行中";
            self.statusLabel.textColor = BASE_COLOR;
        }
            break;
        case KSActivityStatusReady:
        {
            self.statusLabel.text = @"未发布";
        }
            break;
        case KSActivityStatusEnd:
        {
            self.statusLabel.text = @"已结束";
            self.statusLabel.textColor = [UIColor orangeColor];
        }
            break;
        default:
            break;
    }
    
    //活动图片
    self.posterView.layer.masksToBounds = YES;
    self.posterView.layer.cornerRadius = self.posterView.frame.size.width / 2;
    self.posterView.image = KS_GrayColor_BackColor.color2Image;
    NSString *defaultUrl = viewModel.activity.poster;
    if ([defaultUrl length] == 0) {
        defaultUrl = viewModel.activity.cover_pic;
    }
    //加载缩略图
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",defaultUrl,@"?imageView2/0/h/70"];
    NSURL *url = [[NSURL alloc] initWithString:imageUrl];
//    [self.posterView sd_setImageWithURL:url];
    
    [self.posterView yy_setImageWithURL:url
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
                           self.viewModel.activity.thumbnail = image;
                       }];
//    self.viewModel.activity.thumbnail = self.posterView.image;
    self.accessoryType = UITableViewCellAccessoryNone;
}

@end
