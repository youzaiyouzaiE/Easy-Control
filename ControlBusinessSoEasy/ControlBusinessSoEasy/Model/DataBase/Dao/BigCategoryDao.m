//
//  BigCategoryDao.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/20.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "BigCategoryDao.h"
#import "BigCategoryBean.h"

static NSString *const tableName = @"BigCategoryTable";

@implementation BigCategoryDao

+ (instancetype)shareInstance {
    static BigCategoryDao *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[BigCategoryDao alloc] init];
    });
    return shareInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self greateTable];
    }
    return self;
}

- (void)greateTable {
    FMResultSet *set = [self.db executeQuery:[NSString stringWithFormat:@"select count (*) from sqlite_master where type = 'table' and name = '%@'",tableName]];
    [set next];
    if ([set intForColumnIndex:0]) {
//        NSLog(@"表已经存！");
    } else {
        NSString *sql = [NSString stringWithFormat:@"create table IF NOT EXISTS %@ ('%@' text,'%@' text,'%@' text,'%@' integer,'%@' text)",tableName,kBeanIdKey,k_big_userId,k_big_name,k_big_location,k_big_sync];
        if ([self.db executeUpdate:sql]) {
            NSLog(@"表创建成功！");
        } else {
            NSLog(@"表创建失败！");
        }
    }
}

- (id)mappingRs2Bean:(FMResultSet *)rs {
    BigCategoryBean *bean = [[BigCategoryBean alloc] init];
    bean.idKey = [rs stringForColumn:kBeanIdKey];
    bean.userId = [rs stringForColumn:k_big_userId];
    bean.name = [rs stringForColumn:k_big_name];
    bean.location = [rs intForColumn:k_big_location];
    bean.sync = [rs stringForColumn:k_big_sync];
    
    return bean;
}

- (NSString *)tableName
{
    return tableName;
}

- (NSArray *)selectBigCaregoryByUserID:(NSString *)numberUserID {
    NSString *whereSql = [NSString stringWithFormat:@"%@ = %@", k_big_userId,numberUserID];
    return [self selectWithWhere:whereSql];
}

- (NSString *)description {
    return @"BigCategoryDao";
}

@end
