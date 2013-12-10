//
//  AdproductsListBS.m
//  MYWowGoing
//
//  Created by zhangM on 13-4-24.
//
//

#import "AdproductsListBS.h"

#import "ASIHTTPRequest.h"
 
 
#import "JSON.h"
@implementation AdproductsListBS
@synthesize advertisementId=_advertisementId,pageNumber,requestTag;

- (id)onExecute
{
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:[NSString stringWithFormat:@"%@",USERNAME] forKey:@"loginId"];
    [common setValue:[NSString stringWithFormat:@"%@",PASSWORD] forKey:@"password"];

    NSMutableDictionary *jsonreq =[NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:[Util getAdViewCity] forKey:@"cityName"];
    [jsonreq setValue:[NSNumber numberWithInt:self.pageNumber] forKey:@"pageNumber"];
    
    [jsonreq setValue:self.advertisementId forKey:@"advertisementId"];
    
    NSString *sbreq=nil;
    NSError *error=nil;
    NSData *data=[NSJSONSerialization dataWithJSONObject:jsonreq options:NSJSONWritingPrettyPrinted error:&error];
    sbreq=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,ADDETAIL_LIST];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [requestForm setShouldContinueWhenAppEntersBackground:YES];
    [requestForm setTimeOutSeconds:10];
    requestForm.tag=self.requestTag;
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startSynchronous];
    return [requestForm autorelease];
}


-(void)dealloc{
    [_advertisementId release],_advertisementId=nil;
    [super dealloc];
}
@end
