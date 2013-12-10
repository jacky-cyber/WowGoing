//
//  ShoppeTakeCell.m
//  MYWowGoing
//
//  Created by mayizhao on 13-1-8.
//
//

#import "ShoppeTakeCell.h"

@implementation ShoppeTakeCell

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
    [_dueLabel release];
    [_commodityLogo release];
    [_commodityNameLabel release];
    [_concessionalLabel release];
    [_moneyLabel release];
    [_shoppingAddressLabel release];
    [_checkBtn release];
    [super dealloc];
}
@end
