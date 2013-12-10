//
//  iToast.m
//  iToastDemo
//
//  Created by amao on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "iToast.h"
#import <QuartzCore/QuartzCore.h>

const CGFloat kToastTextPadding     = 15;
const CGFloat kToastButtonPaddding  = 20;
const CGFloat kToastLabelWidth      = 280;
const CGFloat kToastLabelHeight     = 60;
const CGFloat kToastMargin          = 45;
const CGFloat kToastXOffset         = 95;

@implementation iToast

@synthesize toastPosition;
@synthesize toastDuration;
@synthesize toastText;

- (id)init
{
    if (self = [super init])
    {
        toastPosition = kToastPositionCenter;
        toastDuration = kToastDurationNormal;
    }
    return self;
}

- (id)initWithText:(NSString *)text
{
    if (self = [super init])
    {
        toastPosition = kToastPositionCenter;
        toastDuration = kToastDurationNormal;
        self.toastText= text;
    }
    return self;
}

- (void)dealloc
{
    [toastText release];
    [super dealloc];
}

+ (iToast *)makeToast:(NSString *)text
{
    iToast *toast = [[iToast alloc]initWithText:text];
    return [toast autorelease];
}

- (void)show
{
    // 清除window上的 已经显示出来的toast
    UIWindow *cWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    for (NSObject  *obj in [cWindow subviews])
    {
        if([obj isKindOfClass:[iToast class]])
        {
            [(iToast*)obj hideToast:nil];
            [obj release];
            obj = nil;
        }
    }
    
    UIFont *font;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        font   = [UIFont systemFontOfSize:16];
    } else {
        font   = [UIFont systemFontOfSize:18];
    }
    CGSize textSize= [toastText sizeWithFont:font constrainedToSize:CGSizeMake(kToastLabelWidth, kToastLabelHeight)];
    // 默认为宽的 适应ipad  支持（4行显示）font 20  3
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, textSize.width + 2 * kToastTextPadding,textSize.height + 2 * kToastTextPadding)];
    // 还原为iphone版
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        label.frame = CGRectMake(0, 0, textSize.width + 2 * kToastTextPadding, textSize.height + 2 * kToastTextPadding);
    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
	label.font = font;
	label.text = toastText;
	label.numberOfLines = 0;
	label.shadowColor = [UIColor darkGrayColor];
	label.shadowOffset = CGSizeMake(1, 1);
    label.textAlignment = UITextAlignmentCenter;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        button.bounds = CGRectMake(0, 0, textSize.width + 2 * kToastButtonPaddding, textSize.height + 2 * kToastButtonPaddding);
    else
    {
        button.bounds = CGRectMake(0, 0, textSize.width + 2 * kToastButtonPaddding, textSize.height + 3 * kToastButtonPaddding);
    }
	label.center = CGPointMake(button.bounds.size.width / 2, button.bounds.size.height / 2);
	[button addSubview:label];
    [label release];
	
	button.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
	button.layer.cornerRadius = 5;
	
	UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    CGPoint point = window.center;

    CGPoint center = window.center;
    CGFloat dx = 0;
    
    UIInterfaceOrientation currentOrient= [UIApplication
                                           sharedApplication].statusBarOrientation;
    if (toastPosition == kToastPositionTop) 
    {
        point = CGPointMake(point.x, kToastMargin + button.bounds.size.height);
        dx    = center.x - kToastXOffset;
    }
    else if(toastPosition == kToastPositionBottom)
    {
        if (currentOrient == UIDeviceOrientationPortraitUpsideDown) {
            point = CGPointMake(point.x, kToastMargin + button.bounds.size.height);
        }else {
            point = CGPointMake(point.x, window.bounds.size.height - kToastMargin - button.bounds.size.height);
        }
        dx    = kToastXOffset - center.x ;
    }
    button.center = point;
    
    if(currentOrient == UIDeviceOrientationLandscapeRight)
    {
        CGAffineTransform rotateTransform   = CGAffineTransformMakeRotation((M_PI/2) * -1);
        CGAffineTransform translateTransform= CGAffineTransformMakeTranslation(-dx,center.y - point.y);
        CGAffineTransform t = CGAffineTransformConcat(rotateTransform,translateTransform);
        button.transform = CGAffineTransformConcat(button.transform, t);
    }
    else if(currentOrient == UIDeviceOrientationLandscapeLeft)
    {
        CGAffineTransform rotateTransform   = CGAffineTransformMakeRotation((M_PI/2));
        CGAffineTransform translateTransform= CGAffineTransformMakeTranslation(dx,center.y - point.y);
        CGAffineTransform t = CGAffineTransformConcat(rotateTransform,translateTransform);
        button.transform = CGAffineTransformConcat(button.transform, t);
    }
    else if(currentOrient == UIDeviceOrientationPortraitUpsideDown)
    {
        button.transform = CGAffineTransformRotate(button.transform, M_PI);
    }
    [window addSubview:button];
    view = button;
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:(CGFloat)toastDuration / 1000.0 
                                              target:self selector:@selector(onHideToast:) 
                                            userInfo:nil repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    
    [button addTarget:self action:@selector(hideToast:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)showInView:(UIView*)inview
{
    UIFont *font;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        font   = [UIFont systemFontOfSize:16];
    } else {
        font   = [UIFont systemFontOfSize:26];
    }
    CGSize textSize= [toastText sizeWithFont:font constrainedToSize:CGSizeMake(kToastLabelWidth, kToastLabelHeight)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, textSize.width + 2 * kToastTextPadding,
                                                              textSize.height + 2 * kToastTextPadding)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
	label.font = font;
	label.text = toastText;
	label.numberOfLines = 0;
	label.shadowColor = [UIColor darkGrayColor];
	label.shadowOffset = CGSizeMake(1, 1);
    label.textAlignment = UITextAlignmentCenter;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.bounds = CGRectMake(0, 0, textSize.width + 2 * kToastButtonPaddding, textSize.height + 2 * kToastButtonPaddding);
	label.center = CGPointMake(button.bounds.size.width / 2, button.bounds.size.height / 2);
	[button addSubview:label];
    [label release];
	
	button.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
	button.layer.cornerRadius = 5;
	
	UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    CGFloat w = inview.frame.size.width;
    CGFloat h = inview.frame.size.height;
    CGPoint point = CGPointMake(w / 2, h / 2); // pop 在左边
    //CGPoint point = CGPointMake( w , h / 2); // pop 在右边
    CGPoint center = CGPointMake(w / 2, h / 2);
    CGFloat dx = 0;
    
    UIInterfaceOrientation currentOrient= [UIApplication
                                           sharedApplication].statusBarOrientation;
    if (toastPosition == kToastPositionTop)
    {
        point = CGPointMake(point.x, kToastMargin + button.bounds.size.height);
        dx    = center.x - kToastXOffset;
    }
    else if(toastPosition == kToastPositionBottom)
    {
        if (currentOrient == UIDeviceOrientationPortraitUpsideDown)
        {
            point = CGPointMake(point.x, kToastMargin + button.bounds.size.height);
        }
        else
        {
            point = CGPointMake(point.x, inview.bounds.size.height - kToastMargin - button.bounds.size.height);
        }
        dx    = kToastXOffset - center.x ;
    }
    button.center = point;
    
    if(currentOrient == UIDeviceOrientationLandscapeRight)
    {
        CGAffineTransform rotateTransform   = CGAffineTransformMakeRotation((M_PI/2) * -1);
        CGAffineTransform translateTransform= CGAffineTransformMakeTranslation(-dx,center.y - point.y);
        CGAffineTransform t = CGAffineTransformConcat(rotateTransform,translateTransform);
        button.transform = CGAffineTransformConcat(button.transform, t);
    }
    else if(currentOrient == UIDeviceOrientationLandscapeLeft)
    {
        CGAffineTransform rotateTransform   = CGAffineTransformMakeRotation((M_PI/2));
        CGAffineTransform translateTransform= CGAffineTransformMakeTranslation(dx,center.y - point.y);
        CGAffineTransform t = CGAffineTransformConcat(rotateTransform,translateTransform);
        button.transform = CGAffineTransformConcat(button.transform, t);
    }
    else if(currentOrient == UIDeviceOrientationPortraitUpsideDown)
    {
        button.transform = CGAffineTransformRotate(button.transform, M_PI);
    }
    
    [window addSubview:button];
   
    view = button;
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:(CGFloat)toastDuration / 1000.0
                                             target:self selector:@selector(onHideToast:)
                                           userInfo:nil repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    [button addTarget:self action:@selector(hideToast:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showatPoint:(CGPoint)atPoint
{
    UIFont *font;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        font   = [UIFont systemFontOfSize:16];
    } else {
        font   = [UIFont systemFontOfSize:26];
    }
    CGSize textSize= [toastText sizeWithFont:font constrainedToSize:CGSizeMake(kToastLabelWidth, kToastLabelHeight)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, textSize.width + 2 * kToastTextPadding, textSize.height + 2 * kToastTextPadding)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
	label.font = font;
	label.text = toastText;
	label.numberOfLines = 0;
	label.shadowColor = [UIColor darkGrayColor];
	label.shadowOffset = CGSizeMake(1, 1);
    label.textAlignment = UITextAlignmentCenter;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.bounds = CGRectMake(0, 0, textSize.width + 2 * kToastButtonPaddding, textSize.height + 2 * kToastButtonPaddding);
	label.center = CGPointMake(button.bounds.size.width / 2, button.bounds.size.height / 2);
	[button addSubview:label];
    [label release];
	
	button.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
	button.layer.cornerRadius = 5;
	
	UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0]; // window的frame一直是768 1024 不随旋转而变化
    
    // 默认为竖屏的情况 如果是横屏幕 则进一步处理(home键在上方即屏幕颠倒时需要设置 显示位置有问题)
    CGPoint point = CGPointMake(atPoint.x / 2, atPoint.y / 2);
    CGPoint center = CGPointMake(atPoint.x / 2, atPoint.y / 2);
    CGFloat dx = 0;
    
    if(atPoint.x == 1024) // 处理全屏幕横屏的情况 比如瀑布流看大图
    {
        point = CGPointMake(atPoint.y / 2, atPoint.x / 2);
        center = CGPointMake(atPoint.y / 2, atPoint.x / 2);
    }
    // 由于暂时找不到好的方法传入正确的参数赋值给point  center
    // 因此只能将其写死了  加上固定的数值( 700  315)后  则竖屏向右旋转后正确 (button是加载window上的 因此当横屏时要使用transform旋转) 
    // 但是竖屏向左旋转时 就错误了 只能在下面  "注解1" 和 "注解2" 处继续加上固定的值
    // 目前只能这样  未找到正确合理方法   如果找到 会改过来
    else if(atPoint.x == 633) // 横屏左侧pop时 比如详情阅读
    {
        point = CGPointMake(window.center.x, 700);
        center = CGPointMake(window.center.x, 700);
    }
    else if(atPoint.x == 633 * 2 + 1) // 横屏右侧pop时 比如详情阅读
    {
        point = CGPointMake(window.center.x, 315 );
        center = CGPointMake(window.center.x, 315);
    }

    UIInterfaceOrientation currentOrient= [UIApplication sharedApplication].statusBarOrientation;
    if (toastPosition == kToastPositionTop)
    {
        point = CGPointMake(point.x, kToastMargin + button.bounds.size.height);
        dx    = center.x - kToastXOffset;
    }
    else if(toastPosition == kToastPositionBottom)
    {
        if (currentOrient == UIDeviceOrientationPortraitUpsideDown) // 竖着 并且上下颠倒时(home键在上方)
        {
            point = CGPointMake(point.x, kToastMargin + button.bounds.size.height); // 重新设置
        }
        
        else if(currentOrient == UIDeviceOrientationLandscapeLeft) // Pad朝左倒
        {
            point = CGPointMake(point.x, window.bounds.size.height - kToastMargin - button.bounds.size.height); // 重新设置
        }
        
        else if(currentOrient == UIDeviceOrientationPortrait || currentOrient == UIDeviceOrientationLandscapeRight)
        {
            point = CGPointMake(point.x, window.bounds.size.height - kToastMargin - button.bounds.size.height);
        }
        
        dx    = kToastXOffset - center.x;
    }
    button.center = point;
    
    // 旋转toastView 竖屏不颠倒时 不进入任何一个if和else 否则进入
    if(currentOrient == UIDeviceOrientationLandscapeRight) // 向右转了屏幕时
    {
        CGAffineTransform rotateTransform   = CGAffineTransformMakeRotation((M_PI/2) * -1);
        CGAffineTransform translateTransform= CGAffineTransformMakeTranslation(-dx,center.y - point.y);
        CGAffineTransform t = CGAffineTransformConcat(rotateTransform,translateTransform);
        button.transform = CGAffineTransformConcat(button.transform, t);
    }
    else if(currentOrient == UIDeviceOrientationLandscapeLeft) // 向左转了屏幕时
    { 
        CGAffineTransform rotateTransform   = CGAffineTransformMakeRotation((M_PI/2));
        CGAffineTransform translateTransform= CGAffineTransformMakeTranslation(dx , center.y - point.y);
        if(atPoint.x == 633) // 注解1  横屏左PopView  向左旋转后位置错误 加上固定值 矫正位置
            translateTransform= CGAffineTransformMakeTranslation(dx , center.y - point.y  - 400);
        if(atPoint.x == 633 * 2 + 1) // 注解2   横屏右PopView
            translateTransform= CGAffineTransformMakeTranslation(dx , center.y - point.y  + 400);
        CGAffineTransform t = CGAffineTransformConcat(rotateTransform,translateTransform);
        button.transform = CGAffineTransformConcat(button.transform, t);
    }
    else if(currentOrient == UIDeviceOrientationPortraitUpsideDown) // 竖屏 但上下颠倒时(home键在上方)  进入此处
    {
//        button.transform = CGAffineTransformRotate(button.transform, M_PI);
        CGAffineTransform rotateTransform   = CGAffineTransformMakeRotation(M_PI);
        CGAffineTransform translateTransform= CGAffineTransformMakeTranslation(256, 0);
        if(atPoint.x == 512) // 竖屏左侧PopView时
            translateTransform= CGAffineTransformMakeTranslation(256, 0);
        if(atPoint.x == 512 * 2 +1)
            translateTransform= CGAffineTransformMakeTranslation(-256, 0);
        CGAffineTransform t = CGAffineTransformConcat(rotateTransform,translateTransform);
        button.transform = CGAffineTransformConcat(button.transform, t);
    }
    
    [window addSubview:button];
    
    view = button;
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:(CGFloat)toastDuration / 1000.0
                                             target:self selector:@selector(onHideToast:)
                                           userInfo:nil repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    [button addTarget:self action:@selector(hideToast:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)hideToast:(id)sender
{
    [self doHideToast];
}

- (void)onHideToast:(NSTimer *)timer
{
    [self doHideToast];
}

- (void)doHideToast
{
    [UIView beginAnimations:nil context:nil];
	view.alpha = 0;
	[UIView commitAnimations];
	
	NSTimer *timer = [NSTimer timerWithTimeInterval:500 
                                              target:self selector:@selector(onRemoveToast:)
                                            userInfo:nil repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

}

- (void)onRemoveToast:(NSTimer *)timer
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    for (UIView *subView in window.subviews)
    {
        if (subView == view)
        {
            [view removeFromSuperview];
            break;
        }
    }
    view = nil;
}

+ (void)hideToastForView:(UIView *)inView
{
	UIView *viewToRemove = nil;
	for (UIView *v in [inView subviews])
    {
		if ([v isKindOfClass:[iToast class]])
        {
			viewToRemove = v;
		}
	}
	if (viewToRemove != nil)
    {
		iToast *toast = (iToast *)viewToRemove;
		[toast doHideToast];
	}
}

@end
