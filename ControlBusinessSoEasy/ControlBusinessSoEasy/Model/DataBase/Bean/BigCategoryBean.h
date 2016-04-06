//
//  BigCategoryBean.h
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/20.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "SuperBean.h"
extern NSString *const k_big_userId ;
extern NSString *const k_big_name ;
extern NSString *const k_big_location;
extern NSString *const k_big_aync;
//NSString *const k_big_userId = @"k_big_userId";
//NSString *const k_big_name = @"k_big_name";
//NSString *const k_big_location = @"k_big_location";

@interface BigCategoryBean : SuperBean

@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger location;
@property (copy, nonatomic) NSString *aync;

@end
