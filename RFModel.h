//
//  RFModel.h
//  PhotoThin
//
//  Created by gouzhehua on 14-12-5.
//  Copyright (c) 2014年 RefuseBT. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JProperty(Property, MapName)	\
	@property (nonatomic, setter=_rfm_##MapName:) Property

@interface RFModel : NSObject
{
	
}

- (void)fillWithJsonDict:(NSDictionary *)jsonDict;

@end

@interface TmpModel	: RFModel
{
	
}
JProperty(NSUInteger value_NSUInteger, mapValue_NSUInteger);
JProperty(short value_short, mapValue_short);
JProperty(long long value_long_long, mapValue_long_long);
JProperty(unsigned long long value_long_long_u, mapValue_long_long_u);
JProperty(NSDictionary *value_NSDictionary, mapValue_NSDictionary);

@end
