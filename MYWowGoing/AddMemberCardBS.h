//
//  AddMemberCardBS.h
//  MYWowGoing
//
//  Created by WangKaifeng on 13-8-15.
//
//

#import "Service.h"

@interface AddMemberCardBS : BizService
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;

@property (strong, nonatomic) NSString *membershipNumberString; //用户更改后的会员卡卡号
@property (strong, nonatomic) NSString *memberInfoIdString;//会员卡id
@property (strong, nonatomic) NSString *customeridString; //用户id
@end
