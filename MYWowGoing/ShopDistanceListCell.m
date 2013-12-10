//
//  ShopDistanceListCell.m
//  MYWowGoing
//
//  Created by ZhangMeng on 13-8-6.
//
//

#import "ShopDistanceListCell.h"

@implementation ShopDistanceListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    
    [_leftShopImageView release];
    [_rightShopImageView release];
    [_leftDistanceLable release];
    [_rightDistanceLable release];
    [_leftDataBut release];
    [_rightDataBut release];
    [_left_BianKuangImage release];
    [_right_BianKuangImage release];
    [super dealloc];
}
@end
