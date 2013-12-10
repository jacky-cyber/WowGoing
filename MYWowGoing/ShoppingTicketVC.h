//
//  ShoppingTicketVC.h
//  MYWowGoing
//
//  Created by mayizhao on 13-1-25.
//
//

#import <UIKit/UIKit.h>

@interface ShoppingTicketVC : UIViewController

@property (retain, nonatomic) IBOutlet UIImageView *imageView;

@property (retain, nonatomic) IBOutlet UILabel *commityName;
@property (retain, nonatomic) IBOutlet UILabel *shopName;
@property (retain, nonatomic) IBOutlet UILabel *orderNum;
@property (retain, nonatomic) IBOutlet UILabel *takeTime;
@property(nonatomic,retain)NSMutableDictionary   *tickDic;
@property (retain, nonatomic) IBOutlet UILabel *sellerName;
@property (retain, nonatomic) IBOutlet UILabel *commityNum;//商品编号
@property (retain, nonatomic) IBOutlet UILabel *productName;
@property (retain, nonatomic) IBOutlet UILabel *productCount;//商品数量
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;//单价
@property (retain, nonatomic) IBOutlet UILabel *moneyLabel;//金额
@property (retain, nonatomic) IBOutlet UILabel *alertMessageLab;
@property (retain, nonatomic) IBOutlet UILabel *phoneNumber;
@property (retain, nonatomic) IBOutlet UIImageView *stampImageView;//印章
@end
