//
//  ShopAddressListCell.m
//  MYWowGoing
//
//  Created by mayizhao on 13-1-10.
//
//

#import "ShopAddressListCell.h"

@implementation ShopAddressListCell
@synthesize backImageView;


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
    [_shopAddressLabel release];
    [_selectImageView release];
   
    [backImageView release];
    [super dealloc];
}
@end
