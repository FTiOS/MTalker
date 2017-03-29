//
//  FTRecommendDrug.m
//  Talkback
//
//  Created by xiachao on 15/6/25.
//
//

#import "FTRecommendDrug.h"
#import "FTDrugInfo.h"

@implementation FTRecommendDrug


- (instancetype)init
{
    self = [super init];
    if (self) {
        //_drugInfos = [[NSArray alloc]init];
    }
    return self;
}

-(void)serialize:(NSMutableDictionary *)jsonObject{
    [jsonObject setObject:[NSNumber numberWithLongLong:_storeId ] forKey:@"storeId"];
    [jsonObject setObject:_name forKey:@"name"];
    [jsonObject setObject:[NSNumber numberWithDouble:_longitude] forKey:@"longitude"];
    [jsonObject setObject:[NSNumber numberWithDouble:_latitude] forKey:@"latitude"];
    [jsonObject setObject:_address forKey:@"address"];
    [jsonObject setObject:[NSNumber numberWithInt:_type] forKey:@"type"];
    [jsonObject setObject:[NSNumber numberWithInt:_status] forKey:@"status"];
    [jsonObject setObject:[NSNumber numberWithFloat:_postage] forKey:@"postage"];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for(FTDrugInfo * drugInfo in _drugInfos){
        NSMutableDictionary * dictionary = [[NSMutableDictionary alloc]init];
        [drugInfo serialize:dictionary];
        [array addObject:dictionary];
    }
    
    [jsonObject setObject:array forKey:@"drugs"];
}

-(void)deserialize:(NSDictionary *)jsonObject{
    
    _storeId=[[jsonObject objectForKey:@"storeId"] longLongValue];
    _name= [jsonObject objectForKey:@"name"];
    _longitude = [[jsonObject objectForKey:@"longitude"] doubleValue];
    _latitude = [[jsonObject objectForKey:@"latitude"] doubleValue];
    _address= [jsonObject objectForKey:@"address"];
    _type = [[jsonObject objectForKey:@"type"] intValue];
    _status = [[jsonObject objectForKey:@"status"] intValue];
    _postage =[[jsonObject objectForKey:@"postage"] doubleValue];

    NSMutableArray *drugInfos = [[NSMutableArray alloc]init];
    
    NSArray * array = [jsonObject objectForKey:@"drugs"];
    for (NSDictionary *dictionary in array) {
        FTDrugInfo * drugInfo = [[FTDrugInfo alloc]init];
        [drugInfo deserialize:dictionary];
        [drugInfos addObject:drugInfo];
    }
    _drugInfos = drugInfos;
}

@end
