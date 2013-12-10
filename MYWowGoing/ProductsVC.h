//
//  ProductsVC.h
//  MYWowGoing
//
//  Created by zhangM on 13-4-9.
//
//

#import <UIKit/UIKit.h>

@interface ProductsVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *productTable;

@end
