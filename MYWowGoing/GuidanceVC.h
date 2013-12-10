//
//  GuidanceVC.h
//  MYWowGoing
//
//  Created by zhangM on 13-3-16.
//
//

#import <UIKit/UIKit.h>

@interface GuidanceVC : UIViewController<UIScrollViewDelegate>
@property(nonatomic,retain) UIScrollView *scroll;

@property (assign)BOOL pageControlUsed;
@end
