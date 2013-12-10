//
//  ShopIThreeCell.m
//  MYWowGoing
//
//  Created by mayizhao on 13-1-9.
//
//

#import "ShopIThreeCell.h"

@implementation ShopIThreeCell
@synthesize leftNoselectView;
@synthesize rightNoselectView;

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
    [_leftLogoImageView release];
    [_rightLogoImageView release];
    [_leftBtn release];
    [_rightBtn release];
    [_leftSelectImageView release];
    [_rightSelectImageView release];
    [leftNoselectView release];
    [rightNoselectView release];
    [super dealloc];
}
@end
