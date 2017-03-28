//
//  FTCoordinateInfo.m
//  Talkback
//
//  Created by xiachao on 15/6/25.
//
//

#import "FTCoordinateInfo.h"

@implementation FTCoordinateInfo

+(FTCoordinateInfo *)instance {
    static FTCoordinateInfo *instance = nil;
    @synchronized(self) {
        if (instance ==nil) {
            instance = [[FTCoordinateInfo alloc]init];
        }
    }
    return instance;
}

-(void)serialize:(NSMutableDictionary *)jsonObject{
    [jsonObject setObject:[NSNumber numberWithDouble:_longitude]  forKey:@"longitude"];
    [jsonObject setObject:[NSNumber numberWithDouble:_latitude]  forKey:@"latitude"];
    [jsonObject setObject:_address forKey:@"address"];
    if ([_chainId length]>0) {
         [jsonObject setObject:_chainId forKey:@"storeId"];
    }
    
}
-(void)deserialize:(NSDictionary *)jsonObject{
    _longitude =[[jsonObject valueForKey:@"longitude"]doubleValue];
    _latitude =[[jsonObject valueForKey:@"latitude"]doubleValue];
    _address = [jsonObject valueForKey:@"address"];
    _chainId= [jsonObject valueForKey:@"storeId"];
}

-(void)save {
    NSUserDefaults *ud = [[NSUserDefaults alloc]init];
    [ud setDouble:_longitude forKey:@"longtitude"];
    [ud setDouble:_latitude forKey:@"latitude"];
    [ud setValue:_address forKey:@"address"];
     [ud setValue:_chainId forKey:@"chainId"];
    [ud synchronize];
}

-(void)load {
    NSUserDefaults *ud = [[NSUserDefaults alloc]init];
    _longitude = [ud doubleForKey:@"longtitude"];
    _latitude = [ud doubleForKey:@"latitude"];
    _address = [ud valueForKey:@"address"];
    _chainId= [ud valueForKey:@"chainId"];
}
@end
