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

#pragma mark - FilePath
+ (NSString *)getCachesDirectoryDocumentPath:(NSString *)documentName {
    NSString *cacheDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cacheDirectoryPath stringByAppendingPathComponent:documentName];
    NSFileManager *mager = [NSFileManager defaultManager];
    if (![mager fileExistsAtPath:path]) {
//        NSLog(@"File not found Couldn't find the file at path: %@",path);
        if ([mager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]) {
            return path;
        } else {
             NSLog(@"创建 %@ 失败",documentName);
            return nil;
        }
    } else
        return path;
}

+ (NSString *)getCachesDirectoryBigDocumentPath:(NSString *)documentName {
    NSString *cacheDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cacheDirectoryPath stringByAppendingPathComponent:documentName];
    NSString *bigImagePath = [path stringByAppendingPathComponent:@"/big"];
    NSFileManager *mager = [NSFileManager defaultManager];
    if (![mager fileExistsAtPath:bigImagePath]) {
        //        NSLog(@"File not found Couldn't find the file at path: %@",path);
        if ([mager createDirectoryAtPath:bigImagePath withIntermediateDirectories:YES attributes:nil error:nil]) {
            return bigImagePath;
        } else {
            NSLog(@"创建 %@ 失败",documentName);
            return nil;
        }
    } else
        return bigImagePath;
}

+ (NSString *)getCachesDirectorySmallDocumentPath:(NSString *)documentName {
    NSString *cacheDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *bigImagePath = [cacheDirectoryPath stringByAppendingPathComponent:documentName];
    NSString *smallImagePath = [bigImagePath stringByAppendingPathComponent:@"/small"];
    NSFileManager *mager = [NSFileManager defaultManager];
    if (![mager fileExistsAtPath:smallImagePath]) {
        //        NSLog(@"File not found Couldn't find the file at path: %@",path);
        if ([mager createDirectoryAtPath:smallImagePath withIntermediateDirectories:YES attributes:nil error:nil]) {
            return smallImagePath;
        } else {
            NSLog(@"创建 %@ 失败",documentName);
            return nil;
        }
    } else
        return smallImagePath;
    
}

#pragma mark - other
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
