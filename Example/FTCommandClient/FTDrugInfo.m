//
//  FTDrugInfo.m
//  Talkback
//
//  Created by xiachao on 15/6/25.
//
//

#import "FTDrugInfo.h"

@implementation FTDrugInfo

-(void)serialize:(NSMutableDictionary *)jsonObject{
    [jsonObject setObject:_company forKey:@"company"];
    [jsonObject setObject:_dosage forKey:@"dosage"];
    [jsonObject setObject:_drugName forKey:@"drugName"];
    [jsonObject setObject:_pic forKey:@"pic"];
    [jsonObject setObject:_packing forKey:@"packing"];
    [jsonObject setObject:[NSNumber numberWithInteger:_consultId] forKey:@"consultId"];
    [jsonObject setObject:[NSNumber numberWithInteger:_drugNum] forKey:@"drugNum"];
    [jsonObject setObject:[NSNumber numberWithInteger:_onsellId] forKey:@"onsellId"];
    [jsonObject setObject:[NSNumber numberWithInteger:_type] forKey:@"type"];
    [jsonObject setObject:[NSNumber numberWithDouble:_price] forKey:@"price"];
    [jsonObject setObject:[NSNumber numberWithBool:_isTax] forKey:@"isTax"];
}

-(void)deserialize:(NSDictionary *)jsonObject{

    _company =[jsonObject objectForKey:@"company"];
     _dosage =[jsonObject objectForKey:@"dosage"];
     _drugName = [jsonObject objectForKey:@"drugName"];
    _pic =[jsonObject objectForKey:@"pic"];
    _packing = [jsonObject objectForKey:@"packing"];
    
    _consultId = [[jsonObject objectForKey:@"consultId"] integerValue];
    _drugNum =[[jsonObject objectForKey:@"drugNum"] integerValue];
    _onsellId =[[jsonObject objectForKey:@"onsellId"] integerValue];
    _type = [[jsonObject objectForKey:@"type"] integerValue];
    _price =[[jsonObject objectForKey:@"price"] doubleValue];
    
    _isTax = [[jsonObject objectForKey:@"isTax"] integerValue];
}

@end
