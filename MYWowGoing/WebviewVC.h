//
//  WebviewVC.h
//  MYWowGoing
//
//  Created by zhangM on 13-2-20.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface WebviewVC : UIViewController<UIWebViewDelegate>
{
    MBProgressHUD *HUD;
}
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,copy) NSString *urlString;
@end
