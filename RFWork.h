//
//  RFWork.h
//  RF
//
//  Created by gouzhehua on 14-8-4.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import <Foundation/Foundation.h>

// 注：RFWork的子类不要添加start名称的属性，会导致无法启动

#define kRFWorkRequestMgrMaxRunningWifi		5
#define kRFWorkDownloadMgrMaxRunningWifi	1
#define kRFWorkImageMgrMaxRunningWifi		3

#define kRFWorkRequestMgrMaxRunning3g		2
#define kRFWorkDownloadMgrMaxRunning3g		1
#define kRFWorkImageMgrMaxRunning3g			1

#define RFWorkName(aClass)	\
	[RFWork workName:aClass]

typedef void(^RFWorkBlock)(id aWork);

@class RFWork;
@class RFWorkMgr;

typedef enum
{
	RFWorkStateInit = 0,
	RFWorkStateStart,			// 自动通知
	RFWorkStateRunning,			// 子类试情况通知（下载，上传等）
	RFWorkStateSuccess,			// 子类通知
	RFWorkStateCancelled,		// 自动通知
	RFWorkStateFailed,			// 子类通知
}
RFWorkState;

@interface RFWorkMgr : NSObject
{
	
}
@property (nonatomic, assign) NSInteger maxRunningWifi;
@property (nonatomic, assign) NSInteger maxRunning3g;
@property (nonatomic, strong) NSMutableDictionary *requestGroups;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

- (void)addWork:(RFWork *)aWork;
- (void)addWork:(RFWork *)aWork inGroup:(NSString *)aGroup;

- (void)cancelAll;
- (void)cancelGroup:(NSString *)aGroup;
- (void)cancelWork:(NSString *)aName;
- (void)cancelWork:(NSString *)aName inGroup:(NSString *)aGroup;

- (BOOL)isWorkRun:(NSString *)aName;
- (BOOL)isWorkRun:(NSString *)aName inGroup:(NSString *)aGroup;

- (NSArray *)findWork:(NSString *)aName;
- (NSArray *)findWork:(NSString *)aName inGroup:(NSString *)aGroup;

+ (RFWorkMgr *)sharedRequestMgr;
+ (RFWorkMgr *)sharedDownloadMgr;
+ (RFWorkMgr *)sharedImageMgr;

@end

@interface RFWork : NSOperation
{
	BOOL isWorkFinish;
	BOOL isWorkExecuting;
}
@property (nonatomic, strong) NSString *workName;
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, assign) RFWorkState workState;
@property (nonatomic, weak) id sender;
@property (nonatomic, strong) id object1;
@property (nonatomic, strong) id object2;
@property (nonatomic, strong) id object3;
@property (nonatomic, assign) int64_t tag;
@property (nonatomic, strong) RFWorkBlock startBlock;
@property (nonatomic, strong) RFWorkBlock successBlock;
@property (nonatomic, strong) RFWorkBlock failedBlock;
@property (nonatomic, strong) RFWorkBlock cancelledBlock;

- (id)init;

- (void)startByOwner:(id)obj;

- (void)main;		// 子类重写
- (void)cancel;
- (void)cancelProc;	// 子类重写

- (void)setWorkFinish;

- (void)notify;
- (void)enterRunning;
- (void)enterSuccess;
- (void)enterCancelled;
- (void)enterFailed;

+ (NSString *)workName:(Class)aClass;

@end

@interface NSObject (RFWork)
- (NSString *)rfWorkGroupName;
- (void)rfRunWork:(RFWork *)aWork;
- (void)rfRunImageWork:(RFWork *)aWork;
- (void)rfRunDownloadWork:(RFWork *)aWork;
- (void)rfCancelWorks;
- (void)rfCancelWorksAuto;
@end
