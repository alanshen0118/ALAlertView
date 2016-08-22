//
//  ALAlertView.h
//  Sollair
//
//  Created by alan on 8/8/16.
//  Copyright © 2016 bjdv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define kIOS9_OR_LATER ( [[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending )

#define XXALERT(msg) [ALAlertView showMessage:msg];

typedef void(^CancelCallBack)();
typedef void(^OtherCallBack)(NSInteger buttonIndex);

@interface ALAlertView : NSObject<UIAlertViewDelegate>

+ (instancetype)alertView;

/**
 *  类方法  提示框（只显示消息）
 *
 *  @param message 消息
 */
+ (void)showMessage:(NSString *)message;

/**
 *  类方法  提示框（只显示标题和消息）
 *
 *  @param title   标题
 *  @param message 消息
 */
+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message;

/**
 *  类方法  提示框（只显示标题和消息）
 *
 *  @param title   标题
 *  @param message 消息
 *  @param dismissCallBack 确定回调
 */
+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message dismissCallBack:(CancelCallBack)dismissCallBack;

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
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle cancelCallBack:(CancelCallBack)cancelCallBack otherCallBack:(OtherCallBack)otherCallBack otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *  提示框（只显示消息）
 *
 *  @param message 消息
 */
- (void)showMessage:(NSString *)message;

/**
 *  提示框（只显示标题和消息）
 *
 *  @param title   标题
 *  @param message 消息
 */
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message;

/**
 *  提示框（只显示标题和消息）
 *
 *  @param title   标题
 *  @param message 消息
 *  @param dismissCallBack 确定回调
 */
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message dismissCallBack:(CancelCallBack)dismissCallBack;

@end
