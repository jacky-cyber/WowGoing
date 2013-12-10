//
//  ShoppeTakeCell.h
//  MYWowGoing
//
//  Created by mayizhao on 13-1-8.
//
//

#import <UIKit/UIKit.h>

@interface ShoppeTakeCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *dueLabel;//到期时间
@property (retain, nonatomic) IBOutlet UIImageView *commodityLogo;//商品logo
@property (retain, nonatomic) IBOutlet UILabel *commodityNameLabel;//商品名称
@property (retain, nonatomic) IBOutlet UILabel *concessionalLabel;//优惠折扣
@property (retain, nonatomic) IBOutlet UILabel *moneyLabel;//付款金额
@property (retain, nonatomic) IBOutlet UILabel *shoppingAddressLabel;//商店地址
@property (retain, nonatomic) IBOutlet UIButton *checkBtn;

@end
