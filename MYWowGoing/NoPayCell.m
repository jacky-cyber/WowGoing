//
//  NoPayCell.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-1-10.
//
//

#import "NoPayCell.h"

@implementation NoPayCell

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
    [_payBtn release];
    [_waitTime release];
    [_orderID release];
    [_productImage release];
    [_sizeLab release];
    [_priceLab release];
    [_totalPrice release];
    [_provincePrice release];
    [_takeTime release];
    [_prductName release];
    [_detailBtn release];
    [super dealloc];
}
@end
