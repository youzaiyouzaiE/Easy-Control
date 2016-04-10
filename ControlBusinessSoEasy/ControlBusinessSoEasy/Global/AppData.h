//
//  AppData.h
//  EasyBusiness
//
//  Created by jiahui on 15/10/13.
//  Copyright (c) 2015年 YouZai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface AppData : NSObject

@property (strong, nonatomic) FMDatabase *db;

+ (instancetype) shareInstance;
- (BOOL)initDataBaseToDocument;

+ (NSString *)random_uuid;

+ (NSString *)getCachesDirectoryDocumentPath:(NSString *)documentName;

@end
