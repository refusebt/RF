//
//  RFUITextField.h
//  RF
//
//  Created by gouzhehua on 14-8-1.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARCMacros.h"

@interface RFUITextField : UIView
{

}
@property (nonatomic, SAFE_ARC_STRONG) UITextField *tfInput;
@property (nonatomic, copy) BOOL (^blockShouldBeginEditing)(RFUITextField *);
@property (nonatomic, copy) BOOL (^blockShouldChangeCharactersInRange)(RFUITextField *, NSRange, NSString *);
@property (nonatomic, copy) BOOL (^blockShouldReturn)(RFUITextField *);

@end
