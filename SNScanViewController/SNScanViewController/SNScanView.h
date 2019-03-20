//
//  SNScanView.h
//  SNScanViewController
//
//  Created by snlo on 2018/7/28.
//  Copyright © 2018年 snlo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNScanView : UIView

+ (instancetype)scanViewWithScanSize:(CGSize)scanSize;

@property (nonatomic, strong) UIButton * buttonCancel;

@property (nonatomic, strong) UIButton * buttonTouch;

@property (nonatomic, strong) UIButton * buttonAlbum;


@property (nonatomic, strong) UIView * viewBackgroud;

@property (nonatomic, strong) UIView * viewBar;

@property (nonatomic, strong) UIView * viewScan;

@property (nonatomic, strong) UIImageView * imageViewTopLine;

@property (nonatomic, strong) UIImageView * imageViewBottomLine;

@property (nonatomic, strong) UILabel * labelTitle;

@property (nonatomic, strong) UILabel * labelPrompt;


@property (nonatomic, assign) CFTimeInterval durationScan;
@property (nonatomic, strong) UIColor * colorScan;
@property (nonatomic, assign) CGSize sizeScan;

- (void)startAnimation;
- (void)stopAnimation;

@end
