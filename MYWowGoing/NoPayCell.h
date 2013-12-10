//
//  NoPayCell.h
//  MYWowGoing
//
//  Created by WangKaifeng on 13-1-10.
//
//

#import <UIKit/UIKit.h>

@interface NoPayCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIButton *payBtn;
@property (retain, nonatomic) IBOutlet UILabel *waitTime;
@property (retain, nonatomic) IBOutlet UILabel *orderID;
@property (retain, nonatomic) IBOutlet UIImageView *productImage;
@property (retain, nonatomic) IBOutlet UILabel *sizeLab;
@property (retain, nonatomic) IBOutlet UILabel *priceLab;
@property (retain, nonatomic) IBOutlet UILabel *totalPrice;
@property (retain, nonatomic) IBOutlet UILabel *provincePrice;
@property (retain, nonatomic) IBOutlet UILabel *takeTime;
@property (retain, nonatomic) IBOutlet UILabel *prductName;
@property (retain, nonatomic) IBOutlet UIButton *detailBtn;
@end
