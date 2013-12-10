//
//  CartListCell.m
//  MYWowGoing
//
//  Created by zhangM on 13-7-22.
//
//

#import "CartListCell.h"

@implementation CartListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
            }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_selectButton release];
    [_productNameLable release];
    [_colorAndSizeLable release];
    [_priceLable release];
    [_addressLabe release];
    [_deleteButton release];
    [_addressButton release];
    [_productImage release];
    [_magnifierImage release];
    [_soldOutImage release];
    [super dealloc];
}
@end
