//
//  EditCategoryViewController.h
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/20.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UpdateOrDeleteBeanBlock)(BOOL isDeleteBean,NSString *selectName);

typedef NS_ENUM(NSInteger, CategoryType) {
    bigCategory,
    smallCategory,
    author,////供应商
};

@interface EditCategoryViewController : UIViewController


@property (assign, nonatomic) CategoryType categoryType;

@property (nonatomic, strong) NSMutableArray *arrayCategorys;//////data source
@property (nonatomic, copy) NSString *bigCategoryBeanId;///

@property (copy, nonatomic) UpdateOrDeleteBeanBlock updateOrDeleteBlock;

@end
