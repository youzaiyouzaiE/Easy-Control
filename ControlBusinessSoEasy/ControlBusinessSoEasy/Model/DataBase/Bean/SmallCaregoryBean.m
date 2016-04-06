//
//  SmallCaregoryBean.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/20.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "SmallCaregoryBean.h"
#import "SmallCaregoryDao.h"

NSString *const k_small_BigId = @"k_small_BigId";
NSString *const k_small_name = @"k_small_name";
NSString *const k_small_location = @"k_small_location";
NSString *const k_small_aync = @"k_small_aync";

@implementation SmallCaregoryBean

-(NSArray *)columnArray {
    return @[k_small_BigId,k_small_name,k_small_location,k_small_aync];
}

- (NSArray *)valueArray {
    if (!_aync) {
        _aync = @"N";
    }
    return @[_bigCaregoryID,_name,[NSNumber numberWithInteger:_location],_aync];
}

- (BOOL)deleteBean {
    return [[SmallCaregoryDao shareInstance] deleteBeanWithIdKey:self.idKey];
}

- (NSString *)description {
    return @"SmallCaregoryBean";
}

@end
