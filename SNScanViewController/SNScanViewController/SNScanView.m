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

@property (nonatomic, strong) UIView * viewScanSuper;

@property (nonatomic, strong) CABasicAnimation * topLineAnimation;
@property (nonatomic, strong) CABasicAnimation * bottomLineAnimation;

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
        self.sizeScan = scanSize;
        self.colorScan = [SNTool colorWithHexString:@"#D9AD65" alpha:1.0f];
        self.durationScan = 1.5;
        self.viewBackgroud = [[UIView alloc] init];
        self.viewBackgroud.frame = self.bounds;
        self.viewBackgroud.backgroundColor = [SNTool colorWithHexString:@"#4a4a4a" alpha:0.5f];
        [self addSubview:self.viewBackgroud];
        
        [self configureViewBar];
        [self configureViewScan];
        [self configureLabel];
        
        CGFloat width = [self fetchWidth];
        CGFloat height = [self fetchHeight];
        
        [SNScanTool scanAddMaskToView:self.viewBackgroud withRoundedRect:CGRectMake((SNSACN_SCREEN_WIDTH-width)/2, (SNSACN_SCREEN_HIGHT-height)/2, width, height) cornerRadius:0];
        
        [self configureViewLine];
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
        [button setImage:[UIImage imageNamed:@"SNScanView_turn_off_the_light"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"SNScanView_turn_on_the_light"] forState:UIControlStateSelected];
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
        make.left.equalTo(self.viewBar.mas_left).offset(16);
        make.bottom.equalTo(self.viewBar.mas_bottom).offset(0);
        make.width.offset(44);
        make.height.offset(44);
    }];
    [self.buttonAlbum mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.viewBar.mas_right).offset(-16);
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
        view.layer.borderColor = (__bridge CGColorRef _Nullable)(self.colorScan);
        view.layer.borderWidth = 1;
        view.backgroundColor = self.colorScan;
        [self.viewBackgroud addSubview:view];
        view;
    });
    
    UIView * leftTop = ({
        UIView * view = [[UIView alloc] init];
        view.backgroundColor = self.colorScan;
        [self.viewBackgroud addSubview:view];
        view;
    });
    UIView * reightTop = ({
        UIView * view = [[UIView alloc] init];
        view.backgroundColor = self.colorScan;
        [self.viewBackgroud addSubview:view];
        view;
    });;
    UIView * leftBottom = ({
        UIView * view = [[UIView alloc] init];
        view.backgroundColor = self.colorScan;
        [self.viewBackgroud addSubview:view];
        view;
    });;
    UIView * rightBottom = ({
        UIView * view = [[UIView alloc] init];
        view.backgroundColor = self.colorScan;
        [self.viewBackgroud addSubview:view];
        view;
    });;
    
    [leftTop mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(20);
        make.height.offset(20);
        make.top.equalTo(self.viewScan.mas_top).offset(-3);
        make.left.equalTo(self.viewScan.mas_left).offset(-3);
    }];
    [reightTop mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(20);
        make.height.offset(20);
        make.top.equalTo(self.viewScan.mas_top).offset(-3);
        make.right.equalTo(self.viewScan.mas_right).offset(3);
    }];
    [leftBottom mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(20);
        make.height.offset(20);
        make.left.equalTo(self.viewScan.mas_left).offset(-3);
        make.bottom.equalTo(self.viewScan.mas_bottom).offset(3);
    }];
    [rightBottom mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(20);
        make.height.offset(20);
        make.right.equalTo(self.viewScan.mas_right).offset(3);
        make.bottom.equalTo(self.viewScan.mas_bottom).offset(3);
    }];
    
    
    CGFloat spacing = [self fetchSpacing];
    
    
    self.viewScanSuper = ({
        UIView * view = [[UIView alloc] init];
        view.layer.masksToBounds = YES;
        [self addSubview:view];
        view;
    });
    
    [self.viewScan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
        make.width.offset(self.sizeScan.width);
        make.height.offset(self.sizeScan.height);
    }];
    [self.viewScanSuper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewScan.mas_top).offset(spacing);
        make.left.equalTo(self.viewScan.mas_left).offset(spacing);
        make.bottom.equalTo(self.viewScan.mas_bottom).offset(-spacing);
        make.right.equalTo(self.viewScan.mas_right).offset(-spacing);
    }];
    
}

- (void)configureViewLine {
    self.imageViewTopLine = ({
        UIImageView * view = [[UIImageView alloc] init];
        view.image = [UIImage imageNamed:@"SNScanView_scanning_one"];
        [self.viewScanSuper addSubview:view];
        view;
    });
    self.imageViewBottomLine = ({
        UIImageView * view = [[UIImageView alloc] init];
        view.image = [UIImage imageNamed:@"SNScanView_scanning_two"];
        [self.viewScanSuper addSubview:view];
        view;
    });
    
    [self.imageViewTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.viewScanSuper.mas_top).offset(0);
        make.left.equalTo(self.viewScanSuper.mas_left).offset(0);
        make.right.equalTo(self.viewScanSuper.mas_right).offset(-0);
        make.height.offset(self.imageViewTopLine.image.size.height);
    }];
    [self.imageViewBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewScanSuper.mas_bottom).offset(0);
        make.left.equalTo(self.viewScanSuper.mas_left).offset(0);
        make.right.equalTo(self.viewScanSuper.mas_right).offset(-0);
        make.height.offset(self.imageViewBottomLine.image.size.height);
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
    return 1;
}
- (CGFloat)fetchWidth {
    return self.sizeScan.width - [self fetchSpacing]*2;
}
- (CGFloat)fetchHeight {
    return self.sizeScan.height - [self fetchSpacing]*2;
}

- (void)startAnimation {
    self.topLineAnimation = [self topLineAnimationformValue:0 toValue:[self fetchWidth]+ self.imageViewTopLine.image.size.height];
    self.bottomLineAnimation = [self bottomLineAnimationformValue:0 toValue:[self fetchWidth]+ self.imageViewBottomLine.image.size.height];
    
    [self.imageViewTopLine.layer addAnimation:self.topLineAnimation forKey:nil];
    [self.imageViewBottomLine.layer addAnimation:self.bottomLineAnimation forKey:nil];
}
- (void)stopAnimation {
    [self.imageViewTopLine.layer removeAllAnimations];
    [self.imageViewBottomLine.layer removeAllAnimations];
}

- (CABasicAnimation *)topLineAnimationformValue:(CGFloat)fromValue toValue:(CGFloat)toValue {
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.duration = self.durationScan;
    animation.fromValue = [NSNumber numberWithFloat:fromValue];
    animation.toValue = [NSNumber numberWithFloat:toValue*2];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT;
    return animation;
}
- (CABasicAnimation *)bottomLineAnimationformValue:(CGFloat)fromValue toValue:(CGFloat)toValue {
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.duration = self.durationScan;
    animation.beginTime = CACurrentMediaTime() + self.durationScan/2;
    animation.fromValue = [NSNumber numberWithFloat:fromValue];
    animation.toValue = [NSNumber numberWithFloat:-toValue*2];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT;
    return animation;
}

#pragma mark -- getter / setter

- (void)setColorScan:(UIColor *)colorScan {
    _colorScan = colorScan;
}
- (void)setSizeScan:(CGSize)sizeScan {
    _sizeScan = sizeScan;
}

@end
