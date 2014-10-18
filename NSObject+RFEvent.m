//
//  NSObject+RFEvent.m
//  RF
//
//  Created by gouzhehua on 14-6-23.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import "NSObject+RFEvent.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "ARCMacros.h"

#pragma mark RFEvent

@interface RFEvent : NSObject
{
	
}
@property (SAFE_ARC_STRONG) NSString *eventName;
@property (SAFE_ARC_WEAK) id watchObject;
@property (assign) SEL action;
@property (SAFE_ARC_STRONG) RFEventBlock block;
@property (assign) BOOL isMainRun;

@end

@implementation RFEvent
@synthesize eventName = _eventName;
@synthesize watchObject = _watchObject;
@synthesize action = _action;
@synthesize block = _block;
@synthesize isMainRun = _isMainRun;

- (void)dealloc
{
	SAFE_ARC_RELEASE(eventName);
	self.block = nil;
	
	SAFE_ARC_SUPER_DEALLOC();
}

- (NSString *)description
{
	if (_block == nil)
	{
		return [NSString stringWithFormat:@"%@ : %@ : %s", _eventName, _watchObject, sel_getName(_action)];
	}
	else
	{
		return [NSString stringWithFormat:@"%@ : %@ : block", _eventName, _watchObject];
	}
}

@end

#pragma mark NSObject (RFEvent)

@interface NSObject (RFEventInner)
- (void)rfWatchObject:(id)anObject event:(NSString *)anEvent rfEvent:(RFEvent *)aRFEvent;
@end

@implementation NSObject (RFEvent)

- (NSMutableDictionary *)rfEvents
{
	static void * kRFEventsKey = "kRFEventsKey";
	NSMutableDictionary *dict = (NSMutableDictionary *)objc_getAssociatedObject(self, kRFEventsKey);
	if (dict == nil)
	{
		dict = [NSMutableDictionary dictionary];
		objc_setAssociatedObject(self, kRFEventsKey, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return dict;
}

- (void)rfWatchObject:(id)anObject event:(NSString *)anEvent action:(SEL)anAction
{
	RFEvent *re = SAFE_ARC_AUTORELEASE([[RFEvent alloc] init]);
	re.eventName = anEvent;
	re.watchObject = anObject;
	re.action = anAction;
	re.block = nil;
	re.isMainRun = NO;
	[self rfWatchObject:anObject event:anEvent rfEvent:re];
}

- (void)rfWatchObject:(id)anObject event:(NSString *)anEvent mainAction:(SEL)anAction
{
	RFEvent *re = SAFE_ARC_AUTORELEASE([[RFEvent alloc] init]);
	re.eventName = anEvent;
	re.watchObject = anObject;
	re.action = anAction;
	re.block = nil;
	re.isMainRun = YES;
	[self rfWatchObject:anObject event:anEvent rfEvent:re];
}

- (void)rfWatchObject:(id)anObject event:(NSString *)anEvent block:(RFEventBlock)aBlock
{
	RFEvent *re = SAFE_ARC_AUTORELEASE([[RFEvent alloc] init]);
	re.eventName = anEvent;
	re.watchObject = anObject;
	re.action = NULL;
	re.block = aBlock;
	re.isMainRun = NO;
	[self rfWatchObject:anObject event:anEvent rfEvent:re];
}

- (void)rfWatchObject:(id)anObject event:(NSString *)anEvent mainBlock:(RFEventBlock)aBlock
{
	RFEvent *re = SAFE_ARC_AUTORELEASE([[RFEvent alloc] init]);
	re.eventName = anEvent;
	re.watchObject = anObject;
	re.action = NULL;
	re.block = aBlock;
	re.isMainRun = YES;
	[self rfWatchObject:anObject event:anEvent rfEvent:re];
}

- (void)rfWatchObject:(id)anObject event:(NSString *)anEvent rfEvent:(RFEvent *)aRFEvent
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self name:anEvent object:anObject];
	if (aRFEvent.isMainRun)
	{
		[nc addObserverForName:anEvent
						object:anObject
						 queue:[NSOperationQueue mainQueue]
					usingBlock:^(NSNotification *note){
						[self rfHandleRFEventBlockCallback:note];
					}];
	}
	else
	{
		[nc addObserver:self selector:@selector(rfHandleRFEventBlockCallback:) name:anEvent object:anObject];
	}
	[[self rfEvents] setObject:aRFEvent forKey:anEvent];
}

- (void)rfUnwatchEvents
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	NSMutableDictionary *dict = [self rfEvents];
	for (NSString *key in dict)
	{
		RFEvent *re = [dict objectForKey:key];
		[nc removeObserver:self name:re.eventName object:re.watchObject];
	}
	[dict removeAllObjects];
}

- (void)rfUnwatchObject:(id)anObject
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	NSMutableDictionary *dict = [self rfEvents];
	NSMutableArray *removeKeys = [NSMutableArray array];
	for (NSString *key in dict)
	{
		RFEvent *re = [dict objectForKey:key];
		if (re.watchObject == anObject)
		{
			[nc removeObserver:self name:re.eventName object:re.watchObject];
			[removeKeys addObject:key];
		}
	}
	[dict removeObjectsForKeys:removeKeys];
}

- (void)rfUnwatchObject:(id)anObject event:(NSString *)anEvent
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	NSMutableDictionary *dict = [self rfEvents];
	NSMutableArray *removeKeys = [NSMutableArray array];
	for (NSString *key in dict)
	{
		RFEvent *re = [dict objectForKey:key];
		if ([re.eventName isEqualToString:anEvent])
		{
			[nc removeObserver:self name:re.eventName object:re.watchObject];
			[removeKeys addObject:key];
		}
	}
	[dict removeObjectsForKeys:removeKeys];
}

- (void)rfPostEvent:(NSString *)anEvent userInfo:(NSDictionary *)anUserInfo
{
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:(NSString*)anEvent object:self userInfo:anUserInfo];
}

- (void)rfHandleRFEventBlockCallback:(NSNotification *)aNote
{
	NSString *eventName = aNote.name;
	NSMutableDictionary *dict = [self rfEvents];
	RFEvent *re = [dict objectForKey:eventName];
	if (re != nil)
	{
		if (re.action != NULL)
		{
			objc_msgSend(self, re.action, aNote);
		}
		else if (re.block != nil)
		{
			re.block(aNote);
		}
	}
}

@end
