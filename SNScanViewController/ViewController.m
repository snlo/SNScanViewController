//
//  ViewController.m
//  SNSacnViewController
//
//  Created by snlo on 2018/5/8.
//  Copyright © 2018年 snlo. All rights reserved.
//

#import "ViewController.h"

#import "SNScanViewController.h"

#import <SNTool.h>

#import "SNScanTool.h"

#import "SNScanView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    pod trunk push SNScanViewController.podspec --verbose --allow-warnings --use-libraries
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(24, 200, 60, 60);
    [button setTitle:SNString_localized(@"测试") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    NSLog(@"%@",[SNScanTool localizedString:@"取消"]);
    self.view.backgroundColor = [UIColor blackColor];
}
- (void)handleButton:(UIButton *)sender {
    
    SNScanView * view = [SNScanView scanViewWithScanSize:CGSizeMake(SCREEN_WIDTH-108, SCREEN_WIDTH-108)];
    
    [self.view addSubview:view];


    return;
    
    SNScanViewController * VC = [SNScanViewController scanViewController];
    
    VC.themeColor = [UIColor redColor];
    VC.scanLineColor = [UIColor blueColor];
    VC.backgroudStyle = UIBarStyleDefault;
    VC.backgroudStyle = UIBarStyleBlack;
    VC.backgroudView.alpha = 0.5;
    VC.scanRect = CGRectMake(100, 100, 100, 100);
    
    [VC scanedBlock:^(NSString *scanedValue) {
        [VC dismissViewControllerAnimated:YES completion:^{

        }];
    } canceledBlock:^{
        [VC dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:VC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
