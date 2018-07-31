//
//  ViewModelSNScan.h
//  SNScanViewController
//
//  Created by snlo on 2018/7/28.
//  Copyright © 2018年 snlo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^CanceledBlock)(void);
typedef void(^ScanedBlock)(NSString * scanValue);

typedef void(^SelectedImageBlock)(UIImage * valueImage);
typedef void(^SelectedCancelBlock)(void);

@interface ViewModelSNScan : NSObject <AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;

@property (nonatomic, copy) CanceledBlock canceledBlock;
@property (nonatomic, copy) ScanedBlock scanedBlock;

@property (nonatomic, copy) SelectedImageBlock selectedImageBlock;
@property (nonatomic, copy) SelectedCancelBlock selectedCancelBlock;


/**
 开启闪光灯
 */
- (void)onTorch;

/**
 关闭闪关灯
 */
- (void)offTorch;

/**
 从相册中选
 */
- (void)selectPictureFromAlbunPhotos:(void(^)(UIImagePickerController *imagePickerController))block;

/**
 在相册中选中的图片

 @param selectedBlock 回调一张图片
 @param cancelBloc 返回的回调
 */
- (void)selectedBlock:(void(^)(UIImage *image))selectedBlock cancelBlock:(void(^)(void))cancelBloc;

/**
 识别图中二维码（清晰的可以识别）

 @param imageCode 图片源
 */
- (BOOL)scanImageQRCode:(UIImage *)imageCode;

@end
