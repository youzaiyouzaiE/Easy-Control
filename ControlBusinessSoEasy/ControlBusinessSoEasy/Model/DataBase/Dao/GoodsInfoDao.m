//
//  GoodsInfoDao.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/4/6.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "GoodsInfoDao.h"
#import "GoodsInfoBean.h"

NSString *const tableName = @"goodsInfoTable";

@implementation GoodsInfoDao

+ (instancetype)shareInstance {
    static GoodsInfoDao *goodsInfoDao = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        goodsInfoDao = [[GoodsInfoDao alloc] init];
    });
    return goodsInfoDao;
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
        NSString *sql = [NSString stringWithFormat:@"create table IF NOT EXISTS %@ ('%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' real,'%@' real,'%@' text,'%@' real,'%@' text,'%@' text,'%@' text )",tableName,kBeanIdKey,k_goods_userID,k_goods_NO,k_goods_name,k_goods_category,k_goods_inPrice,k_goods_outPrice,k_goods_standard,k_goods_stock,k_goods_image,k_goods_author,k_goods_note];
        if ([self.db executeUpdate:sql]) {
            NSLog(@"表创建成功！");
        } else {
            NSLog(@"表创建失败！");
        }
    }
}

- (GoodsInfoBean *)mappingRs2Bean:(FMResultSet *)rs
{
    GoodsInfoBean *bean = [GoodsInfoBean new];
    bean.idKey = [rs stringForColumn:kBeanIdKey];
    bean.goodsIDCode = [rs stringForColumn:k_goods_NO];
    bean.name = [rs stringForColumn:k_goods_name];
    bean.category = [rs stringForColumn:k_goods_category];
    bean.inPrice = [NSNumber numberWithDouble:[rs doubleForColumn:k_goods_inPrice]];
    bean.outPrice = [NSNumber numberWithDouble:[rs doubleForColumn:k_goods_outPrice]];
    bean.standard = [rs stringForColumn:k_goods_standard];
    bean.stock = [NSNumber numberWithDouble:[rs doubleForColumn:k_goods_stock]];
    bean.imagePath = [rs stringForColumn:k_goods_image];
    bean.author = [rs stringForColumn:k_goods_author];
    bean.note = [rs stringForColumn:k_goods_note];
    return bean;
}

- (FMResultSet *)mappingBean2Rs:(id)bean
{
    NSAssert(NO, @"Subclass: mappingBean2Rs");
    return nil;
}

- (NSString *)tableName {
    return tableName;
}

- (NSArray *)selectUserAllGoods {
    NSString *whereSql = [NSString stringWithFormat:@"%@ = '%@' ", k_goods_userID,[UserInfo shareInstance].uid];
    return [self selectWithWhere:whereSql];
}

- (NSArray *)selectGoodsWithName:(NSString *)name{
    NSString *whereSql = [NSString stringWithFormat:@"%@ = '%@' AND %@ LIKE '%%%@%%' ", k_goods_userID,[UserInfo shareInstance].uid,k_goods_name,name];
    return [self selectWithWhere:whereSql];
}

- (NSArray *)selectGoodsWithCategory:(NSString *)category{
    NSString *whereSql = [NSString stringWithFormat:@"%@ = '%@' AND %@ LIKE '%%%@%%' ", k_goods_userID,[UserInfo shareInstance].uid,k_goods_category,category];
    return [self selectWithWhere:whereSql];
}

- (NSArray *)selectGoodsWithAuthor:(NSString *)author{
    NSString *whereSql = [NSString stringWithFormat:@"%@ = '%@' AND %@ LIKE '%%%@%%' ", k_goods_userID,[UserInfo shareInstance].uid,k_goods_author,author];
    return [self selectWithWhere:whereSql];
}

- (NSArray *)selectGoodsWithNote:(NSString *)note{
    NSString *whereSql = [NSString stringWithFormat:@"%@ = '%@' AND %@ LIKE '%%%@%%' ", k_goods_userID,[UserInfo shareInstance].uid,k_goods_note,note];
    return [self selectWithWhere:whereSql];
}

@end
