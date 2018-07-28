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


@property (nonatomic, strong) UIView * viewScan;

@property (nonatomic, strong) UIView * viewTopLine;

@property (nonatomic, strong) UIView * viewBottomLine;

@property (nonatomic, strong) UILabel * labelTitle;

@property (nonatomic, strong) UILabel * labelPrompt;

@end
