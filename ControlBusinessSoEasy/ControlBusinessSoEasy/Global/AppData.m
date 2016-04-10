//
//  AppData.m
//  EasyBusiness
//
//  Created by jiahui on 15/10/13.
//  Copyright (c) 2015年 YouZai. All rights reserved.
//

#import "AppData.h"

@implementation AppData

static AppData *appData = nil;

+ (instancetype) shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appData = [AppData new];
    });
    return appData;
}



#pragma mark - dataBase operation
NSString *const datebaseName = @"BusinessInfo.db";
- (BOOL)initDataBaseToDocument {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:datebaseName];
    if (!_db) {
        self.db = [FMDatabase databaseWithPath:dbPath];
    }
    if (![_db open]) {
        NSLog(@"不能打开数据库！");
        return NO;
    } else {
        
    }
    return YES;
}

+ (NSString *)random_uuid
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref = CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}


@end
