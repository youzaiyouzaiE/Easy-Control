//
//  UITools.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/19.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "UITools.h"

@implementation UITools

static UITools *tools = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [UITools new];
    });
    return tools;
}

+ (void)customNavigationBackButtonAndTitle:(NSString *)title forController:(UIViewController *)controller{
    controller.navigationItem.title = title;
    controller.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    controller.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

+ (void)customNavigationBackButtonForController:(UIViewController *)controller{
    controller.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    controller.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

@end
