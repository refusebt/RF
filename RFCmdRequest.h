//
//  RFCmdRequest.h
//  RFApp
//
//  Created by gouzhehua on 14-7-17.
//  Copyright (c) 2014年 skyinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFCmdBaseRequest.h"

@interface RFCmdRequest : RFCmdBaseRequest
{

}
@property (nonatomic, SAFE_ARC_STRONG) NSURLConnection *urlConnection;

@end
