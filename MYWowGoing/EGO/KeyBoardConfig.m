//
//  KeyBoardConfig.m
//  MYWowGoing
//
//  Created by mayizhao on 13-1-7.
//
//

#import "KeyBoardConfig.h"
#define VIEW_HEIGHT 460.00
#define VIEW_WIDTH 320.00
#define TOOLBAR_HEIGHT 44.00
#define ANIMATION_DURATION_TIME 0.25
static KeyBoardConfig * instance = NULL;

@interface KeyBoardConfig()

-(void)initToolBar;
-(void)addKeyBoardNotification;
-(void)registerForKeyboardNotificationsWithController:(UIViewController *)controller;
@property(nonatomic,retain)UIToolbar *toolBar;
@property(nonatomic,retain)UIViewController *viewController;

@end
@implementation KeyBoardConfig
@synthesize viewController;
@synthesize toolBar;
@synthesize delegate;
@synthesize sourceViewType;
@synthesize sourceView;
- (id)init {
    self = [super init];
	if (self) {
        sourceViewType = SourceViewTypeDefault;
    }
    return self;
}
-(void)initToolBar{
    
    if (toolBar ==nil) {
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, TOOLBAR_HEIGHT)];
        toolBar.barStyle = UIBarStyleBlackTranslucent;
        //toolBar.
        NSMutableArray *items = [[NSMutableArray alloc] init];
        UIBarButtonItem *itemFlexible = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonAction:)];
        
        [items addObject:itemFlexible];
        [items addObject:done];
        
        toolBar.items = items;
        
        [done release];
        [itemFlexible release];
        [items release];
    }
    //self.
    self.toolBar.frame = CGRectMake(0, VIEW_HEIGHT, self.toolBar.frame.size.width, self.toolBar.frame.size.height);
    
    [self.viewController.view addSubview:self.toolBar];
    
}
+ (KeyBoardConfig *)sharedInstance {
	@synchronized(self)
	{
		if  (instance  ==  nil)
		{
            instance = [[self alloc] init];
            
        }
    }
	return  instance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (instance == nil) {
            instance= [super allocWithZone:zone];
            return instance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (id)autorelease {
    return self;
}

- (void)dealloc {
    //if (sourceViewType == SourceViewTypeDefault) {
    [toolBar release];
    [viewController release];
    //}
    [sourceView release];
	[super dealloc];
}
-(void)doneButtonAction:(id)sender{
    if (delegate) {
        [delegate hiddenKeyBoardAction:self];
    }
}
-(void)registerForKeyboardNotifications:(id)sender WithView:(UIView *)view SourceViewType:(SourceViewType)type{
    if (type ==SourceViewTypeDefault ||view==nil) {
        [self registerForKeyboardNotifications:sender];
    }else{
        self.sourceViewType = type;
        sourceView = view;
        if ([sender isKindOfClass:[UIViewController class]]) {
            viewController = sender;
            [self registerForKeyboardNotificationsWithController:viewController];
        }
    }
}
-(void)registerForKeyboardNotificationsWithController:(UIViewController *)controller{
    
    viewController = controller;
    
    [self addKeyBoardNotification];
}
-(void) registerForKeyboardNotifications:(id)sender{
    if ([sender isKindOfClass:[UIViewController class]]) {
        
        viewController = sender;
        
        [self initToolBar];
        
        [self addKeyBoardNotification];
        
    }else{
        NSLog(@"sender is not a UIViewController or UIViewController subclass");
    }
}
-(void)addKeyBoardNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    //    if (version >= 5.0) {
    //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //    }
}
- (void) keyboardWillShow:(NSNotification *) notif{
    
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGSize keyboardSize = [value CGRectValue].size;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:ANIMATION_DURATION_TIME];
    if (sourceViewType ==SourceViewTypeDefault) {
        self.toolBar.frame = CGRectMake(0,self.viewController.view.frame.size.height - keyboardSize.height-self.toolBar.frame.size.height, self.toolBar.frame.size.width, self.toolBar.frame.size.height);
       
    }else{
        self.sourceView.frame = CGRectMake(0,self.viewController.view.frame.size.height - keyboardSize.height-self.sourceView.frame.size.height, self.sourceView.frame.size.width, self.sourceView.frame.size.height);
    }
    [UIView commitAnimations];
    
}

- (void) keyboardWillHide:(NSNotification *) notif{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:ANIMATION_DURATION_TIME];
    if (sourceViewType ==SourceViewTypeDefault) {
        self.toolBar.frame = CGRectMake(0, VIEW_HEIGHT, self.toolBar.frame.size.width, self.toolBar.frame.size.height);
        //NSLog(@"keyboardWillHide self.toolBar.frame: %@",NSStringFromCGRect(self.toolBar.frame));
    }else{
        self.sourceView.frame = CGRectMake(0, self.viewController.view.frame.size.height-self.sourceView.frame.size.height, self.sourceView.frame.size.width, self.sourceView.frame.size.height);
    }
    [UIView commitAnimations];
    
}

@end

