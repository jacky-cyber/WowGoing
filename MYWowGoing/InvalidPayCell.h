//
//  InvalidPayCell.h
//  MYWowGoing
//
//  Created by WangKaifeng on 13-1-21.
//
//

#import <UIKit/UIKit.h>

@interface InvalidPayCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *productLogo;
@property (retain, nonatomic) IBOutlet UILabel *orderNumLab;
@property (retain, nonatomic) IBOutlet UILabel *productNameLab;
@property (retain, nonatomic) IBOutlet UILabel *roleLab;
@property (retain, nonatomic) IBOutlet UILabel *countPrice;
@property (retain, nonatomic) IBOutlet UILabel *payTypeLab;
@property (retain, nonatomic) IBOutlet UILabel *buyDate;
@property (retain, nonatomic) IBOutlet UILabel *refundTypeLab;
@property (retain, nonatomic) IBOutlet UIButton *refundTypeBtn;
@end
