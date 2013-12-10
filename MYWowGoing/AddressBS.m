//
//  AddressBS.m
//  MYWowGoing
//
//  Created by ZhangMeng on 13-8-15.
//
//

#import "AddressBS.h"

@implementation AddressBS
- (void)dealloc{
    [_addressDic release];
    [super dealloc];
}

-(id)onExecute{
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:[NSString stringWithFormat:@"%@",[Util getLoginName]] forKey:@"loginId"];
    [common setValue:[NSString stringWithFormat:@"%@",[Util getPassword]] forKey:@"password"];
    
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:[self.addressDic objectForKey:@"cityName"] forKey:@"cityName"];
    [jsonreq setValue:[Util getCustomerID] forKey:@"customerid"];
    
    if (self.type == 1) {
        [jsonreq setValue:[self.addressDic objectForKey:@"name"] forKey:@"name"];
        [jsonreq setValue:[self.addressDic objectForKey:@"address"] forKey:@"address"];
        [jsonreq setValue:[self.addressDic objectForKey:@"phone"] forKey:@"phone"];
        [jsonreq setValue:[self.addressDic objectForKey:@"postCode"] forKey:@"postCode"];
    }
    
    NSString *sbreq=nil;
    NSError *error=nil;
    NSData *data=[NSJSONSerialization dataWithJSONObject:jsonreq options:NSJSONWritingPrettyPrinted error:&error];
    sbreq=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    NSString *urlString  = nil;
    if (self.type == 1) {
        urlString  = [NSString stringWithFormat:@"%@/%@",SEVERURL,CART_ADDRESS];
    }else{
    
        urlString  = [NSString stringWithFormat:@"%@/%@",SEVERURL,
                      CART_FINDADDRESS];
    
    }
       
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    requestForm.tag = self.type;
    [requestForm setShouldContinueWhenAppEntersBackground:YES];
    [requestForm setTimeOutSeconds:10];
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startSynchronous];
    return [requestForm autorelease];
    
}



@end
