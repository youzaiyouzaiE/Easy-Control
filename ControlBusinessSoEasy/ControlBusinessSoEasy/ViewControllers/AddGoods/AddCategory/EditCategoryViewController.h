//
//  EditCategoryViewController.h
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/20.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^updateBlock)(BOOL need ,BOOL isDeleteBean);

typedef NS_ENUM(NSInteger, CategoryType) {
    bigCategory,
    smallCategory,
    author,////供应商
};

@interface EditCategoryViewController : UIViewController


@property (assign, nonatomic) CategoryType categoryType;

@property (nonatomic, strong) NSMutableArray *arrayCategorys;
@property (nonatomic, copy) NSString *bigCategoryBeanId;///

@property (copy, nonatomic) updateBlock needUpdateBlock;

@end
