//
//  ShopITwoCell.m
//  MYWowGoing
//
//  Created by mayizhao on 13-1-9.
//
//

#import "ShopITwoCell.h"

@implementation ShopITwoCell
@synthesize rightNoselectView;
@synthesize midNoDelectView;
@synthesize leftNoSelectView;

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
    [_leftSelectView release];
    [_midLogoImageView release];
    [_midSelectView release];
    [_rightLogoImageView release];
    [_rightSelectView release];
    [_leftBtn release];
    [_rightBtn release];
    [_midBtn release];
    [leftNoSelectView release];
    [midNoDelectView release];
    [rightNoselectView release];
    [super dealloc];
}
@end
