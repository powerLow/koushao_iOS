//
//  InternalPhotoSlectorViewController.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/16.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewController.h"
#import "RSKImageCropViewController.h"
@protocol InternalPhotoSlectorViewControllerDelegate <NSObject>
@required
- (void)onImageSelectFinished:(NSString*)cropedimagePath withOriginPath:(NSString*)originPath;
@optional
@end

@interface InternalPhotoSlectorViewController : KSViewController<UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,RSKImageCropViewControllerDataSource,RSKImageCropViewControllerDelegate>
@property(nonatomic,assign)NSInteger aspectX;
@property(nonatomic,assign)NSInteger aspectY;
@property(nonatomic,assign)RSKImageCropMode cropMode;
@property(nonatomic,strong) id<InternalPhotoSlectorViewControllerDelegate> delegate;
@end


