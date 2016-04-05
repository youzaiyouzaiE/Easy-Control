//
//  AddCategoryVC.h
//  EasyBusiness
//
//  Created by jiahui on 15/12/1.
//  Copyright © 2015年 YouZai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^bigAndSmallCategoryNamesBlock) (NSString *bigName,NSString *smallName);

@interface AddCategoryVC : UIViewController

@property (copy, nonatomic) bigAndSmallCategoryNamesBlock categoryNames;
@property (copy, nonatomic) NSString *alreadyCategoryNames;

@end
