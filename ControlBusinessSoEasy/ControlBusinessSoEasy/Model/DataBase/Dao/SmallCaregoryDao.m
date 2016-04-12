//
//  SmallCaregoryDao.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/20.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "SmallCaregoryDao.h"
#import "SmallCaregoryBean.h"

@implementation SmallCaregoryDao
static NSString *const tableName = @"SmallCategoryTable";


+ (instancetype)shareInstance {
    static SmallCaregoryDao *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[SmallCaregoryDao alloc] init];
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
        NSString *sql = [NSString stringWithFormat:@"create table IF NOT EXISTS %@ ('%@' text,'%@' text,'%@' text,'%@' integer,'%@' text)",tableName,kBeanIdKey,k_small_BigId,k_small_name,k_small_location,k_small_aync];
        if ([self.db executeUpdate:sql]) {
            NSLog(@"表创建成功！");
        } else {
            NSLog(@"表创建失败！");
        }
    }
}

- (id)mappingRs2Bean:(FMResultSet *)rs {
    SmallCaregoryBean *bean = [[SmallCaregoryBean alloc] init];
    bean.idKey = [rs stringForColumn:kBeanIdKey];
    bean.bigCaregoryID = [rs stringForColumn:k_small_BigId];
    bean.name = [rs stringForColumn:k_small_name];
    bean.location = [rs intForColumn:k_small_location];
    bean.aync = [rs stringForColumn:k_small_aync];
    return bean;
}

- (NSString *)tableName {
    return tableName;
}

- (NSArray *)selectSmallCaregoryByBigID:(NSString *)bigid {
    NSString *whereSql = [NSString stringWithFormat:@"%@ = '%@' ", k_small_BigId,bigid];
    return [self selectWithWhere:whereSql];
}

- (NSArray *)selectSmallCaregoryByBigID:(NSString *)bigid orderByLocation:(NSInteger )loca{
    NSString *whereSql = [NSString stringWithFormat:@"%@ = %@", k_small_BigId,bigid];
    return [self selectWithWhere:whereSql order:[NSString stringWithFormat:@"%ld",(long)loca]];
}

- (NSString *)description {
    return @"SmallCaregoryDao";
}

@end
