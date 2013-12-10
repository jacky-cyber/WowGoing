//
//  MyCouponCell.h
//  MYWowGoing
//
//  Created by WangKaifeng on 13-4-19.
//
//

#import <UIKit/UIKit.h>

@interface MyCouponCell : UITableViewCell
//价格
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UIView *couponView;
//优惠码
@property (retain, nonatomic) IBOutlet UILabel *promoCodeLabel;
//截止日期
@property (retain, nonatomic) IBOutlet UILabel *endDateLael;
@property (retain, nonatomic) IBOutlet UIImageView *couponImageView;
@property (retain, nonatomic) IBOutlet UILabel *detailLabel;


//使用城市
@property (retain, nonatomic) IBOutlet UILabel *userTheCityLabel;
//相关内容
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;
@property (retain, nonatomic) IBOutlet UIButton *wxShare;
@end
