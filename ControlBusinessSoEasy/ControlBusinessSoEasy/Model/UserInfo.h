//
//  UserInfo.h
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/20.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfo : BaseModel

@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *name;

+ (instancetype)shareInstance;

@end
