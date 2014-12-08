//
//  RFModel.h
//  PhotoThin
//
//  Created by gouzhehua on 14-12-5.
//  Copyright (c) 2014年 RefuseBT. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RFProperty(Property, MapName)	\
	@property (nonatomic, setter=_rfm_##MapName:) Property

@interface RFModel : NSObject
{
	
}

@end

@interface TmpModel	: RFModel
{
	
}
//@property (nonatomic, setter=_rfm_nameValue:) NSString *name;
//@property (nonatomic, setter=_rfm_sexValue:) NSInteger sex;

RFProperty(NSString *name, mapName);
RFProperty(NSInteger sex, mapSex);

//- (void)test;

@end

@interface TmpOtherModel : RFModel
{
	
}
RFProperty(NSUInteger value_NSUInteger, mapValue_NSUInteger);
RFProperty(short value_short, mapValue_short);
RFProperty(long long value_long_long, mapValue_long_long);
RFProperty(unsigned long long value_long_long_u, mapValue_long_long_u);
RFProperty(NSDictionary *value_NSDictionary, mapValue_NSDictionary);

@end