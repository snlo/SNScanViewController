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

@property (nonatomic, strong) UIImagePickerController * imagePickerController;

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

- (void)selectPictureFromAlbunPhotos:(void(^)(UIImagePickerController *imagePickerController))block {
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    //相册权限
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied){
        //无权限 引导去开启
        [SNTool showAlertStyle:UIAlertControllerStyleAlert title:@"提示" msg:@"没有相册访问权限，是否去设置中开启" chooseBlock:^(NSInteger actionIndx) {
            if (actionIndx == 1) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES}  completionHandler:nil];
                }
            }
        } actionsStatement:@"取消",@"确认", nil];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePickerController.mediaTypes = @[mediaTypes[0]];
        if (block) {
            block(self.imagePickerController);
        }
    }
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

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc]init];
        _imagePickerController.delegate = self;
    } return _imagePickerController;
}

#pragma mark -- <UIImagePickerControllerDelegate,
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * imageSimple = [UIImage new];
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        CGFloat width = SNSACN_SCREEN_WIDTH;
        CGFloat height = SNSACN_SCREEN_WIDTH * image.size.height / image.size.width;
        imageSimple = [self imageWithImageSimple:image scaledToSize:CGSizeMake(width, height)];
    }
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    if (self.selectedImageBlock) {
        self.selectedImageBlock(imageSimple);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    if (self.selectedCancelBlock) self.selectedCancelBlock();
}

- (UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize )newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    [image drawInRect : CGRectMake ( 0 , 0 ,newSize.width ,newSize.height )];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext ();
    return newImage;
}

- (void)selectedBlock:(void(^)(UIImage *image))selectedBlock cancelBlock:(void(^)(void))cancelBlock {
    if (selectedBlock) self.selectedImageBlock = selectedBlock;
    if (cancelBlock) self.selectedCancelBlock = cancelBlock;
}

- (BOOL)scanImageQRCode:(UIImage *)imageCode {
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                              context:nil
                                              options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:imageCode.CGImage]];
    if (features.count >= 1){
        CIQRCodeFeature *feature = [features firstObject];
        if (self.scanedBlock) {
            [self playBeepPath:[NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",@"new-mail",@"caf"]];
            self.scanedBlock(feature.messageString);
        }
        return YES;
    }else{
        return NO;
    }
}

@end
