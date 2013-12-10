//
//  InvitationCodeBS.h
//  MYWowGoing
//
//  Created by WangKaifeng on 13-6-9.
//
//

#import "Service.h"

 
#import "JSON.h"

@interface InvitationCodeBS : BizService
@property (strong, nonatomic) NSString *invitetionCodeString; //邀请码的code
@end
