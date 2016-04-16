//
//  AddOrEditViewController.h
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/27.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^categoryNameBlock) (NSString *categoryName);

@interface AddOrEditViewController : UIViewController

@property (copy, nonatomic) categoryNameBlock categoryName;
@property (copy, nonatomic) NSString *navTitle;
@property (copy, nonatomic) NSString *textFiledStr;
@property (strong, nonatomic) NSMutableArray *arrayContents;/////bigCategory or small category 判断是否添加过
@property (assign, nonatomic) NSInteger modelType;// 0 is bigCategory; 1 is smallCategory; 2 is author;

@end

