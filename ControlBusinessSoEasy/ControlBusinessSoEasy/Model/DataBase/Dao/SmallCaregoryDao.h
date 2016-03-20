//
//  SmallCaregoryDao.h
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/20.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "SuperDao.h"

@interface SmallCaregoryDao : SuperDao
+ (instancetype)shareInstance;
- (NSArray *)selectSmallCaregoryByBigID:(NSString *)bigid;
@end
