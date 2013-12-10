//
//  SizeWebVC.h
//  MYWowGoing
//
//  Created by WangKaifeng on 13-8-13.
//
//

#import <UIKit/UIKit.h>

@interface SizeWebVC : UIViewController <UIWebViewDelegate>
@property (retain, nonatomic) IBOutlet UIWebView *sizeWebView;


@property (strong, nonatomic) NSString *brandidString; //品牌id
@property (strong, nonatomic) NSString *genderString; //性别
@property (strong, nonatomic) NSString *styleTypeIdString; //版型
@end
