//
//  EGORefreshTableHeaderDelegate.h
//  TableViewPull
//
//  Created by Liu Lucas on 11-12-18.
//  Copyright (c) 2011年 Shift Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
	EGOOPullRefreshPulling = 0,
	EGOOPullRefreshNormal,
	EGOOPullRefreshLoading,	
} EGOPullRefreshState;

@protocol EGORefreshTableHeaderDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(UIView*)view;
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(UIView*)view;
@optional
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(UIView*)view;

@end
