//
//  RFWork.m
//  RF
//
//  Created by gouzhehua on 14-8-4.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import "RFWork.h"
#import "RFKit.h"
#import "NSObject+RFEvent.h"

@interface RFWorkMgr ()
- (void)removeWork:(RFWork *)aWork;
@end

@interface RFWork ()
- (NSString *)stateString;
@end

@implementation RFWorkMgr
@synthesize maxRunningWifi = _maxRunningWifi;
@synthesize maxRunning3g = _maxRunning3g;
@synthesize requestGroups = _requestGroups;
@synthesize operationQueue = _operationQueue;

- (id)init
{
	self = [super init];
    if (self)
    {
		_maxRunningWifi = 5;
		_maxRunning3g = 1;
		_requestGroups = [[NSMutableDictionary alloc] init];
		_operationQueue = [[NSOperationQueue alloc] init];
		[_operationQueue setMaxConcurrentOperationCount:_maxRunningWifi];
    }
    return self;
}

- (void)dealloc
{
	[self cancelAll];
	
	SAFE_ARC_RELEASE(_requestGroups);
	SAFE_ARC_RELEASE(_operationQueue);
	
    SAFE_ARC_SUPER_DEALLOC();
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@\nopers:%ld\n%@\ngroup:%@"
			, [super description]
			, (long)_operationQueue.operationCount
			, _operationQueue.operations
			, _requestGroups
			];
}

- (void)addWork:(RFWork *)aWork
{
	[_operationQueue addOperation:aWork];
	aWork.groupName = @"";
}

- (void)addWork:(RFWork *)aWork inGroup:(NSString *)aGroup
{
	if (![NSString isEmpty:aGroup])
	{
		NSMutableArray *works = [_requestGroups objectForKey:aGroup];
		if (works == nil)
		{
			works = [NSMutableArray array];
			[_requestGroups setObject:works forKey:aGroup];
		}
		[works addObject:aWork];
		__weak RFWork *workRef = aWork;
		__weak RFWorkMgr *workMgrRef = self;
		[aWork setCompletionBlock:^(){
			[workMgrRef removeWork:workRef];
		}];
	}
	
	[_operationQueue addOperation:aWork];
	aWork.groupName = [NSString ifNilToStr:aGroup];
}

- (void)removeWork:(RFWork *)aWork
{
	if (![NSString isEmpty:aWork.groupName])
	{
		NSMutableArray *works = [_requestGroups objectForKey:aWork.groupName];
		if (works != nil)
		{
			[works removeObject:aWork];
			if (works.count == 0)
			{
				[_requestGroups removeObjectForKey:aWork.groupName];
			}
		}
	}
}

- (void)cancelAll
{
	[_requestGroups removeAllObjects];
	[_operationQueue cancelAllOperations];
}

- (void)cancelGroup:(NSString *)aGroup
{
	if (![NSString isEmpty:aGroup])
	{
		NSMutableArray *works = [_requestGroups objectForKey:aGroup];
		[_requestGroups removeObjectForKey:aGroup]; // 提高效率，另防止迭代Cancel，执行CompletionBlock导致错误
		for (RFWork *work in works)
		{
			[work cancel];
		}
	}
}

- (void)cancelWork:(NSString *)aName
{
	NSArray *works = [self findWork:aName];
	for (RFWork *work in works)
	{
		[work cancel];
	}
}

- (void)cancelWork:(NSString *)aName inGroup:(NSString *)aGroup
{
	NSArray *works = [self findWork:aName inGroup:aGroup];
	for (RFWork *work in works)
	{
		[work cancel];
	}
}

- (BOOL)isWorkRun:(NSString *)aName
{
	for (RFWork *work in _operationQueue.operations)
	{
		if ([work.workName isEqualToString:aName])
		{
			return YES;
		}
	}
	return NO;
}

- (BOOL)isWorkRun:(NSString *)aName inGroup:(NSString *)aGroup
{
	if (![NSString isEmpty:aGroup])
	{
		NSMutableArray *works = [_requestGroups objectForKey:aGroup];
		if (works != nil)
		{
			for (RFWork *work in works)
			{
				if ([work.workName isEqualToString:aName])
				{
					return YES;
				}
			}
		}
	}
	return NO;
}

- (NSArray *)findWork:(NSString *)aName
{
	NSMutableArray *returnWorks = [NSMutableArray array];
	for (RFWork *work in _operationQueue.operations)
	{
		if ([work.workName isEqualToString:aName])
		{
			[returnWorks addObject:work];
		}
	}
	return returnWorks;
}

- (NSArray *)findWork:(NSString *)aName inGroup:(NSString *)aGroup
{
	NSMutableArray *returnWorks = [NSMutableArray array];
	if (![NSString isEmpty:aGroup])
	{
		NSMutableArray *works = [_requestGroups objectForKey:aGroup];
		if (works != nil)
		{
			for (RFWork *work in works)
			{
				if ([work.workName isEqualToString:aName])
				{
					[returnWorks addObject:work];
				}
			}
		}
	}
	return returnWorks;
}

+ (RFWorkMgr *)sharedRequestMgr
{
	static RFWorkMgr *s_instance = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		s_instance = [[RFWorkMgr alloc] init];
		s_instance.maxRunningWifi = kRFWorkRequestMgrMaxRunningWifi;
		s_instance.maxRunning3g = kRFWorkRequestMgrMaxRunning3g;
		s_instance.operationQueue.maxConcurrentOperationCount = s_instance.maxRunningWifi;
		NSLog(@"sharedRequestMgr:%@", s_instance);
	});
	
	return s_instance;
}

+ (RFWorkMgr *)sharedDownloadMgr
{
	static RFWorkMgr *s_instance = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		s_instance = [[RFWorkMgr alloc] init];
		s_instance.maxRunningWifi = kRFWorkDownloadMgrMaxRunningWifi;
		s_instance.maxRunning3g = kRFWorkDownloadMgrMaxRunning3g;
		s_instance.operationQueue.maxConcurrentOperationCount = s_instance.maxRunningWifi;
		NSLog(@"sharedDownloadMgr:%@", s_instance);
	});
	
	return s_instance;
}

+ (RFWorkMgr *)sharedImageMgr
{
	static RFWorkMgr *s_instance = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		s_instance = [[RFWorkMgr alloc] init];
		s_instance.maxRunningWifi = kRFWorkImageMgrMaxRunningWifi;
		s_instance.maxRunning3g = kRFWorkImageMgrMaxRunning3g;
		s_instance.operationQueue.maxConcurrentOperationCount = s_instance.maxRunningWifi;
		NSLog(@"sharedImageMgr:%@", s_instance);
	});
	
	return s_instance;
}

@end

@implementation RFWork
@synthesize workName = _workName;
@synthesize groupName = _groupName;
@synthesize workState = _workState;
@synthesize sender = _sender;
@synthesize object1 = _object1;
@synthesize object2 = _object2;
@synthesize object3 = _object3;
@synthesize tag = _tag;
@synthesize startBlock = _startBlock;
@synthesize successBlock = _successBlock;
@synthesize failedBlock = _failedBlock;
@synthesize cancelledBlock = _cancelledBlock;

- (id)init
{
	self = [super init];
    if (self)
    {
		isWorkFinish = NO;
		_workName = SAFE_ARC_RETAIN(RFWorkName([self class]));
		_groupName = @"";
		_workState = RFWorkStateInit;
    }
    return self;
}

- (void)dealloc
{
	[self rfCancelWorks];
	
	SAFE_ARC_RELEASE(_workName);
	SAFE_ARC_RELEASE(_groupName);
	SAFE_ARC_RELEASE(_object1);
	SAFE_ARC_RELEASE(_object2);
	SAFE_ARC_RELEASE(_object3);
	self.startBlock = nil;
	self.successBlock = nil;
	self.failedBlock = nil;
	self.cancelledBlock = nil;
	
    SAFE_ARC_SUPER_DEALLOC();
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@:%@ (%@, %@)"
			, _groupName
			, _workName
			, [super description]
			, [self stateString]
			];
}

- (void)startRelyOn:(id)obj
{
	if (obj == nil)
	{
		[[RFWorkMgr sharedRequestMgr] addWork:self];
	}
	else
	{
		[obj rfRunWork:self];
	}
}

- (void)start
{
	if (self.isCancelled)
    {
        [self cancelProc];
        return;
    }
	
	[self setExecuting:YES];
	[self main];
	
	if (self.isCancelled)
	{
		[self cancelProc];
        return;
	}
	
	[self enterRunning];
	[[NSRunLoop currentRunLoop] run];
	
	// 等待runloop结束
	do
	{
		BOOL bRun = [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantPast]];
		if (!bRun)
		{
			[NSThread sleepForTimeInterval:0.01];
		}
		
		if (self.isCancelled)
		{
			[self cancelProc];
			return;
		}
	}
	while (![self isFinished]);
}

- (void)main
{
	
}

- (void)cancel
{
	if ([self isCancelled])
	{
		return;
	}
	if ([self isFinished])
	{
		return;
	}
	[super cancel];
}

- (void)cancelProc
{
	[self enterCancelled];
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
	return isWorkExecuting;
}

- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    isWorkExecuting = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isFinished
{
	return isWorkFinish;
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    isWorkFinish = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setWorkFinish
{
	if (isWorkExecuting)
		self.executing = NO;
	if (!isWorkFinish)
		self.finished = YES;
}

- (void)notify
{
//	NSLog(@"notify...(%@)", self);
	[self rfPostEvent:_workName userInfo:nil];
}

- (void)enterRunning
{
	_workState = RFWorkStateStart;
	if (_startBlock != nil)
	{
		dispatch_async(dispatch_get_main_queue(), ^(){
			self.startBlock(self);
		});
	}
	[self notify];
	_workState = RFWorkStateRunning;
}

- (void)enterSuccess
{
	_workState = RFWorkStateSuccess;
	if (_successBlock != nil)
	{
		dispatch_async(dispatch_get_main_queue(), ^(){
			self.successBlock(self);
		});
	}
	[self notify];
	[self setWorkFinish];
}

- (void)enterCancelled
{
	_workState = RFWorkStateCancelled;
	if (_cancelledBlock != nil)
	{
		dispatch_async(dispatch_get_main_queue(), ^(){
			self.cancelledBlock(self);
		});
	}
	[self notify];
	[self setWorkFinish];
}

- (void)enterFailed
{
	_workState = RFWorkStateFailed;
	if (_failedBlock != nil)
	{
		dispatch_async(dispatch_get_main_queue(), ^(){
			self.failedBlock(self);
		});
	}
	[self notify];
	[self setWorkFinish];
}

+ (NSString *)workName:(Class)aClass
{
	if (![aClass isSubclassOfClass:[RFWork class]])
	{
		// 非RFWork的子类，异常
		NSException *e = [NSException
                          exceptionWithName: @"RFWorkName Error"
                          reason: @"input class is not RFWork's subclass"
                          userInfo: nil];
        @throw e;
	}
	return [RFKit className:aClass];
}

- (NSString *)stateString
{
	switch (_workState)
	{
		case RFWorkStateInit:
			return @"RFWorkStateInit";
		case RFWorkStateStart:
			return @"RFWorkStateStart";
		case RFWorkStateRunning:
			return @"RFWorkStateRunning";
		case RFWorkStateSuccess:
			return @"RFWorkStateSuccess";
		case RFWorkStateCancelled:
			return @"RFWorkStateCancelled";
		case RFWorkStateFailed:
			return @"RFWorkStateFailed";
		default:
			return @"";
	}
}

@end

@implementation NSObject (RFWork)

- (NSString *)rfWorkGroupName
{
	return [NSString stringWithFormat:@"%@_%p", [RFKit className:[self class]], self];
}

- (void)rfRunWork:(RFWork *)aWork
{
	[[RFWorkMgr sharedRequestMgr] addWork:aWork inGroup:[self rfWorkGroupName]];
}

- (void)rfRunImageWork:(RFWork *)aWork
{
	[[RFWorkMgr sharedImageMgr] addWork:aWork inGroup:[self rfWorkGroupName]];
}

- (void)rfRunDownloadWork:(RFWork *)aWork
{
	[[RFWorkMgr sharedDownloadMgr] addWork:aWork inGroup:[self rfWorkGroupName]];
}

- (void)rfCancelWorks
{
	[[RFWorkMgr sharedRequestMgr] cancelGroup:[self rfWorkGroupName]];
	[[RFWorkMgr sharedImageMgr] cancelGroup:[self rfWorkGroupName]];
	[[RFWorkMgr sharedDownloadMgr] cancelGroup:[self rfWorkGroupName]];
}

@end
