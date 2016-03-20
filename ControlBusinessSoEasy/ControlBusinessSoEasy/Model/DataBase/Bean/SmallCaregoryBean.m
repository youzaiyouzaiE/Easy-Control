//
//  SmallCaregoryBean.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/20.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "SmallCaregoryBean.h"
#import "SmallCaregoryDao.h"

NSString *const k_small_BigId = @"small_BigId";
NSString *const k_small_name = @"small_name";
NSString *const k_small_location = @"small_location";

@implementation SmallCaregoryBean

-(NSArray *)columnArray {
    return @[k_small_BigId,k_small_name,k_small_location];
}

- (NSArray *)valueArray {
    return @[_bigCaregoryID,_name,[NSNumber numberWithInteger:_location]];
}

- (BOOL)deleteBean {
    return [[SmallCaregoryDao shareInstance] deleteBeanWithIdKey:self.idKey];
}

@end
