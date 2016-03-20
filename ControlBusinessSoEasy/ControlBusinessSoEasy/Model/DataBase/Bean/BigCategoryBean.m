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

@implementation BigCategoryBean

-(NSArray *)columnArray {
    return @[k_big_userId,k_big_name,k_big_location];
}

- (NSArray *)valueArray {
    return @[_userId,_name,[NSNumber numberWithInteger:_location]];
}

- (BOOL)deleteBean {
    return [[BigCategoryDao shareInstance] deleteBeanWithIdKey:self.idKey];
}

- (NSString *)description {
    return @"BigCategoryBean";
}

@end
