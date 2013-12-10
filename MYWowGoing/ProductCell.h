//
//  ProductCell.h
//  MYWowGoing
//
//  Created by YangJingchao on 13-4-18.
//
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "UIDataButton.h"

@interface ProductCell : UITableViewCell{
    
}

@property(retain,nonatomic)IBOutlet UIImageView *img_CloseLeft;
@property(retain,nonatomic)IBOutlet UIImageView *img_CloseRight;
@property(retain,nonatomic)IBOutlet UIDataButton *uidbtn_Left;
@property(retain,nonatomic)IBOutlet UIDataButton *uidbtn_Right;
@property(retain,nonatomic)IBOutlet UIImageView *img1;
@property(retain,nonatomic)IBOutlet UIImageView *img2;

@end
