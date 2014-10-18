//
//  RFStorageKit.m
//  RF
//
//  Created by gouzhehua on 14-6-25.
//  Copyright (c) 2014年 skyinfo. All rights reserved.
//

#import "RFStorageKit.h"
#import "ARCMacros.h"
#import "RFKit.h"

@interface RFStorageKit ()
@property (nonatomic, SAFE_ARC_STRONG) NSString *clearPath;
@property (nonatomic, SAFE_ARC_STRONG) NSThread *clearDataThread;
@property (nonatomic, assign) BOOL isCancelClearData;
@property (nonatomic, copy) RFStorageKitClearFinishBlock clearCacheFinishBlock;

- (void)clearMainProc;

@end

@implementation RFStorageKit
@synthesize clearPath = _clearPath;
@synthesize clearCacheFinishBlock = _clearCacheFinishBlock;
@synthesize clearDataThread = _clearDataThread;
@synthesize isCancelClearData = _isCancelClearData;

- (void)dealloc
{
	[self clearCancel];
	
	SAFE_ARC_SUPER_DEALLOC();
}

- (void)clearAsynWithPath:(NSString *)aPath block:(RFStorageKitClearFinishBlock)aBlock
{
	[self clearCancel];
	
	self.clearPath = aPath;
	self.clearCacheFinishBlock = aBlock;
	_isCancelClearData = NO;
	_clearDataThread = [[NSThread alloc] initWithTarget:self selector:@selector(clearMainProc) object:nil];
	[_clearDataThread start];
}

- (void)clearMainProc
{
	@autoreleasepool
	{
		// 删除缓存
		if (!_isCancelClearData)
		{
			if (![NSString isEmpty:_clearPath])
			{
				[RFStorageKit removeWithPath:_clearPath];
			}
		}
		
		// 清理Log
		if (!_isCancelClearData)
		{
			NSString *errPath = [RFStorageKit ioLogErrorPath];
			NSString *outPath = [RFStorageKit ioLogPath];
			[RFStorageKit removeWithPath:errPath];
			[RFStorageKit removeWithPath:outPath];
		}
		
		// 延迟
		[NSThread sleepForTimeInterval:0.5];
		
		// 通知回调
		if (_clearCacheFinishBlock != nil)
		{
			_clearCacheFinishBlock(!_isCancelClearData);
		}
		
		SAFE_ARC_AUTORELEASE(_clearDataThread);
		_clearDataThread = nil;
		_isCancelClearData = NO;
		if (_clearCacheFinishBlock != nil)
		{
			self.clearCacheFinishBlock = nil;
		}
	}
}

- (void)clearCancel
{
	if (_clearDataThread != nil)
	{
		if ([_clearDataThread isExecuting])
		{
			_isCancelClearData = YES;
			[_clearDataThread cancel];
			do
			{
				[NSThread sleepForTimeInterval:0.1];
			}
			while (![_clearDataThread isCancelled]);
		}
		
		SAFE_ARC_AUTORELEASE(_clearDataThread);
		_clearDataThread = nil;
		_isCancelClearData = NO;
	}
	
	if (_clearCacheFinishBlock != nil)
	{
		self.clearCacheFinishBlock = nil;
	}
	
	self.clearPath = nil;
}

- (BOOL)isClearing
{
	if (_clearDataThread != nil)
	{
		return YES;
	}
	return NO;
}

+ (NSManagedObjectContext *)loadCoreDataWithDB:(NSURL *)dbUrl model:(NSURL *)modelUrl
{
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
	
    NSPersistentStoreCoordinator *persistent = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	
	NSError *error = nil;
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption : @YES, NSInferMappingModelAutomaticallyOption : @YES};
	
    if (![persistent addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:dbUrl options:options error:&error])
	{
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		return nil;
    }
	
	NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
	[context setPersistentStoreCoordinator:persistent];
	
	return context;
}

+ (void)saveCoreData:(NSManagedObjectContext *)context
{
	NSError *error = nil;
	if (context != nil)
	{
		if ([context hasChanges] && ![context save:&error])
		{
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
	}
}

+ (NSString *)cachePathWithDirectory:(NSString *)aDirectory file:(NSString *)aFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *basePath = [paths objectAtIndex:0];
	
	NSMutableString *buffer = [NSMutableString string];
	[buffer appendFormat:@"%@", [basePath stringByExpandingTildeInPath]];
	if (![NSString isEmpty:aDirectory])
	{
		[buffer appendFormat:@"/%@", aDirectory];
	}
	[self makeDirectory:buffer];
	
	if (![NSString isEmpty:aFile])
	{
		[buffer appendFormat:@"/%@", aFile];
	}
    return buffer;
}

+ (NSURL *)cacheURLWithDirectory:(NSString *)aDirectory file:(NSString *)aFile
{
	return [NSURL fileURLWithPath:[self cachePathWithDirectory:aDirectory file:aFile]];
}

+ (NSString *)documentPathWithDirectory:(NSString *)aDirectory file:(NSString *)aFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *basePath = [paths objectAtIndex:0];
	
	NSMutableString *buffer = [NSMutableString string];
	[buffer appendFormat:@"%@", [basePath stringByExpandingTildeInPath]];
	if (![NSString isEmpty:aDirectory])
	{
		[buffer appendFormat:@"/%@", aDirectory];
	}
	[self makeDirectory:buffer];
	
	if (![NSString isEmpty:aFile])
	{
		[buffer appendFormat:@"/%@", aFile];
	}
    return buffer;
}

+ (NSURL *)documentURLWithDirectory:(NSString *)aDirectory file:(NSString *)aFile
{
	return [NSURL fileURLWithPath:[self documentPathWithDirectory:aDirectory file:aFile]];
}

+ (NSString *)tmpPathWithDirectory:(NSString *)aDirectory file:(NSString *)aFile
{
	NSString *basePath = NSTemporaryDirectory();
	NSMutableString *buffer = [NSMutableString string];
	[buffer appendFormat:@"%@", [basePath stringByExpandingTildeInPath]];
	if (![NSString isEmpty:aDirectory])
	{
		[buffer appendFormat:@"/%@", aDirectory];
	}
	[self makeDirectory:buffer];
	
	if (![NSString isEmpty:aFile])
	{
		[buffer appendFormat:@"/%@", aFile];
	}
    return buffer;
}

+ (NSURL *)tmpURLWithDirectory:(NSString *)aDirectory file:(NSString *)aFile
{
	return [NSURL fileURLWithPath:[self tmpPathWithDirectory:aDirectory file:aFile]];
}

+ (void)makeDirectory:(NSString *)path
{
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	if (![fileMgr fileExistsAtPath:path])
		[fileMgr createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

+ (void)removeWithPath:(NSString *)path
{
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	if ([fileMgr fileExistsAtPath:path])
		[fileMgr removeItemAtPath:path error:nil];
}

+ (void)clearDirectoryWithPath:(NSString *)path
{
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	NSArray *fileList = [fileMgr contentsOfDirectoryAtPath:path error:nil];
	if (fileList != nil && fileList.count > 0)
	{
		for (NSString *file in fileList)
		{
			NSString *filePath = [path stringByAppendingPathComponent:file];
			[fileMgr removeItemAtPath:filePath error:nil];
		}
	}
}

+ (BOOL)copyPathFrom:(NSString *)from to:(NSString *)to
{
	if (![NSString isEmpty:from] && ![NSString isEmpty:to])
	{
		return [RFStorageKit copyUrlFrom:[NSURL fileURLWithPath:from] to:[NSURL fileURLWithPath:to]];
	}
	return NO;
}

+ (BOOL)copyUrlFrom:(NSURL *)from to:(NSURL *)to
{
	if (from != nil && to != nil)
	{
		NSFileManager *fileMgr = [NSFileManager defaultManager];
		return [fileMgr copyItemAtURL:from toURL:to error:nil];
	}
	return NO;
}

+ (NSDate *)modificationDateWithPath:(NSString *)path
{
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	if ([fileMgr fileExistsAtPath:path])
	{
		NSDictionary *attributes = [fileMgr attributesOfItemAtPath:path error:nil];
		return [attributes objectForKey:NSFileModificationDate];
	}
	return nil;
}

+ (void)changeModificationDate:(NSString *)path date:(NSDate *)date
{
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	if ([fileMgr fileExistsAtPath:path])
	{
		NSDictionary *attributes = [fileMgr attributesOfItemAtPath:path error:nil];
		NSMutableDictionary *newAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
		[newAttributes setObject:date forKey:NSFileModificationDate];
		[fileMgr setAttributes:newAttributes ofItemAtPath:path error:nil];
	}
}

+ (BOOL)isExist:(NSString *)path
{
	if (![NSString isEmpty:path])
	{
		NSFileManager *fileMgr = [NSFileManager defaultManager];
		return [fileMgr fileExistsAtPath:path];
	}
	return NO;
}

+ (int64_t)fileSize:(NSString *)path
{
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	if ([fileMgr fileExistsAtPath:path])
	{
		NSDictionary *attributes = [fileMgr attributesOfItemAtPath:path error:nil];
		return [[attributes objectForKey:NSFileSize] longLongValue];
	}
	return 0;
}

+ (NSString *)ioLogPath
{
	return [self documentPathWithDirectory:@"LOG" file:nil];
}

+ (NSString *)ioLogErrorPath
{
	return [self documentPathWithDirectory:@"LOG_ERR" file:nil];
}

+ (void)redirectNSLogToDocumentFolder
{
	NSString *fileName =[NSString stringWithFormat:@"%@.log",[NSDate date]];
	NSString *errPath = [self documentPathWithDirectory:@"LOG_ERR" file:fileName];
	NSString *outPath = [self documentPathWithDirectory:@"LOG" file:fileName];
    freopen([errPath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
	freopen([outPath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
}

+ (NSMutableDictionary *)defaultsDict
{
	NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
	NSDictionary* dict = [ud persistentDomainForName:[RFKit bundleIdentifier]];
	if (dict == nil)
		return [NSMutableDictionary dictionary];
	else
		return [NSMutableDictionary dictionaryWithDictionary:dict];
}

+ (void)saveDefaultsDict:(NSDictionary *)aDict
{
	NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
	[ud setPersistentDomain:aDict forName:[RFKit bundleIdentifier]];
}

+ (id)loadSerializeDataWithFilePath:(NSString *)filePath
{
	id<NSCoding> object = nil;
	@autoreleasepool
	{
		NSData *saveData = [[NSData alloc] initWithContentsOfFile:filePath];
		if (saveData != nil)
		{
			NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:saveData];
			object = [unArchiver decodeObject];
		}
	}
	return object;
}

+ (void)serializeDataWithObject:(id<NSCoding>)anObject filePath:(NSString *)filePath
{
	@autoreleasepool
	{
		// 保存
		NSMutableData* saveData = [[NSMutableData alloc] init];
		{
			NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:saveData];
			{
				[archiver encodeRootObject:anObject];
				[archiver finishEncoding];
				
				// to file
				[saveData writeToFile:filePath atomically:NO];
			}
		}
	}
}

+ (id)loadCacheWithName:(NSString *)cacheName
{
	id<NSCoding> object = nil;
	@autoreleasepool
	{
		NSString *fileName = [[NSString stringWithFormat:@"DC_%@", cacheName] toMD5];
		NSString *path = [RFStorageKit cachePathWithDirectory:kRFStorageDirCache file:fileName];
		NSData *saveData = [[NSData alloc] initWithContentsOfFile:path];
		if (saveData != nil)
		{
			NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:saveData];
			object = [unArchiver decodeObject];
			SAFE_ARC_RELEASE(unArchiver);
		}
		SAFE_ARC_RELEASE(saveData);
	}
	return object;
}

+ (void)saveCacheWithObject:(id<NSCoding>)anObject cacheName:(NSString *)cacheName
{
	@autoreleasepool
	{
		NSString *fileName = [[NSString stringWithFormat:@"DC_%@", cacheName] toMD5];
		NSString *path = [RFStorageKit cachePathWithDirectory:kRFStorageDirCache file:fileName];
		// 保存
		NSMutableData* saveData = [[NSMutableData alloc] init];
		{
			NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:saveData];
			{
				[archiver encodeRootObject:anObject];
				[archiver finishEncoding];
				
				// to file
				[saveData writeToFile:path atomically:YES];
			}
			SAFE_ARC_RELEASE(archiver);
		}
		SAFE_ARC_RELEASE(saveData);
	}
}

+ (void)deleteCacheWithName:(NSString *)cacheName
{
	NSString *fileName = [[NSString stringWithFormat:@"DC_%@", cacheName] toMD5];
	NSString *path = [RFStorageKit cachePathWithDirectory:kRFStorageDirCache file:fileName];
	[RFStorageKit removeWithPath:path];
}

+ (id)loadDocumentWithName:(NSString *)cacheName
{
	id<NSCoding> object = nil;
	@autoreleasepool
	{
		NSString *fileName = [[NSString stringWithFormat:@"DC_%@", cacheName] toMD5];
		NSString *path = [RFStorageKit documentPathWithDirectory:kRFStorageDirData file:fileName];
		NSData *saveData = [[NSData alloc] initWithContentsOfFile:path];
		if (saveData != nil)
		{
			NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:saveData];
			object = [unArchiver decodeObject];
			SAFE_ARC_RELEASE(unArchiver);
		}
		SAFE_ARC_RELEASE(saveData);
	}
	return object;
}

+ (void)saveDocumentWithObject:(id<NSCoding>)anObject cacheName:(NSString *)cacheName
{
	@autoreleasepool
	{
		NSString *fileName = [[NSString stringWithFormat:@"DC_%@", cacheName] toMD5];
		NSString *path = [RFStorageKit documentPathWithDirectory:kRFStorageDirData file:fileName];
		// 保存
		NSMutableData* saveData = [[NSMutableData alloc] init];
		{
			NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:saveData];
			{
				[archiver encodeRootObject:anObject];
				[archiver finishEncoding];
				
				// to file
				[saveData writeToFile:path atomically:YES];
			}
			SAFE_ARC_RELEASE(archiver);
		}
		SAFE_ARC_RELEASE(saveData);
	}
}

+ (void)deleteDocumentWithName:(NSString *)cacheName
{
	NSString *fileName = [[NSString stringWithFormat:@"DC_%@", cacheName] toMD5];
	NSString *path = [RFStorageKit documentPathWithDirectory:kRFStorageDirData file:fileName];
	[RFStorageKit removeWithPath:path];
}

+ (RFStorageKit *)shared
{
	static RFStorageKit *s_instance = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		s_instance = [[RFStorageKit alloc] init];
	});
	
	return s_instance;
}

@end
