//
//  ImageScrollViewControllerO.h
//  HuaShangQ_iPhone
//
//  Created by lyy on 12-11-16.
//
//

#import "imageViewShowO.h"

@interface ImageScrollViewControllerO : UIViewController<UIActionSheetDelegate,UIScrollViewDelegate,UIAlertViewDelegate>

@property (nonatomic, retain) IBOutlet UIScrollView *bgScrollView;
@property (retain, nonatomic) UIImage *image;
@property (retain, nonatomic) NSString *imageUrl;
@property (nonatomic) NSInteger  curIndex;

@property (nonatomic, retain) IBOutlet UIButton        *saveButton;
@property (nonatomic, retain) IBOutlet UIButton        *shareButton;

@property (nonatomic, retain) IBOutlet UIScrollView *multiScrollView;
@property (nonatomic, retain) IBOutlet UIView          *multiView;
@property (nonatomic, retain) IBOutlet UIImageView *multiImageView;

// 多图的数据包、下载队列、 scrollview 和 view
@property (nonatomic, retain) NSMutableArray  *arrayMultiImage;

// 保存按钮函数
- (IBAction)actionSave:(id)sender;
// 分享按钮函数
- (IBAction)shareBtnClick:(id)sender;
- (IBAction)backButtonAction:(id)sender;

@end
