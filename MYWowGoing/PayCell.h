//
//  NoPayCell.h
//  MYWowGoing
//
//  Created by WangKaifeng on 13-1-10.
//
//

#import <UIKit/UIKit.h>

@interface PayCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *productLogo;
@property (retain, nonatomic) IBOutlet UILabel *productName;
@property (retain, nonatomic) IBOutlet UILabel *sizeLabel;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UIButton *commentBut;  //评论

@property (retain, nonatomic) IBOutlet UILabel *takeLab;
@property (retain, nonatomic) IBOutlet UIButton *slipBtn;  //购物小票
@property (retain, nonatomic) IBOutlet UIButton *shareBtn;  //分享
@end
