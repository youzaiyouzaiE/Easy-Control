//
//  AuthorDao.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/4/15.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "AuthorDao.h"
#import "AuthorBean.h"

static NSString *const tableName = @"AuthorTable";

@implementation AuthorDao

+ (instancetype)shareInstance
{
    static AuthorDao *authouDao = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        authouDao = [[AuthorDao alloc] init];
    });
    return  authouDao;
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
        NSString *sql = [NSString stringWithFormat:@"create table IF NOT EXISTS %@ ('%@' text,'%@' text,'%@' text,'%@' integer,'%@' text)",tableName,kBeanIdKey,k_author_userId,k_author_name,k_author_location,k_author_sync];
        if ([self.db executeUpdate:sql]) {
            NSLog(@"表创建成功！");
        } else {
            NSLog(@"表创建失败！");
        }
    }
}

- (id)mappingRs2Bean:(FMResultSet *)rs {
    AuthorBean *bean = [[AuthorBean alloc] init];
    bean.idKey = [rs stringForColumn:kBeanIdKey];
    bean.userId = [rs stringForColumn:k_author_userId];
    bean.name = [rs stringForColumn:k_author_name];
    bean.location = [rs intForColumn:k_author_location];
    bean.sync = [rs stringForColumn:k_author_sync];
    
    return bean;
}

- (NSString *)tableName
{
    return tableName;
}

- (NSArray *)selectAuthorBeansByUserID:(NSString *)numberUserID {
    NSString *whereSql = [NSString stringWithFormat:@"%@ = %@", k_author_userId,numberUserID];
    return [self selectWithWhere:whereSql];
}

- (NSString *)description {
    return @"AuthorDao";
}

@end
