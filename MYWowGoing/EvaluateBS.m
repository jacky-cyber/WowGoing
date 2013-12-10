//
//  EvaluateBS.m
//  MYWowGoing
//
//  Created by ZhangMeng on 13-8-15.
//
//

#import "EvaluateBS.h"

@implementation EvaluateBS
-(void)dealloc{
    [_evaluateDic release];
    [super dealloc];
}

-(id)onExecute{
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:[NSString stringWithFormat:@"%@",[Util getLoginName]] forKey:@"loginId"];
    [common setValue:[NSString stringWithFormat:@"%@",[Util getPassword]] forKey:@"password"];
    
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:[Util getCustomerID] forKey:@"customerId"];
    [jsonreq setValue:[self.evaluateDic objectForKey:@"orderId"] forKey:@"orderId"];
    [jsonreq setValue:[self.evaluateDic objectForKey:@"shopId"] forKey:@"shopId"];
    [jsonreq setValue:[self.evaluateDic objectForKey:@"content"] forKey:@"content"];
     [jsonreq setValue:[NSString stringWithFormat:@"%d",self.evaluateType] forKey:@"evaluateType"];
    
    if (self.evaluateType == 1) {
        [jsonreq setValue:[self.evaluateDic objectForKey:@"isCall"] forKey:@"isCall"];
        [jsonreq setValue:[self.evaluateDic objectForKey:@"isRecom"] forKey:@"isRecom"];
        [jsonreq setValue:[self.evaluateDic objectForKey:@"isOther"] forKey:@"isOther"];
        [jsonreq setValue:[self.evaluateDic objectForKey:@"serveGrade"] forKey:@"serveGrade"];
       
    }else if (self.evaluateType == 2){
        [jsonreq setValue:[self.evaluateDic objectForKey:@"noStock"] forKey:@"noStock"];
        [jsonreq setValue:[self.evaluateDic objectForKey:@"noSize"] forKey:@"noSize"];
        [jsonreq setValue:[self.evaluateDic objectForKey:@"noLike"] forKey:@"noLike"];
        [jsonreq setValue:[self.evaluateDic objectForKey:@"noGood"] forKey:@"noGood"];
    }else{
       
        [jsonreq setValue:[self.evaluateDic objectForKey:@"noStock"] forKey:@"noStock"];
        [jsonreq setValue:[self.evaluateDic objectForKey:@"noSize"] forKey:@"noSize"];
        [jsonreq setValue:[self.evaluateDic objectForKey:@"noLike"] forKey:@"noLike"];
        [jsonreq setValue:[self.evaluateDic objectForKey:@"noGood"] forKey:@"noGood"];
        
        [jsonreq setValue:[self.evaluateDic objectForKey:@"wrong"] forKey:@"wrong"];
        [jsonreq setValue:[self.evaluateDic objectForKey:@"IsToShop"] forKey:@"IsToShop"];
    }
    
    NSString *sbreq=nil;
    NSError *error=nil;
    NSData *data=[NSJSONSerialization dataWithJSONObject:jsonreq options:NSJSONWritingPrettyPrinted error:&error];
    sbreq=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,CUSTOM_EVALUATE];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [requestForm setShouldContinueWhenAppEntersBackground:YES];
    [requestForm setTimeOutSeconds:10];
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startSynchronous];
    return [requestForm autorelease];
    
}




@end
