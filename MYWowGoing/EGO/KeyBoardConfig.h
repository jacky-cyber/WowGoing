//
//  KeyBoardConfig.h
//  MYWowGoing
//
//  Created by mayizhao on 13-1-7.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    SourceViewTypeDefault,//默认情况下出现toolbar
    SourceViewTypeView//出现的是传入的view
}SourceViewType;

@class KeyBoardConfig;
@protocol KeyBoardConfigDelegate <NSObject>
//隐藏键盘的delegate
-(void)hiddenKeyBoardAction:(KeyBoardConfig *)sender;

@end
@interface KeyBoardConfig : NSObject{
    
}
@property(nonatomic,assign)id<KeyBoardConfigDelegate> delegate;
@property(nonatomic,assign)SourceViewType sourceViewType;
@property(nonatomic,retain)UIView *sourceView;
//初始化键盘
+ (KeyBoardConfig *)sharedInstance;
//注册键盘监听
- (void) registerForKeyboardNotifications:(id)sender;//默认
- (void) registerForKeyboardNotifications:(id)sender WithView:(UIView *)view SourceViewType:(SourceViewType)type;//自定义
@end
