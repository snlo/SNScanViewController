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

#import "ViewModelSNScan.h"

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
    
    
}
- (void)handleButton:(UIButton *)sender {
    
//    ViewModelSNScan * viewmoel = [[ViewModelSNScan alloc] init];
//
//    UIImage * image = [UIImage imageNamed:@"屏幕快照 2018-07-31 上午9.14.16"];
//
//    [viewmoel handel:image];
//
//    return;
    
    SNScanViewController * VC = [SNScanViewController scanViewController];
    
    VC.viewScan.durationScan = 1.5;
//    VC.viewScan.sizeScan = CGSizeMake(100, 100); // xx
    VC.viewScan.colorScan = [UIColor redColor]; //xx
    
    [VC scanedBlock:^(NSString *scanedValue) {
        [VC dismissViewControllerAnimated:YES completion:^{
            [sender setTitle:scanedValue forState:UIControlStateNormal];
        }];
    } canceledBlock:^{
        [VC dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:VC animated:YES completion:nil];
}



@end
