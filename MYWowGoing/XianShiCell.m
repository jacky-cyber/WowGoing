//
//  XianShiCell.m
//  MYWowGoing
//
//  Created by zhangM on 13-4-9.
//
//

#import "XianShiCell.h"
#import "AsyncImageView.h"
#import "EGOImageView.h"
@implementation XianShiCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //        self.imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"placeholder.png"]];
        //        self.imageView.backgroundColor = [UIColor redColor];
        //		self.imageView.frame = CGRectMake(50.0f, 4.0f, 100.0f, 100.0f);
        //		[self.contentView addSubview:self.imageView];
    }
    return self;
}

//- (void)setFlickrPhoto:(NSString*)flickrPhoto {
//    NSLog(@"%@",flickrPhoto);
//	self.imageView.imageURL = [NSURL URLWithString:flickrPhoto];
//
//}
//
//- (void)willMoveToSuperview:(UIView *)newSuperview {
//	[super willMoveToSuperview:newSuperview];
//
//	if(!newSuperview) {
//		[self.imageView cancelImageLoad];
//	}
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)dealloc{
    [_productImageLeft release],_productImageLeft=nil;
    [_productImageRight release],_productImageRight=nil;
    [_productPriceLeft release],_productPriceLeft=nil;
    [_discountPriceLeft release],_discountPriceLeft=nil;
    [_discountLeft release],_discountLeft=nil;
    [_demoImageView release],_demoImageView=nil;
    [_btn_Left release];
    [_btn_Right release];
    [super dealloc];
}
@end
