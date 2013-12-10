//
//  Service.m
//  HuaShang
//
//  Created by cdm on 11-10-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Service.h"

Class object_getClass(id object);

@interface Service ()

@property(nonatomic, assign) BOOL isCanceled;
@property(nonatomic, assign) Class originalClass;
@property(nonatomic, retain) NSOperationQueue *queue;

@end

@implementation Service

- (id)init
{
    self = [super init];
    if (self) 
    {
        _queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:1];
        _originalClass = nil;
        _isCancelled = NO;
    }
    
    return self;
}

- (void)dealloc 
{
    _delegate = nil;
    [_queue cancelAllOperations];
    [_queue release];
    [super dealloc];
}

- (id)syncExecute
{
    id result = [self onExecute];
    return result;
}

- (void)asyncExecute
{
    _originalClass = object_getClass(self.delegate);
    NSInvocationOperation *operation = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(execute) object:nil] autorelease];
    [_queue addOperation:operation];
}

- (void)execute
{
    @try
    {
        id result = [self onExecute];
        if (_originalClass && (_originalClass == object_getClass(self.delegate)) && [self.delegate respondsToSelector:_onSuccessSeletor] && !_isCancelled)
        {
            [self.delegate performSelectorOnMainThread:_onSuccessSeletor withObject:result waitUntilDone:NO];
        }
        else
        {
        }
    }
    @catch (NSException *exception) 
    {
        if (_originalClass && (_originalClass == object_getClass(self.delegate)) && [self.delegate respondsToSelector:_onFaultSeletor] && !_isCancelled)
         {
              [self.delegate performSelectorOnMainThread:_onFaultSeletor withObject:exception waitUntilDone:NO];
         }
         else
         {
             [self executeOnFault:exception];
         }
    }
}

-(void)executeOnFault:(NSException *)exception
{
    NSLog(@"exception: %@",exception);
}

- (id)onExecute
{
    return nil;
}

- (void)cancel
{
    _isCancelled = YES;
}

@end

@implementation BizService

@end

@implementation DBService

@end

@implementation RemoteService

@end
