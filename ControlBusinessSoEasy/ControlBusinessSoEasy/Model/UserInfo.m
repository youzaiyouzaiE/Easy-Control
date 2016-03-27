//
//  UserInfo.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/20.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

static UserInfo *shareInstance = nil;

+ (instancetype)shareInstance {
    dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [UserInfo new];
        shareInstance.uid = @"1234567890";
        shareInstance.name = @"public";
    });
    return shareInstance;
}




@end
