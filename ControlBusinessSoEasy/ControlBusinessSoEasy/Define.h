//
//  Define.h
//  EasyBusiness
//
//  Created by jiahui on 15/10/12.
//  Copyright (c) 2015年 YouZai. All rights reserved.
//

#ifndef EasyBusiness_Define_h
#define EasyBusiness_Define_h

#define APPDELEGATE_SHARE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define FORMAT(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height//获取屏幕高度
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width//获取屏幕宽度
#define IOS_7LAST ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)?1:0

#endif
