//
//  ImageScrollViewControllerO.m
//  HuaShangQ_iPhone
//
//  Created by lyy on 12-11-16.
//
//

#import "ImageScrollViewControllerO.h"
#import "FileBSDownload.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageViewShowO.h"

#define MULTIIMGBUTTON_SPACE    7        // 多图按钮间隔
#define MULTIIMGBUTTON_INDTAG  1024  // 多图按钮tag区分
#define MULTIIMGBUTTON_SIZE       46      // 按钮大小
#define MULTIIMGVIEW_HIGHT          60      // 按钮view高度 调整contentSize

@interface ImageScrollViewControllerO ()

@property (nonatomic) BOOL  loadedPic;

@end

@implementation ImageScrollViewControllerO

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.arrayMultiImage = [NSMutableArray  array];
        _curIndex = 0;
        _loadedPic = NO;
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_bgScrollView setDelegate:self];
    
    // 设置multiView的边角
    self.multiImageView.layer.cornerRadius = 7.0f;
   
    [self  getAllData];  // 获取假数据

    // 显示多图
    if(_arrayMultiImage.count > 0)
    {
        [self initImageViewPage];
        [self  showMultiImageBar];
    }
    // 显示url图片
    else if(_imageUrl)
    {
        ImageViewShowO *imageViewShow = [[[ImageViewShowO alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height - 44)] autorelease];
        [imageViewShow  loadImageWithURL: _imageUrl];
        [_bgScrollView  addSubview: imageViewShow];
    }
    // 直接显示图片
    else if(_image)
    {
        ImageViewShowO *imageViewShow = [[[ImageViewShowO alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height - 44-49)] autorelease];
        [imageViewShow  loadImageWithIMG: _image];
        [_bgScrollView  addSubview: imageViewShow];
        
//        [self.saveButton setEnabled:YES];
    }
}

// 暂时没有使用
- (void)initImagePageOnPerform
{
    [self performSelectorOnMainThread:@selector(initImageViewPage) withObject:nil waitUntilDone:YES];
}

// 在scrolview上加载所要显示的图片 
-(void)initImageViewPage
{
    CGSize newScrollViewSize = CGSizeMake(self.view.frame.size.width * (_arrayMultiImage.count), [[UIScreen mainScreen] bounds].size.height - 44-49-20);
    _bgScrollView.contentSize = newScrollViewSize;
    
    for(int i = 0; i < _arrayMultiImage.count; i++)
    {
        ImageViewShowO *imageViewShow = [[[ImageViewShowO alloc] initWithFrame:CGRectMake(i * 320, 0, 320, [[UIScreen mainScreen] bounds].size.height - 44-49-20)] autorelease];
        WeiboItemImage *item = [_arrayMultiImage objectAtIndex:i];
      
        [imageViewShow  loadImageWithURL:item.bigUrl];
        [_bgScrollView  addSubview:imageViewShow];
    }
}
    
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [_bgScrollView release];
    [_image release];
    [_imageUrl release];
    [_saveButton release];
    [_shareButton release];
    [_multiScrollView release];
    [_multiView release];
    [_arrayMultiImage release];
    [_multiImageView release];
    [super dealloc];
}

// 处理多图显示的情况
- (void)showMultiImageBar
{
    // 显示第一张图片 启动下载队列 顺序下载图片  用户点击了则更改下载队列
    // 只有一张则按照单图处理
    if(_arrayMultiImage.count == 1)
        return;
    
    // 显示多图的区域 小图片和按钮
    for(int i = 0; i < _arrayMultiImage.count ; i++)
    {
        WeiboItemImage *itemImage = [_arrayMultiImage objectAtIndex:i];
        
        // 设置imageview  frame和下面的button一模一样
        // button和imageview都用到 是为了使用UIImageView+WebCache类的方法
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(MULTIIMGBUTTON_SPACE + i * MULTIIMGBUTTON_SIZE + MULTIIMGBUTTON_SPACE * i, MULTIIMGBUTTON_SPACE, MULTIIMGBUTTON_SIZE, MULTIIMGBUTTON_SIZE)] autorelease];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView  setImageWithURL:[NSURL URLWithString:itemImage.smallUrl]  placeholderImage:[UIImage imageNamed:@""]];
       
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = MULTIIMGBUTTON_INDTAG + i;
        button.layer.borderWidth = 2.0f;
        // 默认选中第一个 置红  其他置灰
        if(i == 0)
            button.layer.borderColor = [[UIColor redColor] CGColor];
        else
            button.layer.borderColor = [[UIColor grayColor] CGColor];
        [button  setBackgroundColor:[UIColor clearColor]];
        [button setFrame:CGRectMake(MULTIIMGBUTTON_SPACE + i*MULTIIMGBUTTON_SIZE + MULTIIMGBUTTON_SPACE*i, MULTIIMGBUTTON_SPACE, MULTIIMGBUTTON_SIZE, MULTIIMGBUTTON_SIZE)];
        [button addTarget:self action:@selector(multiButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        [_multiScrollView  addSubview:imageView];
        [_multiScrollView  addSubview:button];
    }
    
    // 显示合适的多图工具栏
    [_multiView  setHidden:NO];
    [self  adjustMultiImageToolBar];
    [_multiScrollView  setContentSize:CGSizeMake(_arrayMultiImage.count * (MULTIIMGBUTTON_SIZE + MULTIIMGBUTTON_SPACE) + MULTIIMGBUTTON_SPACE, MULTIIMGVIEW_HIGHT)];
}

// 调整多图工具栏的宽度
// 要显示的宽度小于320时 显示实际宽度
// 当大于等于320时 显示默认宽度320
- (void)adjustMultiImageToolBar
{
    NSInteger totleWidth = _arrayMultiImage.count * (MULTIIMGBUTTON_SIZE + MULTIIMGBUTTON_SPACE) + MULTIIMGBUTTON_SPACE;
    if(totleWidth < 320)
    {
        _multiView.center = self.view.center;
        _multiView.frame = CGRectMake(self.multiView.center.x - totleWidth / 2, 460 - MULTIIMGVIEW_HIGHT, totleWidth, MULTIIMGVIEW_HIGHT);
    }
}

// 点击多图工具栏的某一张缩略图时
- (IBAction)multiButtonTouched:(id)sender
{
    // 初始化所有缩略图的选中状态
    [self  cancleRedBorderLayer];
    
    // 初始没有下载图片  如果本地下载好了 则置为yes
    _loadedPic = NO;
    
    // 当前按钮置为选中状态
    UIButton *button = (UIButton*)sender;
    button.layer.borderWidth = 2.0f;
    button.layer.borderColor = [[UIColor redColor] CGColor];
    
    // 第几张图片
    NSInteger  buttonID = button.tag - MULTIIMGBUTTON_INDTAG;
    _curIndex = buttonID;
    
    // 点击了按钮 显示scrollView当前页面
    // 点击后改变当前显示的图片
    [_bgScrollView setContentOffset:CGPointMake( buttonID * 320, 0)];
    //设置当前图片
    [self  searchImageOnImageCache:buttonID];
}

// 将多图工具栏的边框置灰
- (void)cancleRedBorderLayer
{
    for(UIButton *btn in [self.multiScrollView  subviews])
    {
        btn.layer.borderColor = [[UIColor grayColor] CGColor];
    }
}

#pragma scrollView 协议
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 初始没有下载图片  如果本地下载好了 则置为yes
    _loadedPic = NO;
    
    CGPoint point = scrollView.contentOffset;
    NSInteger  index = (NSInteger)(point.x / 320);
    // 1. 设置当前图片 和图片状态
    [self  searchImageOnImageCache:index];
    
    // 滑动时 改变下面的多图工具栏
    // 2. 设置红色  其他置灰
    for(UIButton *btn in [self.multiScrollView  subviews])
    {
        if(btn.tag == index + MULTIIMGBUTTON_INDTAG)
        {
            btn.layer.borderColor = [[UIColor redColor] CGColor];
        }
        else
        {
            btn.layer.borderColor = [[UIColor grayColor] CGColor];
        }
    }
    // 3. 设置contentOffent
    // 0 1 2 3 4 5     6 7 8 9 10 11    12 13 14
    if (index > 2 && index < [self.arrayMultiImage count] - 1)
    {
        [self.multiScrollView setContentOffset:CGPointMake( (index - 2) * (MULTIIMGBUTTON_SIZE + MULTIIMGBUTTON_SPACE), 0 ) animated:YES];
    }
    else if(index < 2 || index == 2)
    {
        [self.multiScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else
    {
        if (index == [self.arrayMultiImage count])
        {
            [self.multiScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        else
        {
            [self.multiScrollView setContentOffset:CGPointMake( ([self.arrayMultiImage count] - 4) * (MULTIIMGBUTTON_SIZE + MULTIIMGBUTTON_SPACE) ,0 ) animated:YES];
        }
    }
    _curIndex = index;
}

// 根据索引 在本地查找对应索引的数组里的这张图片是否存在
// 然后将其设置为当前图片
- (void)searchImageOnImageCache: (NSInteger)index
{
    NSString *url = nil;
    
    if(_arrayMultiImage.count > 0)
    {
        WeiboItemImage *item = [_arrayMultiImage  objectAtIndex: index];
        url = item.bigUrl;
    }
    else
    {
        url = _imageUrl;
    }
    NSString *dest = nil;
    // 设置缓存路径
    if(url.length > 0)
        dest = [[SDImageCache sharedImageCache] cachePathForKey:url];
    // 如果本地存在此图片 则不下载 直接返回路径
    UIImage *imageLoc = [UIImage imageWithContentsOfFile:dest];
    
    if(dest && imageLoc)
    {
        self.image = imageLoc;
        if(self.image)
        {
            _loadedPic = YES; // 图片已下载成功
//            _saveButton.enabled = YES;
        }
    }
    else if(self.image)
    {
        _loadedPic = YES;
       
    }
}

// 返回上一级界面
- (IBAction)backButtonAction:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
}

//将报纸图片保存在本地相册
- (IBAction)actionSave:(id)sender
{
}



// 分享图片
-(IBAction)shareBtnClick:(id)sender
{
}

- (void)getAllData
{
    // kf  注意 url不能相同  一张图片对应一张图片！！ 一般是没问题的
    // 制造假数据
//    WeiboItemImage *itemImage0 = [[[WeiboItemImage alloc] init] autorelease];
//    itemImage0.bigUrl =    @"http://ww1.sinaimg.cn/large/75b1a75fjw1dyt6623zb4j.jpg";
//    itemImage0.smallUrl = @"http://ww1.sinaimg.cn/bmiddle/75b1a75fjw1dyt6623zb4j.jpg";
//    [self.arrayMultiImage addObject:itemImage0];
//    
//    WeiboItemImage *itemImage1 = [[[WeiboItemImage alloc] init] autorelease];
//    itemImage1.bigUrl = @"http://ww3.sinaimg.cn/large/6541632cjw1dyt6ruq59hj.jpg";
//    itemImage1.smallUrl = @"http://ww3.sinaimg.cn/bmiddle/6541632cjw1dyt6ruq59hj.jpg";
//    [self.arrayMultiImage addObject:itemImage1];
//    
//    WeiboItemImage *itemImage2 = [[[WeiboItemImage alloc] init] autorelease];
//    itemImage2.bigUrl = @"http://ww4.sinaimg.cn/large/626ece26jw1dyt6mf71wyj.jpg";
//    itemImage2.smallUrl = @"http://ww4.sinaimg.cn/bmiddle/626ece26jw1dyt6mf71wyj.jpg";
//    [self.arrayMultiImage addObject:itemImage2];
//    
//    WeiboItemImage *itemImage3 = [[[WeiboItemImage alloc] init] autorelease];
//    itemImage3.bigUrl = @"http://ww1.sinaimg.cn/large/95e5231djw1dyt6klx8maj.jpg";
//    itemImage3.smallUrl = @"http://ww1.sinaimg.cn/bmiddle/95e5231djw1dyt6klx8maj.jpg";
//    [self.arrayMultiImage addObject:itemImage3];
//    
//    WeiboItemImage *itemImage4 = [[[WeiboItemImage alloc] init] autorelease];
//    itemImage4.bigUrl = @"http://ww4.sinaimg.cn/large/66640ec4jw1dytiifvu1gj.jpg";
//    itemImage4.smallUrl = @"http://ww4.sinaimg.cn/bmiddle/66640ec4jw1dytiifvu1gj.jpg";
//    [self.arrayMultiImage addObject:itemImage4];
//    
//    WeiboItemImage *itemImage5 = [[[WeiboItemImage alloc] init] autorelease];
//    itemImage5.bigUrl = @"http://ww4.sinaimg.cn/large/66640ec4jw1dytiblu3jrj.jpg";
//    itemImage5.smallUrl = @"http://ww4.sinaimg.cn/bmiddle/66640ec4jw1dytiblu3jrj.jpg";
//    [self.arrayMultiImage addObject:itemImage5];
//    
//    WeiboItemImage *itemImage6 = [[[WeiboItemImage alloc] init] autorelease];
//    itemImage6.bigUrl = @"http://ww2.sinaimg.cn/large/61d83ed4jw1dythink50hj.jpg";
//    itemImage6.smallUrl = @"http://ww2.sinaimg.cn/bmiddle/61d83ed4jw1dythink50hj.jpg";
//    [self.arrayMultiImage addObject:itemImage6];
    WeiboItemImage *itemImage0;
    
    for (int i = 0; i<_arrayMultiImage.count; i++) {
        itemImage0 = [[[WeiboItemImage alloc] init] autorelease];
        itemImage0.bigUrl =  [NSString stringWithFormat:@"%@",[_arrayMultiImage objectAtIndex:i]];
        itemImage0.smallUrl = [NSString stringWithFormat:@"%@",[_arrayMultiImage objectAtIndex:i]];
        [_arrayMultiImage replaceObjectAtIndex:i withObject:itemImage0];
    }
}

@end
