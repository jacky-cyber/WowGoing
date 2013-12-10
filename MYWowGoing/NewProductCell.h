//
//  NewProductCell.h
//  MYWowGoing
//
//  Created by YangJingchao on 13-4-18.
//
//

#import <UIKit/UIKit.h>
#import "UIDataButton.h"
#import "AsyncImageView.h"
#import "StrikeThroughLabel.h"
#import "EGOImageView.h"
@class EGOImageView;
@interface NewProductCell : UITableViewCell


@property(nonatomic,retain)IBOutlet EGOImageView *productImageLeft;//产品图片
@property(nonatomic,retain)IBOutlet UIImageView *brandLogoLeft;//产品Logo
@property(nonatomic,retain)IBOutlet UILabel *productPriceLeft;//原价
@property(nonatomic,retain)IBOutlet StrikeThroughLabel *discountPriceLeft;//折扣价
@property(nonatomic,retain)IBOutlet UILabel *discountLeft; //折扣
@property (retain, nonatomic) IBOutlet UIDataButton *btn_Left;

@property(nonatomic,retain)IBOutlet EGOImageView *productImageRight;//产品图片
@property(nonatomic,retain)IBOutlet UIImageView *brandLogoRight;//产品Logo
@property(nonatomic,retain)IBOutlet UILabel *productPriceRight;//原价
@property(nonatomic,retain)IBOutlet StrikeThroughLabel *discountPriceRight;//折扣价
@property(nonatomic,retain)IBOutlet UILabel *discountRight; //折扣
@property (retain, nonatomic) IBOutlet UIDataButton *btn_Right;

@property(nonatomic,retain)IBOutlet UILabel *label_productName;
@property(nonatomic,retain)UIDataButton *shoucang;
@property(nonatomic,retain)UIImageView *img_money1;
@property(nonatomic,retain)UIImageView *img_money2;
@property(nonatomic,retain)IBOutlet UIImageView *img1;
@property(nonatomic,retain)IBOutlet UIImageView *img_money;
@property(nonatomic,retain)IBOutlet UIImageView *img_touming;
@end
