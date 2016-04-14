//
//  AppDelegate.h
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/18.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL  navigationBarIsUp;


- (UINavigationController *)getCurrentNavigationController;

@end

