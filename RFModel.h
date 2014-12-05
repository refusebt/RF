//
//  RFModel.h
//  PhotoThin
//
//  Created by gouzhehua on 14-12-5.
//  Copyright (c) 2014年 RefuseBT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RFModel : NSObject
{
	
}

@end

@interface TmpModel	: RFModel
{
	
}
@property (nonatomic, strong, setter=_rf_nameValue:) NSString *name;

- (void)test;

@end

@interface TmpOtherModel : RFModel
{
	
}
@property (nonatomic, strong, setter=_rf_set_urlValue_url:, getter=_rf_get_urlValue_url) NSString *url;

@end