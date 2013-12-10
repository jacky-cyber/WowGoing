//
//  ProductDetailViewController_Detail2.h
//  MYWowGoing
//
//  Created by zhangM on 13-7-11.
//
//

#import <UIKit/UIKit.h>
 
#import "JSON.h"
#import "SDWebImageManager.h"
#import "StrikeThroughLabel.h"

#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "SDWebImageDownloader.h"
#import "MBProgressHUD.h"
#import "UIDataButton.h"
#import "BaseController.h"
#import "EScrollerView.h"
#define DIANPU_FOUNT 12   //店铺的字体
#define DIANPU_FOUNT_QUHUO 15  //取货店铺文字字体
//typedef enum _XLBadgeManagedType {
//    XLInboxManagedMethod = 0,
//    XLDeveloperManagedMethod = 1
//} XLBadgeManagedType;
@interface ProductDetailViewController_Detail2 : BaseController<UIScrollViewDelegate,UIAlertViewDelegate, EScrollerViewDelegate>

@property (nonatomic,assign) BOOL   isShow;
@property (assign) int activityId;
@property (assign) int productId;
@property (retain, nonatomic) NSMutableDictionary *prductDetailDic;
@property (assign, nonatomic) BOOL isShowTimeLabel;
@property (retain, nonatomic) IBOutlet UIButton *sizeLabel;
@property (retain, nonatomic) IBOutlet UIView *view_imgScro;
@property (retain, nonatomic) IBOutlet UIView *displayShopView;
@property (retain, nonatomic) IBOutlet UIScrollView *shopScrollView;
//商品说明的view
@property (retain, nonatomic) IBOutlet UIView *explainView;
@property (retain, nonatomic) IBOutlet UIButton *shareBtn;
@property (retain, nonatomic) IBOutlet StrikeThroughLabel *discountPriceLable;  //折扣价
@property (retain, nonatomic) IBOutlet UILabel *hyPricelabel;
@property (retain, nonatomic) IBOutlet StrikeThroughLabel *originalPriceLable;  //原价
@property (retain, nonatomic) IBOutlet UIButton *shopButton; //购物车按钮
@property (retain, nonatomic) IBOutlet UIButton *ydButton; //立刻预定按钮
@property (retain, nonatomic) IBOutlet UILabel *gyPriceLabel;
@property (retain, nonatomic) IBOutlet StrikeThroughLabel *zgPriceLabel;
@property (retain, nonatomic) IBOutlet UILabel *gouYInLabel;
//售罄标签
@property (retain, nonatomic) IBOutlet UIImageView *stockImageView;

+(void)setPushState:(int)state;
- (IBAction)selectSizeSeeAction:(id)sender;


@end
