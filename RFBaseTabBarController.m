//
//  RFBaseTabBarController.m
//  XiaoXunTong
//
//  Created by gouzhehua on 14-8-4.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import "RFBaseTabBarController.h"
#import "RF.h"

@interface RFBaseTabBarController ()

@end

@implementation RFBaseTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
	{
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
	NSLog(@"viewDidAppear:%s", object_getClassName(self));
	
	[super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	NSLog(@"viewDidDisappear:%s", object_getClassName(self));
	
	[super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
	return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
