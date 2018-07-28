//
//  ViewModelSNScan.m
//  SNScanViewController
//
//  Created by snlo on 2018/7/28.
//  Copyright © 2018年 snlo. All rights reserved.
//

#import "ViewModelSNScan.h"

#import "SNScanTool.h"

@interface ViewModelSNScan ()

@property (nonatomic, strong) NSString * stringScaned;

@end

@implementation ViewModelSNScan

- (void)scanedBlock:(void (^)(NSString *))block {
    if (block) {
        block(self.stringScaned);
    }
}

- (void)onTorch {
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    if ([captureDevice hasTorch]) {
        BOOL locked = [captureDevice lockForConfiguration:&error];
        if (locked) {
            captureDevice.torchMode = AVCaptureTorchModeOn;
            [captureDevice unlockForConfiguration];
        }
    }
}
- (void)offTorch {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
}

- (void)playBeepPath:(NSString *)path {
    SystemSoundID sound = kSystemSoundID_Vibrate;
    if (path) {
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
        if (error != kAudioServicesNoError) {
            sound = 0;
        }
    }
    AudioServicesPlaySystemSound(1002);//播放声音
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//静音模式下震动
}

- (CABasicAnimation *)scaleAnimationformValue:(CGFloat)fromValue toValue:(CGFloat)toValue {
    CABasicAnimation *animation;
    animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.duration = 2;
    animation.fromValue = [NSNumber numberWithFloat:fromValue];
    animation.toValue = [NSNumber numberWithFloat:toValue];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = YES;
    animation.repeatCount = MAXFLOAT;
    return animation;
}

#pragma mark -- <AVCaptureMetadataOutputObjectsDelegate>、、
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString * stringValue = @"";
    if ([metadataObjects count] > 0) {
        // 停止扫描
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        if (self.scanedBlock) {
            [self playBeepPath:[NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",@"new-mail",@"caf"]];
            self.scanedBlock(stringValue);
        }
        [self.session stopRunning];
        
//        [self.line.layer removeAllAnimations];
    }
}
#pragma mark -- getter / setter
- (AVCaptureSession *)session {
    if (!_session) {
        
        AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        
        AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc] init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        _session = [[AVCaptureSession alloc] init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([_session canAddInput:input]) {
            [_session addInput:input];
        }
        if ([_session canAddOutput:output]){
            [_session addOutput:output];
        }
        
        //相机权限
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
            authStatus == AVAuthorizationStatusDenied) { //用户已经明确否认了这一照片数据的应用程序访问
            // 无权限 引导去开启
            [SNTool showAlertStyle:UIAlertControllerStyleAlert title:@"提示" msg:@"没有相机访问权限，是否去设置中开启" chooseBlock:^(NSInteger actionIndx) {
                if (actionIndx == 1) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:nil];
                    }
                }
            } actionsStatement:@"取消",@"确认", nil];
        } else if (authStatus == AVAuthorizationStatusNotDetermined) {
            [SNTool showAlertStyle:UIAlertControllerStyleAlert title:nil msg:@"当前设备不支持相机模式" chooseBlock:nil actionsStatement:@"确定", nil];
        } else {
            NSMutableArray *types =
            [NSMutableArray arrayWithArray:@[AVMetadataObjectTypeUPCECode,
                                             AVMetadataObjectTypeCode39Code,
                                             AVMetadataObjectTypeCode39Mod43Code,
                                             AVMetadataObjectTypeEAN13Code,
                                             AVMetadataObjectTypeEAN8Code,
                                             AVMetadataObjectTypeCode93Code,
                                             AVMetadataObjectTypeCode128Code,
                                             AVMetadataObjectTypePDF417Code,
                                             AVMetadataObjectTypeQRCode,
                                             AVMetadataObjectTypeAztecCode]];
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                [types addObject:AVMetadataObjectTypeInterleaved2of5Code];
                [types addObject:AVMetadataObjectTypeITF14Code];
                [types addObject:AVMetadataObjectTypeDataMatrixCode];
            }
            
            output.metadataObjectTypes = types;
        }
        
    } return _session;
}
- (AVCaptureVideoPreviewLayer *)preview {
    if (!_preview) {
        _preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _preview.frame = CGRectMake(0, 0, SNSACN_SCREEN_WIDTH, SNSACN_SCREEN_HIGHT);
    } return _preview;
}

@end
