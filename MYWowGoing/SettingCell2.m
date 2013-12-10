//
//  SettingCell2.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-1-10.
//
//

#import "SettingCell2.h"

@interface SettingCell2 ()

@end

@implementation SettingCell2

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
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
    [_weiboLogo release];
    [_weiboName release];
    [_weiboBinding release];
    [_backgroundImageView release];
    [super dealloc];
}

@end
