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

#pragma mark RFEvent

@interface RFEvent : NSObject
{
	
}
@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, weak) id watchObject;
@property (nonatomic, weak) id observerObject;
@property (nonatomic, assign) SEL action;
@property (nonatomic, strong) RFEventBlock block;
@property (nonatomic, assign) BOOL isMainRun;

@end

@implementation RFEvent
@synthesize eventName = _eventName;
@synthesize watchObject = _watchObject;
@synthesize observerObject = _observerObject;
@synthesize action = _action;
@synthesize block = _block;
@synthesize isMainRun = _isMainRun;

- (void)dealloc
{
//	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//	[nc removeObserver:_observerObject name:_eventName object:_watchObject];
	
	_eventName = nil;
	_watchObject = nil;
	_observerObject = nil;
	_action = NULL;
	self.block = nil;
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
	RFEvent *re = [[RFEvent alloc] init];
	re.eventName = anEvent;
	re.watchObject = anObject;
	re.observerObject = self;
	re.action = anAction;
	re.block = nil;
	re.isMainRun = NO;
	[self rfWatchObject:anObject event:anEvent rfEvent:re];
}

- (void)rfWatchObject:(id)anObject event:(NSString *)anEvent mainAction:(SEL)anAction
{
	RFEvent *re = [[RFEvent alloc] init];
	re.eventName = anEvent;
	re.watchObject = anObject;
	re.observerObject = self;
	re.action = anAction;
	re.block = nil;
	re.isMainRun = YES;
	[self rfWatchObject:anObject event:anEvent rfEvent:re];
}

- (void)rfWatchObject:(id)anObject event:(NSString *)anEvent block:(RFEventBlock)aBlock
{
	RFEvent *re = [[RFEvent alloc] init];
	re.eventName = anEvent;
	re.watchObject = anObject;
	re.observerObject = self;
	re.action = NULL;
	re.block = aBlock;
	re.isMainRun = NO;
	[self rfWatchObject:anObject event:anEvent rfEvent:re];
}

- (void)rfWatchObject:(id)anObject event:(NSString *)anEvent mainBlock:(RFEventBlock)aBlock
{
	RFEvent *re = [[RFEvent alloc] init];
	re.eventName = anEvent;
	re.watchObject = anObject;
	re.observerObject = self;
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
		__weak NSObject *selfRef = self;
		[nc addObserverForName:anEvent
						object:anObject
						 queue:[NSOperationQueue mainQueue]
					usingBlock:^(NSNotification *note){
						[selfRef rfHandleRFEventBlockCallback:note];
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
	[[self rfEvents] removeAllObjects];
}

- (void)rfUnwatchObject:(id)anObject
{
	NSMutableDictionary *dict = [self rfEvents];
	NSArray *keys = [dict allKeys];
	for (NSString *key in keys)
	{
		RFEvent *re = [dict objectForKey:key];
		if (re.watchObject == anObject)
		{
			[dict removeObjectForKey:key];
		}
	}
}

- (void)rfUnwatchObject:(id)anObject event:(NSString *)anEvent
{
	NSMutableDictionary *dict = [self rfEvents];
	NSArray *keys = [dict allKeys];
	for (NSString *key in keys)
	{
		RFEvent *re = [dict objectForKey:key];
		if ((re.watchObject == anObject) && [re.eventName isEqualToString:anEvent])
		{
			[dict removeObjectForKey:key];
		}
	}
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
