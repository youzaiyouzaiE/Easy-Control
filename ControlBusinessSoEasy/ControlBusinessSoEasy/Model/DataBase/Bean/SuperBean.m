//
//  SuperBean.m
//  SmartLift-iPhone
//
//  Created by jiahui on 15/1/21.
//  Copyright (c) 2015年 YouZai. All rights reserved.
//

#import "SuperBean.h"

NSString *const kBeanIdKey = @"idKey";

@implementation SuperBean

- (NSArray *)columnArray
{
    NSAssert(NO, @"SubClass: columnString");
    return nil;
}

- (NSArray *)valueArray
{
    NSAssert(NO, @"SubClass: valueArray");
    return nil;
}

- (BOOL)deleteBean
{
     NSLog(@"the method not implement");
    return NO;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"underfined key %@",key);
}

@end
