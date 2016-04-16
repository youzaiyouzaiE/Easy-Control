//
//  AuthorBean.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/4/15.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "AuthorBean.h"
#import "AuthorDao.h"

@implementation AuthorBean
NSString *const k_author_userId = @"k_author_userId";
NSString *const k_author_name = @"k_author_name";
NSString *const k_author_location = @"k_author_location";
NSString *const k_author_sync = @"k_author_sync";

-(NSArray *)columnArray {
    return @[k_author_userId,k_author_name,k_author_location];
}

- (NSArray *)valueArray {
    if (!_sync) {
        _sync = @"N";
    }
    return @[_userId,_name,[NSNumber numberWithInteger:_location],_sync];
}

- (BOOL)deleteBean {
    return [[AuthorDao shareInstance] deleteBeanWithIdKey:self.idKey];
}

- (NSString *)description {
    return @"AuthorBean";
}
@end
