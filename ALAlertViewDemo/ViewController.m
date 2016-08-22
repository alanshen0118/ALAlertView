//
//  ViewController.m
//  ALAlertViewDemo
//
//  Created by alan on 8/22/16.
//  Copyright © 2016 bjdv. All rights reserved.
//

#import "ViewController.h"
#import "ALAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[ALAlertView alertView] showMessage:@"建议在界面完成加载后调用"];
}
- (IBAction)e__message:(id)sender {
    XXALERT(@"消息");
    
//    [ALAlertView showMessage:@"消息"];
//    [[ALAlertView alertView] showMessage:@"消息"];
}

- (IBAction)e__messageAndTitle:(id)sender {
    
    [[ALAlertView alertView] showAlertViewWithTitle:@"标题" message:@"消息"];
}

- (IBAction)e__mutiButtons:(id)sender {
    [[ALAlertView alertView] showAlertViewWithTitle:@"标题" message:@"消息" cancelButtonTitle:@"取消" cancelCallBack:^{
        NSLog(@"cancel回调");
    } otherCallBack:^(NSInteger buttonIndex) {
        NSLog(@"第%zi个按钮回调", buttonIndex + 1);
    } otherButtonTitles:@"按钮1", @"按钮2", @"按钮3", nil];
}

- (IBAction)e__mutiAlertWithoutOverlay:(id)sender {
    [ALAlertView showAlertViewWithTitle:nil message:@"第一条信息" dismissCallBack:^{
        [[ALAlertView alertView] showMessage:@"第二条消息"];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
