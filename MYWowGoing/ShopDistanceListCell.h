//
//  ShopDistanceListCell.h
//  MYWowGoing
//
//  Created by ZhangMeng on 13-8-6.
//
//

#import <UIKit/UIKit.h>
#import "UIDataButton.h"
@interface ShopDistanceListCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *leftShopImageView;
@property (retain, nonatomic) IBOutlet UIImageView *rightShopImageView;
@property (retain, nonatomic) IBOutlet UIImageView *left_BianKuangImage;
@property (retain, nonatomic) IBOutlet UIImageView *right_BianKuangImage;

@property (retain, nonatomic) IBOutlet UILabel *leftDistanceLable;

@property (retain, nonatomic) IBOutlet UILabel *rightDistanceLable;
@property (retain, nonatomic) IBOutlet UIDataButton *leftDataBut;
@property (retain, nonatomic) IBOutlet UIDataButton *rightDataBut;

@end
