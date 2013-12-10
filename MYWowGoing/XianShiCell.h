//
//  XianShiCell.h
//  MYWowGoing
//
//  Created by zhangM on 13-4-9.
//
//

#import <UIKit/UIKit.h>

#import "AsyncImageView.h"
#import "StrikeThroughLabel.h"
#import "UIDataButton.h"
#import "UIImageView+WebCache.h"
#import "EGOImageView.h"
@class EGOImageView;
@interface XianShiCell : UITableViewCell
@property(nonatomic,retain) IBOutlet EGOImageView *productImageLeft;//产品图片
@property(nonatomic,retain) IBOutlet UIImageView *brandLogoLeft;//产品Logo
@property(nonatomic,retain) IBOutlet UILabel *productPriceLeft;//原价
@property(nonatomic,retain) IBOutlet  StrikeThroughLabel *discountPriceLeft;//折扣价
@property(nonatomic,retain) IBOutlet UILabel *discountLeft; //折扣
@property (retain, nonatomic) IBOutlet UIDataButton *btn_Left;
@property (retain, nonatomic) IBOutlet UIImageView *demoImageView;
@property (retain, nonatomic) IBOutlet UIImageView *demoImageViewLeft;
@property(retain,nonatomic)IBOutlet UIImageView *img_zhekouIconLeft;



@property(nonatomic,retain) IBOutlet EGOImageView *productImageRight;//产品图片
@property(nonatomic,retain) IBOutlet UIImageView *brandLogoRight;//产品Logo
@property(nonatomic,retain) IBOutlet UILabel *productPriceRight;//原价
@property(nonatomic,retain) IBOutlet StrikeThroughLabel *discountPriceRight;//折扣价
@property(nonatomic,retain) IBOutlet UILabel *discountRight; //折扣

@property (retain, nonatomic) IBOutlet UIDataButton *btn_Right;

@property(retain,nonatomic) UIDataButton *btnTime;
@property(retain,nonatomic) UIDataButton *shoucang;
@property(retain,nonatomic)IBOutlet UILabel *label_products;
@property(retain,nonatomic)IBOutlet UIImageView *img_zhekouIcon;

@end
