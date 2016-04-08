//
//  GoodsInfoBean.h
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/4/6.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "SuperBean.h"

extern NSString *const k_goods_NO;
extern NSString *const k_goods_name;
extern NSString *const k_goods_category;
extern NSString *const k_goods_inPrice;
extern NSString *const k_goods_outPrice;
extern NSString *const k_goods_standard;
extern NSString *const k_goods_stock;
extern NSString *const k_goods_image;
extern NSString *const k_goods_author;
extern NSString *const k_goods_note;

@interface GoodsInfoBean : SuperBean

@property (copy, nonatomic) NSString *goodsIDCode;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *category;
@property (strong, nonatomic) NSNumber *inPrice;
@property (strong, nonatomic) NSNumber *outPrice;
@property (copy, nonatomic) NSString *standard;
@property (copy, nonatomic) NSString *stock;
@property (copy, nonatomic) NSString *imagePath;
@property (copy, nonatomic) NSString *author;
@property (copy, nonatomic) NSString *note;



@end