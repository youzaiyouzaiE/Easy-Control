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
        NSString *sql = [NSString stringWithFormat:@"create table IF NOT EXISTS %@ ('%@' text,'%@' text,'%@' text,'%@' text,'%@' real,'%@' real,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text )",tableName,kBeanIdKey,k_goods_NO,k_goods_name,k_goods_category,k_goods_inPrice,k_goods_outPrice,k_goods_standard,k_goods_stock,k_goods_image,k_goods_author,k_goods_note];
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
    bean.stock = [rs stringForColumn:k_goods_stock];
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



@end
