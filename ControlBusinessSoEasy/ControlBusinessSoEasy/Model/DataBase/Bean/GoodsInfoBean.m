//
//  GoodsInfoBean.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/4/6.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "GoodsInfoBean.h"
#import "GoodsInfoDao.h"

@implementation GoodsInfoBean

NSString *const k_goods_NO = @"k_goods_NO";
NSString *const k_goods_name = @"k_goods_name";
NSString *const k_goods_category = @"k_goods_category";
NSString *const k_goods_inPrice = @"k_goods_inPrice";
NSString *const k_goods_outPrice = @"k_goods_outPrice";
NSString *const k_goods_standard = @"k_goods_standard";
NSString *const k_goods_stock = @"k_goods_stock";
NSString *const k_goods_image = @"k_goods_image";
NSString *const k_goods_author = @"k_goods_author";
NSString *const k_goods_note = @"k_goods_not";

- (NSArray *)columnArray {
    return @[k_goods_NO, k_goods_name, k_goods_category, k_goods_inPrice, k_goods_outPrice, k_goods_standard, k_goods_stock, k_goods_image, k_goods_author, k_goods_note];
}

- (NSArray *)valueArray {
    if (!_goodsIDCode) {
        _goodsIDCode = (NSString *)[NSNull null];
    }
    if (!_category) {
        _category = (NSString *)[NSNull null];
    }
    if (!_inPrice) {
        _inPrice = (NSNumber *)[NSNull null];
    }
    if (!_outPrice) {
        _outPrice = (NSNumber *)[NSNull null];
    }
    if (!_standard) {
        _standard = (NSString *)[NSNull null];
    }
    if (!_stock) {
        _stock = (NSString *)[NSNull null];
    }
    if (!_imagePath) {
        _imagePath = (NSString *)[NSNull null];
    }
    if (!_note) {
        _note = (NSString *)[NSNull null];
    }
    if (!_author) {
        _author = (NSString *)[NSNull null];
    }
    return @[_goodsIDCode, _name, _category, _inPrice, _outPrice, _standard, _stock, _imagePath, _author, _note];
}

- (BOOL)deleteBean {
    return [[GoodsInfoDao shareInstance] deleteBeanWithIdKey:self.idKey];
}

- (NSString *)description {
    return @"SmallCaregoryBean";
}



@end
