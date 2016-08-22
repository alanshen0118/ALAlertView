//
//  ALAlertView.m
//  Sollair
//
//  Created by alan on 8/8/16.
//  Copyright © 2016 bjdv. All rights reserved.
//

#import "ALAlertView.h"
#define kIOS9_OR_LATER ( [[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending )

@interface ALAlertView ()

@property (copy, nonatomic) CancelCallBack cancelCallBack;

@property (copy, nonatomic) OtherCallBack otherCallBack;

@end

@implementation ALAlertView

+ (instancetype)alertView {
    return [[[self class] alloc] init];
}

#pragma mark - public method
#pragma mark -- class method
/**
 *  类方法  提示框（只显示消息）
 *
 *  @param message 消息
 */
+ (void)showMessage:(NSString *)message {
    [[[self class] alertView] showMessage:message];
}

/**
 *  类方法  提示框（只显示标题和消息）
 *
 *  @param title   标题
 *  @param message 消息
 */
+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message {
    [[[self class] alertView] showAlertViewWithTitle:title message:message];
}

/**
 *  类方法  提示框（只显示标题和消息）
 *
 *  @param title   标题
 *  @param message 消息
 *  @param dismissCallBack 确定回调
 */
+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message dismissCallBack:(CancelCallBack)dismissCallBack {
    [[[self class] alertView] showAlertViewWithTitle:title message:message dismissCallBack:dismissCallBack];
}

#pragma mark -- object method
/**
 *  提示框（只显示消息）
 *
 *  @param message 消息
 */
- (void)showMessage:(NSString *)message {
    [self showAlertViewWithTitle:nil message:message];
}

/**
 *  提示框（只显示标题和消息）
 *
 *  @param title   标题
 *  @param message 消息
 */
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message {
    [self showAlertViewWithTitle:title message:message cancelButtonTitle:@"确定" cancelCallBack:nil otherCallBack:nil otherButtonTitles:nil];
}

/**
 *  提示框（只显示标题和消息）
 *
 *  @param title   标题
 *  @param message 消息
 *  @param dismissCallBack 确定回调
 */
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message dismissCallBack:(CancelCallBack)dismissCallBack {
    [self showAlertViewWithTitle:title message:message cancelButtonTitle:@"确定" cancelCallBack:dismissCallBack otherCallBack:nil otherButtonTitles:nil, nil];
}


#pragma mark -- base method
/**
 *  提示框基础方法
 *
 *  @param title             标题
 *  @param message           消息
 *  @param cancelButtonTitle 取消按钮标题
 *  @param cancelCallBack    取消按钮回调
 *  @param otherCallBack     其他按钮回调
 *  @param otherButtonTitles 其他按钮
 */
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle cancelCallBack:(CancelCallBack)cancelCallBack otherCallBack:(OtherCallBack)otherCallBack otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_9_0
    //初始化AlertController
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //定义va_list
    va_list argsList;
    //指向首地址
    va_start(argsList, otherButtonTitles);
    NSInteger index = 0;
    //遍历
    while (otherButtonTitles) {
        //过滤入参类型
        if (![otherButtonTitles isKindOfClass:[NSString class]]) {
            break;
        }
        //过滤空字符串
        if (![self isBlankString:otherButtonTitles]) {
            //添加提示框按钮动作
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:otherButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (otherCallBack) {
                    [alertViewController dismissViewControllerAnimated:YES completion:nil];
                    otherCallBack(index);
                }
            }];
            [alertViewController addAction:alertAction];
        }
        //指向下一个地址
        otherButtonTitles = va_arg(argsList, NSString *);
        index++;
    }
    va_end(argsList);
    
    //取消按钮
    if (![self isBlankString:cancelButtonTitle]) {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //点击过后关闭提示框
            if (cancelCallBack) {
                [alertViewController dismissViewControllerAnimated:YES completion:nil];
                //取消回调方法
                cancelCallBack();
            }
        }];
        [alertViewController addAction:alertAction];
    }
    //从当前控制器中模态弹出提示框
    [[self getCurrentViewController] presentViewController:alertViewController animated:YES completion:nil];
    
#else
    if (kIOS9_OR_LATER) {
        UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        va_list argsList;
        va_start(argsList, otherButtonTitles);
        NSInteger index = 0;
        while (otherButtonTitles) {
            if (![otherButtonTitles isKindOfClass:[NSString class]]) {
                break;
            }
            if (![self isBlankString:otherButtonTitles]) {
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:otherButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if (otherCallBack) {
                        [alertViewController dismissViewControllerAnimated:YES completion:nil];
                        otherCallBack(index);
                    }
                }];
                [alertViewController addAction:alertAction];
            }
            otherButtonTitles = va_arg(argsList, NSString *);
            index++;
        }
        va_end(argsList);
        if (![self isBlankString:cancelButtonTitle]) {
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (cancelCallBack) {
                    [alertViewController dismissViewControllerAnimated:YES completion:nil];
                    cancelCallBack();
                }
            }];
            [alertViewController addAction:alertAction];
        }
        
        [[self getCurrentViewController] presentViewController:alertViewController animated:YES completion:nil];
    } else {
        self.cancelCallBack = [cancelCallBack copy];
        self.otherCallBack = [otherCallBack copy];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        va_list argsList;
        va_start(argsList, otherButtonTitles);
        NSInteger index = 0;
        while (otherButtonTitles) {
            if (![self isBlankString:otherButtonTitles]) {
                [alertView addButtonWithTitle:otherButtonTitles];
            }
            otherButtonTitles = va_arg(argsList, NSString *);
            index++;
        }
        va_end(argsList);
        
        [alertView show];
    }
    
#endif
}

#pragma mark - System Delegate
#pragma mark -- UIAlertViewDelegete
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_9_0
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger otherButtonIndex = 0;
    if (alertView.cancelButtonIndex == 0) {
        if (buttonIndex == 0) {
            if (self.cancelCallBack) {
                self.cancelCallBack();
            }
            return;
        }
        otherButtonIndex = buttonIndex - 1;
    }
    if (self.otherCallBack) {
        self.otherCallBack(otherButtonIndex);
    }
    
}
#endif

#pragma mark - Utils
/**
 *  判断空字符串
 *
 *  @param string 字符串
 *
 *  @return 是否为空
 */
- (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

/**
 *  获取当前视图控制器
 *
 *  @return 当前视图控制器
 */
- (UIViewController *)getCurrentViewController
{
    UIViewController *currentViewController = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    if ([window subviews].count == 0) {
        return nil;
    }
    
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * subWindow in windows)
        {
            if (subWindow.windowLevel == UIWindowLevelNormal) {
                window = subWindow;
                break;
            }
        }
    }

    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        currentViewController = nextResponder;
    } else {
        currentViewController = window.rootViewController;
    }
    return currentViewController;
}
@end
