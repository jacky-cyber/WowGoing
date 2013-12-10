//
//  CartListCell.h
//  MYWowGoing
//
//  Created by zhangM on 13-7-22.
//
//
/***********************
    类说明: 此类主要用于购物车列表页的显示
 ************************/
#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface CartListCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIButton *selectButton;  // 选中按钮
@property (retain, nonatomic) IBOutlet UILabel *productNameLable;  //产品名称
@property (retain, nonatomic) IBOutlet UILabel *colorAndSizeLable; //颜色、尺寸、折扣 标签
@property (retain, nonatomic) IBOutlet UILabel *priceLable;  //价格标签
@property (retain, nonatomic) IBOutlet UILabel *addressLabe; //取货地址标签
@property (retain, nonatomic) IBOutlet UIButton *deleteButton; //删除按钮
@property (retain, nonatomic) UIImageView *soldOutImage;


@property (retain,nonatomic)  AsyncImageView *productImage;  //产品图片
@property (retain, nonatomic) IBOutlet UIImageView *magnifierImage; //放大镜图片
@property (retain, nonatomic) IBOutlet UIButton *addressButton;  //取货店铺查看按钮
@end
