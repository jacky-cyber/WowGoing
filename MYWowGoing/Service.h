//
//  Service.h
//  HuaShang
//
//  Created by cdm on 11-10-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Service : NSObject

@property(nonatomic, assign) id delegate;
@property(nonatomic, assign) SEL onSuccessSeletor;
@property(nonatomic, assign) SEL onFaultSeletor;
@property(nonatomic, assign) BOOL isCancelled;

-(id)syncExecute;
-(void)asyncExecute;
-(void)execute;
-(id)onExecute;
-(void)cancel;

@end

@interface BizService : Service

@end

@interface DBService : Service

@end

@interface RemoteService : Service

@end