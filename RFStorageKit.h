//
//  RFStorageKit.h
//  RF
//
//  Created by gouzhehua on 14-6-25.
//  Copyright (c) 2014年 skyinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define kRFStorageDirData						@"Data"
#define kRFStorageDirCache						@"Cache"

typedef void(^RFStorageKitClearFinishBlock)(BOOL);		// (BOOL isFinished)

@interface RFStorageKit : NSObject
{
	
}

- (void)clearAsynWithPath:(NSString *)aPath block:(RFStorageKitClearFinishBlock)aBlock;
- (void)clearCancel;
- (BOOL)isClearing;

// CoreData
+ (NSManagedObjectContext *)loadCoreDataWithDB:(NSURL *)dbUrl model:(NSURL *)modelUrl;
+ (void)saveCoreData:(NSManagedObjectContext *)context;

// iTunes不备份，程序退出不删除
+ (NSString *)cachePathWithDirectory:(NSString *)aDirectory file:(NSString *)aFile;
+ (NSURL *)cacheURLWithDirectory:(NSString *)aDirectory file:(NSString *)aFile;

// iTunes备份
+ (NSString *)documentPathWithDirectory:(NSString *)aDirectory file:(NSString *)aFile;
+ (NSURL *)documentURLWithDirectory:(NSString *)aDirectory file:(NSString *)aFile;

// 程序退出删除
+ (NSString *)tmpPathWithDirectory:(NSString *)aDirectory file:(NSString *)aFile;
+ (NSURL *)tmpURLWithDirectory:(NSString *)aDirectory file:(NSString *)aFile;

+ (void)makeDirectory:(NSString *)path;
+ (void)removeWithPath:(NSString *)path;
+ (void)clearDirectoryWithPath:(NSString *)path;

+ (BOOL)copyPathFrom:(NSString *)from to:(NSString *)to;
+ (BOOL)copyUrlFrom:(NSURL *)from to:(NSURL *)to;

+ (NSDate *)modificationDateWithPath:(NSString *)path;
+ (void)changeModificationDate:(NSString *)path date:(NSDate *)date;

+ (BOOL)isExist:(NSString *)path;
+ (int64_t)fileSize:(NSString *)path;

+ (NSString *)ioLogPath;
+ (NSString *)ioLogErrorPath;
+ (void)redirectNSLogToDocumentFolder;

+ (NSMutableDictionary *)defaultsDict;
+ (void)saveDefaultsDict:(NSDictionary *)aDict;

+ (id)loadSerializeDataWithFilePath:(NSString *)filePath;
+ (void)serializeDataWithObject:(id<NSCoding>)anObject filePath:(NSString *)filePath;

+ (id)loadCacheWithName:(NSString *)cacheName;
+ (void)saveCacheWithObject:(id<NSCoding>)anObject cacheName:(NSString *)cacheName;
+ (void)deleteCacheWithName:(NSString *)cacheName;

+ (id)loadDocumentWithName:(NSString *)cacheName;
+ (void)saveDocumentWithObject:(id<NSCoding>)anObject cacheName:(NSString *)cacheName;
+ (void)deleteDocumentWithName:(NSString *)cacheName;

+ (RFStorageKit *)shared;

@end
