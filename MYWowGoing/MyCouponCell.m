//
//  MyCouponCell.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-4-19.
//
//

#import "MyCouponCell.h"

@implementation MyCouponCell

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
    [_priceLabel release];
    [_promoCodeLabel release];
    [_endDateLael release];
    [_userTheCityLabel release];
    [_contentLabel release];
    [_couponView release];
    [_couponImageView release];
    [_wxShare release];
    [_detailLabel release];
    [super dealloc];
}
@end
