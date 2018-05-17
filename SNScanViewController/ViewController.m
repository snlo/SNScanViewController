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
    
}
- (void)handleButton:(UIButton *)sender {
    
    SNScanViewController * VC = [SNScanViewController scanViewController];
    
    VC.themeColor = [UIColor redColor];
    VC.scanLineColor = [UIColor blueColor];
    VC.backgroudStyle = UIBarStyleDefault;
    
    [self presentViewController:VC animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
