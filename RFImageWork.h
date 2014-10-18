//
//  RFImageWork.h
//  XiaoXunTong
//
//  Created by gouzhehua on 14-8-11.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import "RFWork.h"
#import "RFCmdBaseRequest.h"

@interface RFImageWork : RFWork <RFCmdRequestDelegate>
{

}
@property (nonatomic, SAFE_ARC_STRONG) RFCmdBaseRequest *workRequest;
@property (nonatomic, SAFE_ARC_STRONG) RFWorkBlock downloadingBlock;
@property (nonatomic, SAFE_ARC_STRONG) UIImage *image;

- (id)initWithUrl:(NSString *)anUrl;

@end
