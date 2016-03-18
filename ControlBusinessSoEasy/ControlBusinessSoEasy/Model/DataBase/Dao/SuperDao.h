//
//  SuperDao.h
//  SmartLift-iPhone
//
//  Created by jiahui on 15/1/21.
//  Copyright (c) 2015年 YouZai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperBean.h"
#import "FMDatabase.h"
@interface SuperDao : NSObject

@property (copy, nonatomic, readonly) NSString *tableName;
@property (strong, nonatomic) FMDatabase *db;

- (int)selectCount;

- (int)selectMaxValue:(NSString *)column;

- (NSArray *)selectAll;
- (NSArray *)selectWithWhere:(NSString *)whereSql;
- (NSArray *)selectWithOrder:(NSString *)orderSql;
- (NSArray *)selectWithWhere:(NSString *)whereSql order:(NSString *)orderSql;

- (void)insertBean:(SuperBean *)bean;
- (void)deleteAll;
- (void)deleteWithWhere:(NSString *)whereSql;
- (BOOL)deleteBeanWithIdKey:(NSString *)idKey;
- (void)updateBean:(SuperBean *)bean;
@end
