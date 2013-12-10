//
//  GetCommodiyCell.h
//  MYWowGoing
//
//  Created by mayizhao on 13-1-8.
//
//

#import <UIKit/UIKit.h>

@interface GetCommodiyCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *dueLabel;//到期时间
@property (retain, nonatomic) IBOutlet UIImageView *commodityLogo;//商品logo

@property (retain, nonatomic) IBOutlet UIButton *commodityBut;
@property (retain, nonatomic) IBOutlet UILabel *commodityNameLabel;//商品名称
@property (retain, nonatomic) IBOutlet UILabel *wayOfPay;//支付方式
@property (retain, nonatomic) IBOutlet UILabel *concessionalLabel;//优惠折扣
@property (retain, nonatomic) IBOutlet UILabel *moneyLabel;//付款金额
@property (retain, nonatomic) IBOutlet UILabel *shoppingAddressLabel;//商铺地址
@property (retain, nonatomic) IBOutlet UIButton *magnifierBtn;//放大镜按钮
@property (retain, nonatomic) IBOutlet UIImageView *todayImageView;
@property (retain, nonatomic) IBOutlet UIImageView *backImage;

@property (retain, nonatomic) IBOutlet UIButton *shanChuBut;

@property (retain, nonatomic) IBOutlet UIImageView *magnifierImage;


@property (retain, nonatomic) IBOutlet UIImageView *fenjiexian;
@property (retain, nonatomic) IBOutlet UILabel *getCommodiyNum;//  取货码
@property (retain, nonatomic) IBOutlet UIImageView *lineImageview;//分割线
@property (retain, nonatomic) IBOutlet UIButton *returnedBtn;//我要取货按钮
@end
