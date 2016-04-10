//
//  UITools.h
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/19.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MBProgressHUD;

@interface UITools : NSObject


+(instancetype)shareInstance ;

+ (void)customNavigationBackButtonForController:(UIViewController *)controller;
+ (void)customNavigationBackButtonAndTitle:(NSString *)title forController:(UIViewController *)controller;

+ (void)customNavigationLeftBarButtonForController:(UIViewController *)controller action:(SEL)select;
- (void)customNavigationLeftBarButtonForController:(UIViewController *)controller;

- (void)showMessageToView:(UIView *)view message:(NSString *)message;
- (MBProgressHUD *)showMessageToView:(UIView *)view message:(NSString *)message autoHide:(BOOL)autoHide;




@end
