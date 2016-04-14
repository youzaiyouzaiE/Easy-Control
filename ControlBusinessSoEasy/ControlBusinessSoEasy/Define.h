//
//  Define.h
//  EasyBusiness
//
//  Created by jiahui on 15/10/12.
//  Copyright (c) 2015年 YouZai. All rights reserved.
//

#ifndef EasyBusiness_Define_h
#define EasyBusiness_Define_h

#define APPLICATION_SHARE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define FORMAT(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height//获取屏幕高度
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width//获取屏幕宽度

#define IOS_7LAST ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)?1:0
#define IOS_8LAST ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)?1:0


#define NAVIGATION_BAR_COLOR        [UIColor colorWithRed:231/255.0f green:112/255.0f blue:57/255.0f alpha:1]
#define FRIST_COLOR                [UIColor colorWithRed:48.0/255.0f green:108.0/255.0f blue:218.0/255.0f alpha:0.8]
#define SECOND_COLOR               [UIColor colorWithRed:23.0/255.0f green:123.0/255.0f blue:218.0/255.0f alpha:0.8]
#define THIRD_COLOR                [UIColor colorWithRed:79.0/255.0f green:153.0/255.0f blue:218.0/255.0f alpha:0.8]

#endif
