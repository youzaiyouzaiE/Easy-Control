//
//  SuperBean.h
//  SmartLift-iPhone
//
//  Created by jiahui on 15/1/21.
//  Copyright (c) 2015年 YouZai. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *const kBeanIdKey;

@interface SuperBean : NSObject

@property (copy, nonatomic, readonly) NSArray *columnArray;
@property (strong, nonatomic, readonly) NSArray *valueArray;
@property (copy, nonatomic) NSString *idKey;

-(BOOL)deleteBean;

@end
