//
//  imageViewShowO.h
//  HuaShangQ_iPhone
//
//  Created by lyy on 12-11-16.
//
//

#import <UIKit/UIKit.h>
#import "ImageScrollViewControllerO.h"


@interface ImageViewShowO : UIView<UIScrollViewDelegate>

@property (retain, nonatomic) UIScrollView *scrollView;
@property (retain, nonatomic) UIImageView *imageView;
@property (retain, nonatomic) UIImage *image;
@property (nonatomic, retain) UIView *downloadView;
@property (nonatomic, retain) UIProgressView *progress;
@property (nonatomic, retain) UILabel *labelDownloadError; // 下载失败时显示

@property (nonatomic, assign) int pageIndex;

- (void)loadImageWithURL:(NSString*)imageURL;
- (void)loadImageWithIMG:(UIImage*)image;
- (void)setImageViewFrame;

@end


@interface WeiboItemImage : NSObject

//微博配图 中
@property (nonatomic, retain) NSString *smallUrl;
//微博配图 大
@property (nonatomic, retain) NSString *bigUrl;
// 配图标题
@property (nonatomic, retain) NSString *albumTitle;
// 配图id
@property (nonatomic, retain) NSString *albumID;
// 配图数量
@property (nonatomic, retain) NSString *albumNum;
// 配图数量
@property (nonatomic, retain) NSString *albumSubURL;

@end