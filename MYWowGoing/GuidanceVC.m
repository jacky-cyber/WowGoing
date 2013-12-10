//
//  GuidanceVC.m
//  MYWowGoing
//
//  Created by zhangM on 13-3-16.
//
//

#import "GuidanceVC.h"

#import "ImageUtil.h"
@interface GuidanceVC ()

@end

@implementation GuidanceVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //在视图上加载滚动视图对象
    self.scroll = [[[UIScrollView alloc] initWithFrame:CGRectMake(0,20, 320,IPHONE_HEIGHT-20)] autorelease];
    self.scroll.backgroundColor = [UIColor whiteColor];
    self.scroll.indicatorStyle = UIScrollViewIndicatorStyleBlack;//设置滚动条的样式
    self.scroll.showsVerticalScrollIndicator = NO;//显示垂直滚动条
    self.scroll.showsHorizontalScrollIndicator = NO;//显示水平滚动条
    self.scroll.bounces =NO;//水平滚动超过边界是否有反弹回来的效果,设置为NO是不会反弹
    self.scroll.alwaysBounceVertical=NO;//垂直滚动超过边界是否有反弹回来的效果,设置为NO是不会反弹
    self.scroll.pagingEnabled = YES;//是否滚动到subView的边界  这个属性值也是设置为划一屏，即划_scrollView的宽度大小
    self.scroll.delegate = self;
    self.scroll.contentSize = CGSizeMake(320*3, IPHONE_HEIGHT-20);//contentSize是设置内容视图的大小
    for(int i = 0;i <2;i++)
    {
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(i*320, 0, 320, IPHONE_HEIGHT-20)] autorelease];
        if (iPhone5) {
            imageView.image =[ImageUtil imageNamedWithiPhone5:[NSString stringWithFormat:@"%d",i+1] imageTyped:@"jpg"];
        } else {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i+1]];
        }
        
        [self.scroll addSubview:imageView];
    
    }
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(2*320, 0, 320, IPHONE_HEIGHT-20)] autorelease];
    if (iPhone5) {
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d-568.jpg",3]];
    } else {
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",3]];
    }
    
    UIButton  *button=[UIButton buttonWithType:UIButtonTypeCustom];
    if (!iPhone5) {
        button.frame=CGRectMake(90, 480-65,150, 30);
    } else {
        button.frame=CGRectMake(90, 568-85,150, 30);
    }
    
    imageView.userInteractionEnabled=YES;
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:button];
    [self.scroll addSubview:imageView];
    [self.view addSubview:self.scroll];
}
-(void)back{
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    
    [self.view removeFromSuperview];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{

    [_scroll release];
    [super dealloc];
}

@end
