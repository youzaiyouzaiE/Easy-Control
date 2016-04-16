//
//  AuthorDao.h
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/4/15.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "SuperDao.h"

@interface AuthorDao : SuperDao

+ (instancetype)shareInstance;
- (NSArray *)selectAuthorBeansByUserID:(NSString *)numberUserID;


@end
