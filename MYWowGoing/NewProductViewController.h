//
//  NewProductViewController.h
//  MYWowGoing
//  新品折扣
//  Created by 杨景超 on 13-4-13.
//  Copyright (c) 2013年 西安沃购网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDataButton.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "JSON.h"
#import "SDWebImageManager.h"
#import "MBProgressHUD.h"

#import "SelectSizeViewController.h"
#import "MySettingViewController.h"

@interface NewProductViewController : BaseController<UIScrollViewDelegate,EGORefreshTableHeaderDelegate,SDWebImageManagerDelegate,MBProgressHUDDelegate,gpsLoadDelegete>{
    BOOL _isload;
    UIScrollView *Srollview_NewProduct;
    UIButton *btn_allProduct;
    UIImageView *img_logo;
    int rows;
    int cols;
    BOOL isGPSFailed ;
    BOOL isGPSOk ;

    NSString *cityName;
    NSTimer  *checkGPSTimer;
    MBProgressHUD *HUD;
    int     nowPageNum;
    BOOL _reloading;
}
@property(retain,nonatomic)IBOutlet UIScrollView *Srollview_NewProduct;
@property(retain,nonatomic)IBOutlet UIButton *btn_allProduct;
@property(retain,nonatomic) UIImageView *img_logo;
@property (nonatomic, retain) NSMutableArray *productArray;
@property (nonatomic, retain) NSTimer *gpsTime;
@property (nonatomic, strong) NSMutableArray *dicArray;
@property (assign) int num;
-(IBAction)toAllProduct:(id)sender;
+(NewProductViewController *)shareProduct;
@end
