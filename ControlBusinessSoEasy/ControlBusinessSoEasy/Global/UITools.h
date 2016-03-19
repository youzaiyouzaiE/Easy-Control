//
//  UITools.h
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/19.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UITools : NSObject


+(instancetype)shareInstance ;

+ (void)customNavigationBackButtonForController:(UIViewController *)controller;
+ (void)customNavigationBackButtonAndTitle:(NSString *)title forController:(UIViewController *)controller;

@end
