//
//  RFRequestWork.h
//  XiaoXunTong
//
//  Created by gouzhehua on 14-8-4.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import "RFWork.h"
#import "RFCmdRequest.h"
#import "RFCmdBgRequest.h"

@interface RFRequestWork : RFWork <RFCmdRequestDelegate>
{

}
@property (nonatomic, SAFE_ARC_STRONG) RFCmdBaseRequest *workRequest;
@property (nonatomic, assign) RFCmdRequestType requestType;
@property (nonatomic, assign) BOOL isDownlodingNotify;
@property (nonatomic, assign) BOOL isUploadingNotify;
@property (nonatomic, SAFE_ARC_STRONG) RFWorkBlock downloadingBlock;
@property (nonatomic, SAFE_ARC_STRONG) RFWorkBlock uploadingBlock;
@property (nonatomic, assign) NSInteger resultCode;
@property (nonatomic, SAFE_ARC_STRONG) NSString *resultMsg;
@property (nonatomic, SAFE_ARC_STRONG) NSString *resultDesc;

- (id)init;
- (id)initWithUrl:(NSString *)anUrl args:(NSDictionary *)anArgs requestType:(RFCmdRequestType)aRequestType;

- (void)downloadingNotify;
- (void)uploadingNotify;

@end
