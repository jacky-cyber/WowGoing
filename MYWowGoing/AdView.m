//
//  AdView.m
//  stockmarket_infomation
//
//  Created by 神奇的小黄子 QQ:438172 on 12-12-10.
//  Copyright (c) 2012年 kernelnr. All rights reserved.
//

#import "AdView.h"
#import "ProductViewController.h"
#import "ADVBS.h"
 
#import "JSON.h"

#import "UIImageView+WebCache.h"
static AdView *shareManager = NULL;
@implementation MyUIScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging)
    {
        [[self nextResponder] touchesBegan:touches withEvent:event];
    }
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging)
    {
        [[self nextResponder] touchesMoved:touches withEvent:event];
    }
    [super touchesMoved:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging)
    {
        [[self nextResponder] touchesEnded:touches withEvent:event];
    }
    [super touchesEnded:touches withEvent:event];
}
@end

@implementation AdView
@synthesize arr_AdImgs=_arr_AdImgs;

#define ADIMG_INDEX 888
#define ADTITLE_INDEX   889
#define AD_BOTTOM_HEIGHT    12.f

+ (AdView *)sharedManager
{
	@synchronized(self)
	{
		if (!shareManager)
		{
            shareManager = [[self alloc] init];
        }
    }

	return shareManager;
}

- (void)hiddAdview {
    self.hidden = YES;
}
- (void)showAdview {
    self.hidden = NO;
}
#pragma mark - ----- init frame
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    NSAssert(self, @"Adview:self is nil...");
    
    if (nil != self)
    {
        // init...
        [self setFrame:frame];
        [self setBackgroundColor:[UIColor blackColor]];
        self.contentMode=UIViewContentModeScaleAspectFit;

        ADVBS *adbs = [[[ADVBS alloc] init] autorelease];
        adbs.delegate = self;
        adbs.onSuccessSeletor = @selector(adSuccess:);
        adbs.onFaultSeletor = @selector(adFault:);
        [adbs asyncExecute];
        [MBProgressHUD showHUDAddedTo:self animated:YES];
       
    }
    
    return self;
}

- (void)adSuccess:(ASIHTTPRequest *)requestFrom {
    [MBProgressHUD hideHUDForView:self animated:YES];
    ASIFormDataRequest *requestForm = (ASIFormDataRequest*)requestFrom;
    NSMutableDictionary *dic=nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0) {
        NSError *error=nil;
        if (requestForm.responseData.length>0) {
            
            dic= [NSJSONSerialization JSONObjectWithData:requestForm.responseData options: NSJSONReadingMutableContainers error:&error];  //IOS自带的JSON解析方法，但是适应用于IOS5以上系统
        }else{
            return;
        }
        if (error) {
        return;
        }
    
    }else{
        NSString *jsonString = [requestForm responseString];
        SBJsonParser *sbJsonParser=[SBJsonParser alloc];
        dic = [sbJsonParser objectWithString:jsonString];
        [sbJsonParser release];
    }

    
    BOOL resultStatus = [[dic objectForKey:@"resultStatus"] boolValue];
    NSLog(@"%d",resultStatus);
    if (!resultStatus) {
        return;
    }
    self.arr_AdImgs = [NSArray arrayWithArray:[dic objectForKey:@"advertisementList"]];
        
    [self drawMyinterface];
    
}

-(void)drawMyinterface{
    
    if (iPhone5) {
        sv_Ad = [[[MyUIScrollView alloc] initWithFrame:CGRectMake(self.frame.origin.x-10, self.frame.origin.y-46, self.frame.size.width, 330-AD_BOTTOM_HEIGHT)] autorelease];
    } else {
        sv_Ad = [[[MyUIScrollView alloc] initWithFrame:CGRectMake(self.frame.origin.x-10, self.frame.origin.y-46, self.frame.size.width, 240-AD_BOTTOM_HEIGHT)] autorelease];

    }
    sv_Ad.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [sv_Ad setDelegate:self];         // set delegate
    [sv_Ad setScrollEnabled:YES];
    [sv_Ad setPagingEnabled:YES];
    [sv_Ad setShowsHorizontalScrollIndicator:NO];
    [sv_Ad setShowsVerticalScrollIndicator:NO];
    [sv_Ad setAlwaysBounceVertical:NO];
    [sv_Ad setContentSize:CGSizeMake(302.f*([self.arr_AdImgs count]>0?[self.arr_AdImgs count]:0), sv_Ad.frame.size.height)];
    
    [self addSubview:sv_Ad];
    
    /* page ctrl */
    pc_AdPage = [[[UIPageControl alloc] initWithFrame:CGRectMake(0.f, 0.f, 64.f, 8.f)] autorelease];
    
    if (iPhone5) {
        [pc_AdPage setCenter:CGPointMake(sv_Ad.frame.size.width/2.f, sv_Ad.frame.size.height-10)];
    }else{
        [pc_AdPage setCenter:CGPointMake(sv_Ad.frame.size.width/2.f, self.frame.size.height-AD_BOTTOM_HEIGHT-130.f/2.f+38.f/2.f )];
    }
    pc_AdPage.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [pc_AdPage setUserInteractionEnabled:YES];
    [pc_AdPage setAutoresizesSubviews:YES];
    [pc_AdPage setAlpha:1.f];
    [pc_AdPage setCurrentPage:0];
    [pc_AdPage setNumberOfPages:([self.arr_AdImgs count]>0?[self.arr_AdImgs count]:0)];
    [self addSubview:pc_AdPage];
    
    [self adLoad];
}


/* ad loading... */
- (void)adLoad
{
    /* set timer */
    NSLog(@"adLoad");
    if (_adTimer) {
        [_adTimer invalidate];
        NSLog(@"time====nil");
        _adTimer = nil;
    }
    
   _adTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(changedAdTimer:) userInfo:nil repeats:YES];
    
    [self AddAdImg:self.arr_AdImgs];

}

#pragma mark - ----- -> 切换广告
static int cur_count = -1;
- (void)changedAdTimer:(NSTimer *)timer
{
//    NSLog(@"自动切换广告");
    cur_count = pc_AdPage.currentPage;
    ++cur_count;
    if (self.arr_AdImgs.count == 0 || self.arr_AdImgs == nil) {
        return;
    }
    pc_AdPage.currentPage = (cur_count%[self.arr_AdImgs count]);
    
    [UIView animateWithDuration:0.5f animations:^{
        sv_Ad.contentOffset = CGPointMake(pc_AdPage.currentPage*302.f, 0.f);
    }];
}

#pragma mark - ----- -> 初始化添加广告图片
- (void)AddAdImg:(NSArray*)arr_adimgs
{
    
    //广告为空的处理
    if (self.arr_AdImgs.count == 0) {
        UIImageView *img_Ad = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, sv_Ad.frame.size.height-AD_BOTTOM_HEIGHT)] autorelease];
        if (iPhone5) {
            img_Ad.frame=CGRectMake(0, 0, self.frame.size.width, sv_Ad.frame.size.height-AD_BOTTOM_HEIGHT);
        }
        
        img_Ad.backgroundColor=[UIColor clearColor];
        img_Ad.contentMode = UIViewContentModeScaleAspectFill;
        [img_Ad setImage:[UIImage imageNamed:@"首页底图.jpg"]];
        [img_Ad setUserInteractionEnabled:YES];
        [sv_Ad addSubview:img_Ad];
    }
    
    for (int i = 0; i < ([self.arr_AdImgs count]>0?[self.arr_AdImgs count]:0); i++)
    {
        UIImageView *img_Ad = [[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*i, 0.f, self.frame.size.width, sv_Ad.frame.size.height-AD_BOTTOM_HEIGHT)] autorelease];
        if (iPhone5) {

            img_Ad.frame=CGRectMake(self.frame.size.width*i, 0.f, self.frame.size.width, sv_Ad.frame.size.height-AD_BOTTOM_HEIGHT);
        }

        img_Ad.backgroundColor=[UIColor clearColor];
         img_Ad.contentMode = UIViewContentModeScaleAspectFill;

        
        //判断加载广告图片为空
        
        NSString *urlString = [[self.arr_AdImgs objectAtIndex:i] objectForKey:@"advertisementPicUrl"];
        if (urlString == nil || [urlString isEqualToString:@""]) {
            
            return;
        }
        [img_Ad setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"首页底图.jpg"]];
       
        [img_Ad setTag:ADIMG_INDEX+i];
        [img_Ad setUserInteractionEnabled:YES];
        [sv_Ad addSubview:img_Ad];
    }
}

#pragma mark - ----- -> 点击广告
- (void)OpenAd:(int)iTag
{
    [Single shareSingle].adNum = iTag;
    [Single shareSingle].advertisementId=[[self.arr_AdImgs objectAtIndex:iTag] objectForKey:@"advertisementId"];
    int advNum = [[[self.arr_AdImgs objectAtIndex:iTag] objectForKey:@"advertisementType"] intValue];
    [Single shareSingle].advertisementPriority = advNum;

}

#pragma mark - ----- -> scrollView opt
enum _jmpFalg { NORMAL = 0, LAST = -1, FIRST = 1 };
BOOL bJmp = NORMAL;
static float maxLoc = 0.f, minLoc = 0.f;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{ 
    pc_AdPage.currentPage=scrollView.contentOffset.x/302;//设置当前页的偏移位置
    [self setCurrentPage:pc_AdPage.currentPage];
}

#pragma mark ---------- 广告自动切换方法
- (void) setCurrentPage:(NSInteger)secondPage {
    
//    NSLog(@"setCurrentPage");
    //当手指滑动广告的时候清空timer 重新开始计时动画
    if (_adTimer) {
        [_adTimer invalidate];
        _adTimer = nil;
        _adTimer = [NSTimer scheduledTimerWithTimeInterval:4.5f target:self selector:@selector(changedAdTimer:) userInfo:nil repeats:YES];
    }
    for (NSUInteger subviewIndex = 0; subviewIndex < [pc_AdPage.subviews count]; subviewIndex++) { //从UIPageControl的subviews中获得每张图片，再替换
        UIImageView* subview = [pc_AdPage.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 24/4;
        size.width = 24/4;

        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,size.width,size.height)];
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //左右滑动广告框的时候走一下方法
    [UIView animateWithDuration:.7f animations:^{
        NSLog(@"a");
        [lbl_Info setText:[arr_AdTitles objectAtIndex:pc_AdPage.currentPage]];
        sv_Ad.contentOffset = CGPointMake((pc_AdPage.currentPage%[self.arr_AdImgs count])*302.f, 0.f);
    }];
    maxLoc = minLoc = sv_Ad.contentOffset.x;
}

#pragma mark ----- -> touches opt
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //UITouch *touch = [touches anyObject];
    //CGPoint startPos = [touch locationInView:self];

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //UITouch *touch = [touches anyObject];
    //CGPoint movePos = [touch locationInView:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint endPos;
    UIImageView *lbl_AdImg;
    for (int i = 0; i < ([self.arr_AdImgs count]>0?[self.arr_AdImgs count]:0); ++i)
    {
        lbl_AdImg = (UIImageView *)[self viewWithTag:ADIMG_INDEX+i];
        endPos = [touch locationInView:lbl_AdImg];
        if (endPos.x >= 0.f && endPos.x <= 320.f)
            [self OpenAd:i];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickPushAdview"  object:nil];
}

#pragma mark ----- -> release memory
- (void)dealloc
{
    [_arr_AdImgs release],self.arr_AdImgs=nil;
    [arr_AdTitles release];
    [_adTimer invalidate];
//    [_adTimer release],_adTimer = nil;
    [super dealloc];
}

@end
