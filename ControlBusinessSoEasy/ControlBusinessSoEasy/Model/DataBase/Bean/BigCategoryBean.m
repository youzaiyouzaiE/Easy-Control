//
//  BigCategoryBean.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/20.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "BigCategoryBean.h"
#import "BigCategoryDao.h"

NSString *const k_big_userId = @"k_big_userId";
NSString *const k_big_name = @"k_big_name";
NSString *const k_big_location = @"k_big_location";
NSString *const k_big_sync = @"k_big_sync";

@implementation BigCategoryBean

-(NSArray *)columnArray {
    return @[k_big_userId,k_big_name,k_big_location];
}

- (NSArray *)valueArray {
    if (!_sync) {
        _sync = @"N";
    }
    return @[_userId,_name,[NSNumber numberWithInteger:_location],_sync];
}

- (BOOL)deleteBean {
    return [[BigCategoryDao shareInstance] deleteBeanWithIdKey:self.idKey];
}

- (NSString *)description {
    return @"BigCategoryBean";
}

@end
