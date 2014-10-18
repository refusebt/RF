//
//  RFBaseViewController.m
//  XiaoXunTong
//
//  Created by gouzhehua on 14-8-4.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import "RFBaseViewController.h"
#import "RF.h"
#import "ARCMacros.h"

@interface RFBaseViewController ()
{

}
@property (nonatomic, SAFE_ARC_STRONG) UIView *viewResignInputResponder;
@property (nonatomic, SAFE_ARC_STRONG) NSMutableArray *inputResponders;

- (void)addInputResponder:(UIResponder *)aResponder;
- (void)removeInputResponder:(UIResponder *)aResponder;
- (NSMutableArray *)inputResponders;

@end

@implementation RFBaseViewController
@synthesize inputResponders = _inputResponders;
@synthesize viewResignInputResponder = _viewResignInputResponder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
	{
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	[self rfUnwatchEvents];
	[self rfCancelWorks];
	
	[self removeAllInputResponders];
	SAFE_ARC_RELEASE(_inputResponders);
	SAFE_ARC_RELEASE(_viewResignInputResponder);
	
	SAFE_ARC_SUPER_DEALLOC();
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	{
		self.viewResignInputResponder = [[UIView alloc] initWithFrame:self.view.frame];
		[_viewResignInputResponder setFrameOrigin:0 top:0];
		[_viewResignInputResponder setTapActionWithTarget:self selector:@selector(removeAllInputResponders)];
		_viewResignInputResponder.userInteractionEnabled = NO;
		[self.view insertSubview:_viewResignInputResponder atIndex:0];
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	
	[self rfUnwatchEvents];
	[self rfCancelWorks];
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
	
	[self rfWatchObject:nil event:UITextFieldTextDidBeginEditingNotification mainBlock:^(NSNotification *note){
		[self addInputResponder:note.object];
	}];
	
	[self rfWatchObject:nil event:UITextFieldTextDidEndEditingNotification mainBlock:^(NSNotification *note){
		[self removeInputResponder:note.object];
	}];
	
	[self rfWatchObject:nil event:UITextViewTextDidBeginEditingNotification mainBlock:^(NSNotification *note){
		[self addInputResponder:note.object];
	}];
	
	[self rfWatchObject:nil event:UITextViewTextDidEndEditingNotification mainBlock:^(NSNotification *note){
		[self removeInputResponder:note.object];
	}];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[self removeAllInputResponders];
	[self rfUnwatchObject:nil event:UITextFieldTextDidBeginEditingNotification];
	[self rfUnwatchObject:nil event:UITextFieldTextDidEndEditingNotification];
	[self rfUnwatchObject:nil event:UITextViewTextDidBeginEditingNotification];
	[self rfUnwatchObject:nil event:UITextViewTextDidEndEditingNotification];
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

- (void)removeAllInputResponders
{
	if (_inputResponders != nil)
	{
		NSMutableArray *ret = [NSMutableArray array];
		for (UIResponder *ir in _inputResponders)
		{
			[ret addObject:ir];
		}
		
		for (UIResponder *ir in ret)
		{
			[ir resignFirstResponder];
		}
		
		[_inputResponders removeAllObjects];
		_viewResignInputResponder.userInteractionEnabled = NO;
	}
}

- (void)addInputResponder:(UIResponder *)aResponder
{
	if (_inputResponders == nil)
	{
		self.inputResponders = [NSMutableArray array];
	}
	[_inputResponders addObject:aResponder];
	_viewResignInputResponder.userInteractionEnabled = YES;
}

- (void)removeInputResponder:(UIResponder *)aResponder
{
	if (_inputResponders != nil)
	{
		[aResponder resignFirstResponder];
		[_inputResponders removeObject:aResponder];
		if (_inputResponders.count == 0)
		{
			_viewResignInputResponder.userInteractionEnabled = NO;
		}
	}
}

- (NSMutableArray *)inputResponders
{
	if (_inputResponders == nil)
	{
		self.inputResponders = [NSMutableArray array];
	}
	return _inputResponders;
}

@end
