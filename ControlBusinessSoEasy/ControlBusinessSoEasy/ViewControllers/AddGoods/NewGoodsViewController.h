//
//  NewGoodsViewController.h
//  EasyBusiness
//
//  Created by jiahui on 15/11/7.
//  Copyright © 2015年 YouZai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsInfoBean;

typedef  void (^ModifyGoodsBeanBlock) (GoodsInfoBean *bean);

@interface NewGoodsViewController : UIViewController

@property (assign, nonatomic) BOOL isEditType;//编辑信息
@property (strong, nonatomic) GoodsInfoBean *contentBean;
@property (copy, nonatomic) ModifyGoodsBeanBlock modifyBlock;

@end
