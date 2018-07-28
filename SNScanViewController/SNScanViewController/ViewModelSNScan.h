//
//  ViewModelSNScan.h
//  SNScanViewController
//
//  Created by snlo on 2018/7/28.
//  Copyright © 2018年 snlo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

typedef void(^CanceledBlock)(void);
typedef void(^ScanedBlock)(NSString * scanValue);

@interface ViewModelSNScan : NSObject <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;

@property (nonatomic, copy) CanceledBlock canceledBlock;
@property (nonatomic, copy) ScanedBlock scanedBlock;

/**
 开启闪光灯
 */
- (void)onTorch;

/**
 关闭闪关灯
 */
- (void)offTorch;

@end
