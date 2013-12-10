//
//  ShopIThreeCell.h
//  MYWowGoing
//
//  Created by mayizhao on 13-1-9.
//
//

#import <UIKit/UIKit.h>

@interface ShopIThreeCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *rightSelectImageView;
@property (retain, nonatomic) IBOutlet UIImageView *leftSelectImageView;
@property (retain, nonatomic) IBOutlet UIImageView *leftLogoImageView;
@property (retain, nonatomic) IBOutlet UIImageView *rightLogoImageView;
@property (retain, nonatomic) IBOutlet UIButton *leftBtn;
@property (retain, nonatomic) IBOutlet UIButton *rightBtn;
@property (retain, nonatomic) IBOutlet UIImageView *leftNoselectView;
@property (retain, nonatomic) IBOutlet UIImageView *rightNoselectView;

@end
