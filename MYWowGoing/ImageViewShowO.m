//
//  imageViewShowO.m
//  HuaShangQ_iPhone
//
//  Created by lyy on 12-11-16.
//
//

#import "ImageViewShowO.h"

#import "FileBSDownload.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "SDImageCache.h"

#define MAX_WIDTH  320
#define MAX_HEIGHT [[UIScreen mainScreen] bounds].size.height - 44


@implementation ImageViewShowO

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.downloadView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height - 44)] autorelease];
        _downloadView.backgroundColor = [UIColor clearColor];
        //背景图片
        UIImageView *iv = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]] autorelease];
        iv.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        iv.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
        [_downloadView addSubview:iv];
        
        _labelDownloadError = [[UILabel alloc] initWithFrame:CGRectMake(87, 305, 151, 30)];
        _labelDownloadError.backgroundColor = [UIColor clearColor];
        _labelDownloadError.textAlignment = UITextAlignmentCenter;
        _labelDownloadError.text = (@"图片下载失败");
        [_labelDownloadError setFont:[UIFont systemFontOfSize:15]];
        _labelDownloadError.textColor = [UIColor grayColor];
        _labelDownloadError.hidden = YES;
        [_downloadView addSubview:_labelDownloadError];
        
        self.progress = [[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault] autorelease];
        _progress.frame = CGRectMake(80, 305, 156, 9);
        _progress.progress = 0.0f;
        _progress.hidden = TRUE;
        [_downloadView addSubview:_progress];
        
        /*
        UIActivityIndicatorView *activityindicatorview = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        activityindicatorview.frame = CGRectMake(80, 280, 20.0, 20.0);
        [activityindicatorview startAnimating];
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(75,280, 200.0, 20.0)] autorelease];
        label.text = LocalizedString(@"正在加载, 请稍候...") ;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor darkGrayColor];
        label.textAlignment = UITextAlignmentCenter;
        [_downloadView addSubview:activityindicatorview];
         */
        
        _downloadView.hidden = FALSE;
        
        _pageIndex = -1;

        self.scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, [[UIScreen mainScreen] bounds].size.height - 44)] autorelease];
        _scrollView.canCancelContentTouches = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bouncesZoom = NO;
        self.imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height)] autorelease];
        [_imageView setBackgroundColor:[UIColor clearColor]];
        [_scrollView addSubview:_imageView];
        [self  addSubview:_scrollView];
        [self  addSubview:_downloadView];

    }
    return self;
}

- (void)dealloc
{
    [_scrollView release];
    [_imageView release];
    [_image release];
    [_downloadView release];
    [_progress release];
    [super dealloc];
}

- (void)loadImageWithURL:(NSString*)imageURL
{
    if(imageURL)
    {
        [self  downLoadImage:imageURL];
    }
}

- (void)loadImageWithIMG:(UIImage *)image
{
    if(image)
    {
        self.image = image;
        [self setImageViewFrame];
    }
}

- (void)downLoadImage:(NSString*)imageURL
{
    // 显示加载中
    [self.downloadView setHidden:NO];
    [self.progress setHidden:NO];
    
    // 先本地找找
//    NSString *dest = nil;
    // 设置缓存路径
//    if(imageURL != nil)
//        dest = [[SDImageCache sharedImageCache] cachePathForKey: imageURL];
//    // 如果本地存在此图片 则不下载 直接使用
//    UIImage *imageLoc = [UIImage imageWithContentsOfFile:dest];
//    if(imageLoc)
//    {
//        NSLog(@"本地有图片 直接使用");
//        self.image = imageLoc;
//        [self setImageViewFrame];
//        return;
//    }
    
    if (imageURL)
    {
        FileBSDownload *bs = [[[FileBSDownload alloc] init]autorelease];
        bs.url = imageURL;
        bs.delegate  = self;
        bs.progress = self.progress;
        bs.onSuccessSeletor = @selector(onImageDownloadSuccessSeletor:);
        bs.onFaultSeletor = @selector(onImageDownloadFailedSeletor:);
        [bs asyncExecute];
    }
}

// 图片下载成功
- (void)onImageDownloadSuccessSeletor:(NSString*)path
{
    [self.progress     setHidden:YES];
    [self.downloadView setHidden:YES];
    if(path.length == 0)
    {
        return;
    }
    
    self.image = [UIImage imageWithContentsOfFile:path];
    if(self.image)
    {
       
        [self setImageViewFrame];

    }
    else
    {
        
        [self.labelDownloadError setHidden:NO];
        [self.downloadView setHidden:NO]; // 显示默认图片
    }
}

// 图片下载失败
- (void)onImageDownloadFailedSeletor:(NSString*)path
{
   
    [self.progress setHidden:YES];
    [self.labelDownloadError setHidden:NO];
    [self.downloadView setHidden:NO];
}

//设置图片居中显示
- (void)setImageViewFrame
{
    [self.downloadView setHidden:YES];
    [self.progress setHidden:YES];
    // 设置图片域的图片和frame
    CGSize size = [self scaleFromImage:self.image];
    
    // 原图宽高
    CGFloat iw = size.width;
    CGFloat ih = size.height;
    // 屏幕宽高
    CGFloat w = 320;
    CGFloat h = [[UIScreen mainScreen] bounds].size.height - 44;
    
    // 计算图片居中的坐标 当图片大于屏幕时 x和y轴为0
    CGFloat ix = ((w - iw) > 0 ? (w - iw) : 0 ) / 2;
    CGFloat iy = ((h - ih) > 0 ? (h - ih) : 0 ) / 2;
    
    // 设置显示图片frame
    [self.imageView setFrame:CGRectMake(ix, iy, iw, ih)];
    self.scrollView.contentSize = self.imageView.frame.size;
    [self.imageView setImage:_image];
    // 缩放比率
    self.scrollView.maximumZoomScale = MAX(1, self.scrollView.zoomScale*3);
    self.scrollView.minimumZoomScale = MIN(1, self.scrollView.zoomScale*1);
}

- (CGSize)scaleFromImage: (UIImage *) image
{
    int h = image.size.height;
    int w = image.size.width;
    
    if(MAX_WIDTH < w)
    {
        float b = (float)MAX_WIDTH/w < (float)MAX_HEIGHT/h ? (float)MAX_WIDTH/w : (float)MAX_HEIGHT/h;
        CGSize itemSize = CGSizeMake(b*w, b*h);
        return itemSize;
    }
    else
        return CGSizeMake(w, h);
}

// 返回要缩放的view
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

//缩放时居中图片
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self setImageViewCenter];
}

// 设置图片居中
- (void)setImageViewCenter
{
    // 原图宽高
    CGFloat iw = _imageView.frame.size.width;
    CGFloat ih = _imageView.frame.size.height;
    // 屏幕宽高
    CGFloat w = 320;
    CGFloat h = [[UIScreen mainScreen] bounds].size.height - 44;
    // 计算图片的中心点
    CGFloat cx = (w > iw ? w : iw) / 2;
    CGFloat cy = (h > ih ? h : ih) / 2;
    // 设置图片居中
    if(w - iw > 0 && h - ih > 0)
        self.scrollView.contentOffset = CGPointMake(0, 0);
    
    self.imageView.center = CGPointMake(cx, cy);
    self.scrollView.contentSize = self.imageView.frame.size;
}

@end

@implementation WeiboItemImage

- (id)init
{
    if (self = [super init])
    {
        _smallUrl = @"";
        _bigUrl = @"";
        _albumID = @"";
        _albumTitle = @"";
        _albumNum = @"0";
        _albumSubURL = @"";
    }
    return self;
}

- (void)dealloc
{
    [_smallUrl release];
    [_bigUrl release];
    [_albumID release];
    [_albumTitle release];
    [_albumNum release];
    [_albumSubURL release];
    [super dealloc];
}

@end
