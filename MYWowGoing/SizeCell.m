//
//  SizeCell.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-1-10.
//
//

#import "SizeCell.h"

@implementation SizeCell

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
    [_sizeName release];
    [_sizeLabel release];
    [super dealloc];
}
@end
