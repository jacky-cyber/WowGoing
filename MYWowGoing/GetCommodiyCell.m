//
//  GetCommodiyCell.m
//  MYWowGoing
//
//  Created by mayizhao on 13-1-8.
//
//

#import "GetCommodiyCell.h"

@implementation GetCommodiyCell
@synthesize todayImageView;

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
    [_dueLabel release];
    [_commodityLogo release];
    [_commodityNameLabel release];
    [_concessionalLabel release];
    [_shoppingAddressLabel release];
    [_magnifierBtn release];
    [_lineImageview release];
    [_getCommodiyNum release];
    [_returnedBtn release];
    [_moneyLabel release];
    [todayImageView release];
    [_backImage release];
    [_fenjiexian release];
    [_wayOfPay release];
    [_commodityBut release];
    [_shanChuBut release];
    [_magnifierImage release];
    [super dealloc];
}
@end
