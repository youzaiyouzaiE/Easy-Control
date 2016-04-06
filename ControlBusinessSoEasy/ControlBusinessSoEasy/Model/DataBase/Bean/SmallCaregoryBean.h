//
//  SmallCaregoryBean.h
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/20.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "SuperBean.h"


extern NSString *const k_small_BigId;
extern NSString *const k_small_name;
extern NSString *const k_small_location;
extern NSString *const k_small_aync;
@interface SmallCaregoryBean : SuperBean

@property (copy, nonatomic) NSString *bigCaregoryID;
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger location;
@property (copy, nonatomic) NSString *aync;
@end
