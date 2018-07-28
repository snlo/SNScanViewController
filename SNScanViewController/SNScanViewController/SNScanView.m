//
//  SNScanView.m
//  SNScanViewController
//
//  Created by snlo on 2018/7/28.
//  Copyright © 2018年 snlo. All rights reserved.
//

#import "SNScanView.h"

#import "SNScanTool.h"

#import <Masonry.h>

@interface SNScanView ()

@property (nonatomic, strong) UIView *viewBackgroud;

@property (nonatomic, strong) UIView * viewBar;

@property (nonatomic, strong) UIView * viewScanSuper;

@property (nonatomic, assign) CGSize scanSize;

@end

@implementation SNScanView

+ (instancetype)scanViewWithScanSize:(CGSize)scanSize {
    return [[self alloc] initWithScanSize:scanSize];
}

- (instancetype)initWithScanSize:(CGSize)scanSize
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SNSACN_SCREEN_WIDTH, SNSACN_SCREEN_HIGHT);
        self.scanSize = scanSize;
        self.viewBackgroud = [[UIView alloc] init];
        self.viewBackgroud.frame = self.bounds;
        self.viewBackgroud.backgroundColor = [SNTool colorWithHexString:@"#4a4a4a"];
        [self addSubview:self.viewBackgroud];
        
        [self configureViewBar];
        [self configureViewScan];
        [self configureLabel];
        
        CGFloat spacing = 4.000f/289.000f * (SNSACN_SCREEN_WIDTH-108.000f);
        CGFloat width = (SNSACN_SCREEN_WIDTH-108.000f) - spacing*2;
        
        [SNScanTool scanAddMaskToView:self.viewBackgroud withRoundedRect:CGRectMake((SNSACN_SCREEN_WIDTH-width)/2, (SNSACN_SCREEN_HIGHT-width)/2, width, width) cornerRadius:0];
        
        [self configureViewLine];
        
        [self.viewTopLine.layer addAnimation:[self scaleAnimationformValue:0 toValue:width] forKey:nil];
    }
    return self;
}

- (void)configureViewBar {
    self.viewBar = ({
        UIView * view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, SNSACN_SCREEN_WIDTH, kStatusBarAndNavigationBarHeight);
        [self.viewBackgroud addSubview:view];
        view;
    });
    
    self.buttonCancel = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"SNScanView_return_three"] forState:UIControlStateNormal];
        [self.viewBar addSubview:button];
        button;
    });
    self.buttonTouch = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"SNScanView_turn_on_the_light"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"SNScanView_turn_off_the_light"] forState:UIControlStateSelected];
        [self.viewBar addSubview:button];
        button;
    });
    self.buttonAlbum = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"SNScanView_photo_album"] forState:UIControlStateNormal];
        [self.viewBar addSubview:button];
        button;
    });
    
    
    [self.buttonCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewBar.mas_leftMargin).offset(0);
        make.bottom.equalTo(self.viewBar.mas_bottom).offset(0);
        make.width.offset(44);
        make.height.offset(44);
    }];
    [self.buttonAlbum mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.viewBar.mas_right).offset(-12);
        make.bottom.equalTo(self.viewBar.mas_bottom).offset(0);
        make.width.offset(44);
        make.height.offset(44);
    }];
    [self.buttonTouch mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.buttonAlbum.mas_left).offset(-22);
        make.bottom.equalTo(self.viewBar.mas_bottom).offset(0);
        make.width.offset(44);
        make.height.offset(44);
    }];
}

- (void)configureViewScan {
    self.viewScan = ({
        UIView * view = [[UIView alloc] init];
        view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"SNScanViewFrame"].CGImage);
        [self addSubview:view];
        view;
    });
    
    CGFloat spacing = 4.000f/289.000f * (SNSACN_SCREEN_WIDTH-108.000f);
    
    
    self.viewScanSuper = ({
        UIView * view = [[UIView alloc] init];
        view.layer.masksToBounds = YES;
        [self.viewScan addSubview:view];
        view;
    });
    
    [self.viewScan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.viewScan.mas_width).multipliedBy(1);
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(54);
        make.right.equalTo(self.mas_right).offset(-54);
    }];
    [self.viewScanSuper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewScan.mas_top).offset(spacing);
        make.left.equalTo(self.viewScan.mas_left).offset(spacing);
        make.bottom.equalTo(self.viewScan.mas_bottom).offset(-spacing);
        make.right.equalTo(self.viewScan.mas_right).offset(-spacing);
    }];
    
}

- (void)configureViewLine {
    UIImage * imageTop = [UIImage imageNamed:@"SNScanView_scanning_one"];
    UIImage * imageBottom = [UIImage imageNamed:@"SNScanView_scanning_two"];
    self.viewTopLine = ({
        UIView * view = [[UIView alloc] init];
        view.layer.contents = (__bridge id _Nullable)(imageTop.CGImage);
        [self.viewScanSuper addSubview:view];
        view;
    });
    self.viewBottomLine = ({
        UIView * view = [[UIView alloc] init];
        view.layer.contents = (__bridge id _Nullable)(imageBottom.CGImage);
        [self.viewScanSuper addSubview:view];
        view;
    });
    
    [self.viewTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.viewScanSuper.mas_top).offset(0);
        make.left.equalTo(self.viewScanSuper.mas_left).offset(0);
        make.right.equalTo(self.viewScanSuper.mas_right).offset(-0);
        make.height.offset(imageTop.size.height);
    }];
    [self.viewBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewScanSuper.mas_bottom).offset(0);
        make.left.equalTo(self.viewScanSuper.mas_left).offset(0);
        make.right.equalTo(self.viewScanSuper.mas_right).offset(-0);
        make.height.offset(imageBottom.size.height);
    }];
    
    
}

- (void)configureLabel {
    
    self.labelTitle = ({
        UILabel * label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:22 weight:UIFontWeightMedium];
        label.text = @"扫描二维码";
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [self.viewBackgroud addSubview:label];
        label;
    });
    self.labelPrompt = ({
        UILabel * label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"将二维码置于框内即自动扫描";
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [self.viewBackgroud addSubview:label];
        label;
    });
    
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.bottom.equalTo(self.viewScanSuper.mas_top).offset(-30);
    }];
    [self.labelPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(self.viewScanSuper.mas_bottom).offset(30);
    }];
}

- (CGFloat)fetchSpacing {
    return 4.000f/289.000f * (SNSACN_SCREEN_WIDTH-108.000f);
}
//- (CGFloat)width {
//    return <#expression#>
//}

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

@end
