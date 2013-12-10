//
//  AdView.h
//  stockmarket_infomation
//
//  Created by 神奇的小黄子 QQ:438172 on 12-12-10.
//  Copyright (c) 2012年 kernelnr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADDelegate <NSObject>

- (void)pushADViewAction;

@end

@interface MyUIScrollView : UIScrollView
@end

@interface AdView : UIView<UIScrollViewDelegate, UIPageViewControllerDelegate>
{
    MyUIScrollView  *sv_Ad; // 广告
    UIPageControl   *pc_AdPage; // 广告页码
    UILabel *lbl_Info;  // 广告标题
    
    NSArray *arr_AdTitles;   // 广告标题
}
@property (assign) NSObject <ADDelegate> *adDelegate;
@property(nonatomic,retain) NSArray *arr_AdImgs;    // 广告图片
@property (strong, nonatomic) NSTimer *adTimer; //广告切换的时间
- (void)adLoad;
+ (AdView *)sharedManager;

@end
