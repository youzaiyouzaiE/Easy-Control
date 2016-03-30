//
//  EditCategoryViewController.h
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/20.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CategoryType) {
    bigCategory,
    smallCategory,
};

@interface EditCategoryViewController : UIViewController


@property (assign, nonatomic) CategoryType categoryType;
@property (nonatomic, strong) NSMutableArray *arrayCategorys;
@property (nonatomic, copy) NSString *bigCategoryBeanId;///

@end
