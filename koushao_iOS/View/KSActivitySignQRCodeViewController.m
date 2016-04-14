//
//  KSActivitySignQRCodeViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/7.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivitySignQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"
#import "KSActivitySignQRCodeViewModel.h"
@interface KSActivitySignQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic)  UIView *viewPreview;
@property (strong, nonatomic)  UILabel *lblStatus;

@property (strong, nonatomic) UIImageView *boxView;
@property (nonatomic) BOOL isReading;
@property (strong, nonatomic) CALayer *scanLayer;
//捕捉会话
@property (nonatomic, strong) AVCaptureSession *captureSession;
//展示layer
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic, copy) NSString *result;

@property (nonatomic,assign) BOOL flash_on;


@property (nonatomic,strong) KSActivitySignQRCodeViewModel *viewModel;

@end

@implementation KSActivitySignQRCodeViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:view];
    
    
    @weakify(self)
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
    
    _viewPreview = view;
    
    [self startReading];
    
    [[[RACObserve(self, result) takeUntil:self.rac_willDeallocSignal]
      throttle:1]
     subscribeNext:^(NSString *x) {
         if (x != nil){
             NSLog(@"扫描结果 = %@" , x);
             [self.viewModel.requestRemoteDataCommand execute:x];
         }
     }];
    
    [self.viewModel.requestRemoteDataCommand.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self)
        if (executing.boolValue) {
            _isReading = NO;
            [_captureSession stopRunning];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = @"验证中...";
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
             _isReading = YES;
        }
    }];
    [self.viewModel.requestRemoteDataCommand.errors subscribeNext:^(NSError *x) {
        NSLog(@"二维码验证出错 = %@",x);
        if (x.code == KSInstantErrorTicketNotFound) {
            KSError(@"验证失败:没有找到该验证码");
            
        }else{
            [KSUtil filterError:x params:nil];
        }
        [KSUtil runAfterSecs:1.0 block:^{
            [_captureSession startRunning];
        }];
    }];
}
-(void)viewWillAppear:(BOOL)animated {
    if (_captureSession) {
        if (!_captureSession.isRunning) {
            [_captureSession startRunning];
        }
        
    }
}
- (void)dealloc {
    [self stopReading];
}
#pragma mark -
- (BOOL)startReading {
    NSError *error;
    
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    //4.实例化捕捉会话
    _captureSession = [[AVCaptureSession alloc] init];
    
    //4.1.将输入流添加到会话
    [_captureSession addInput:input];
    
    //4.2.将媒体输出流添加到会话中
    [_captureSession addOutput:captureMetadataOutput];
    
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    //5.1.设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    //5.2.设置输出媒体数据类型为QRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    //6.实例化预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
    //7.设置预览图层填充方式
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //8.设置图层的frame
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    
    //9.将图层添加到预览view的图层上
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    //10.设置扫描范围
    captureMetadataOutput.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.8f, 0.8f);
    
    //10.1.扫描框
//    _boxView = [[UIView alloc] initWithFrame:CGRectMake(_viewPreview.bounds.size.width * 0.2f, _viewPreview.bounds.size.height * 0.2f, _viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.4f, _viewPreview.bounds.size.height - _viewPreview.bounds.size.height * 0.4f)];
//    _boxView.layer.borderColor = [UIColor greenColor].CGColor;
//    _boxView.layer.borderWidth = 1.0f;
    _boxView = [UIImageView new];
    [_viewPreview addSubview:_boxView];
    _boxView.image = [UIImage imageNamed:@"scan_bg"];
    
    @weakify(self)
    [_boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(30);
        make.height.width.equalTo(self.view.mas_width).multipliedBy(0.8);
    }];
    
    
    //10.2.扫描线
    _scanLayer = [[CALayer alloc] init];
    _scanLayer.frame = CGRectMake(SCREEN_WIDTH*0.1/2, 0, SCREEN_WIDTH*0.7, 1);
    _scanLayer.backgroundColor = HexRGB(0x00ff33).CGColor;
    
    [_boxView.layer addSublayer:_scanLayer];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    
    [timer fire];
    
    //提示文字
    UILabel *label = [UILabel new];
    label.text = @"将二维码放入框内,即可自动扫描";
    label.font = KS_SMALL_FONT;
    label.textAlignment = NSTextAlignmentCenter;
    [_viewPreview addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.centerX.equalTo(self.view);
        make.top.equalTo(_boxView.mas_bottom).offset(5);
    }];
    
    //下面部分
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor blackColor];
    bottomView.alpha = 0.3;
    [_viewPreview addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.right.equalTo(_viewPreview);
        make.bottom.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.25);
    }];
    //开灯按钮
    UIButton *button = [UIButton new];
    [button setImage:[UIImage imageNamed:@"flash_on"] forState:UIControlStateNormal];
    [bottomView addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(bottomView);
        make.width.height.equalTo(bottomView.mas_height).multipliedBy(0.4);
    }];
    
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (!_flash_on) {
            _flash_on = YES;
            [button setImage:[UIImage imageNamed:@"flash_off"] forState:UIControlStateNormal];
        }else{
            _flash_on = NO;
            [button setImage:[UIImage imageNamed:@"flash_on"] forState:UIControlStateNormal];
        }
        [self Flashlight];
    }];
    
    //10.开始扫描
    [_captureSession startRunning];
    _isReading = YES;
    return YES;
}

- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = _scanLayer.frame;
    if (_boxView.frame.size.height < _scanLayer.frame.origin.y+5) {
        frame.origin.y = 0;
        _scanLayer.frame = frame;
    }else{
        
        frame.origin.y += 5;
        
        [UIView animateWithDuration:0.1 animations:^{
            _scanLayer.frame = frame;
        }];
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0 && _isReading == YES) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            _isReading = NO;
            self.result = [metadataObj stringValue];
            
        }
    }
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_scanLayer removeFromSuperlayer];
    [_videoPreviewLayer removeFromSuperlayer];
}


#pragma makr - 闪光灯
-(void)Flashlight
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![device hasTorch]) {
        NSLog(@"no torch");
    }else{
        [device lockForConfiguration:nil];
        if (_flash_on) {
            [device setTorchMode: AVCaptureTorchModeOn];
        }
        else
        {
            [device setTorchMode: AVCaptureTorchModeOff];
        }
        
        [device unlockForConfiguration];
    }
}



@end
