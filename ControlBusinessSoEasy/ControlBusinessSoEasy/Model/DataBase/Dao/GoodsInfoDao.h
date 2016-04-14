//
//  GoodsInfoDao.h
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/4/6.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "SuperDao.h"

@interface GoodsInfoDao : SuperDao

+ (instancetype)shareInstance;

- (NSArray *)selectUserAllGoods;

- (NSArray *)selectGoodsWithName:(NSString *)name;
- (NSArray *)selectGoodsWithCategory:(NSString *)category;
- (NSArray *)selectGoodsWithAuthor:(NSString *)author;
- (NSArray *)selectGoodsWithNote:(NSString *)note;

@end
