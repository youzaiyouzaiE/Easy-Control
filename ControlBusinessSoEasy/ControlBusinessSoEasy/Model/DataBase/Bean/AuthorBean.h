//
//  AuthorBean.h
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/4/15.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "SuperBean.h"
extern NSString *const k_author_userId ;
extern NSString *const k_author_name ;
extern NSString *const k_author_location;
extern NSString *const k_author_sync;

@interface AuthorBean : SuperBean

@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger location;
@property (copy, nonatomic) NSString *sync;

@end
