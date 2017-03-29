//
//  FTJsonSerializable.h
//  Talkback
//
//  Created by xiachao on 15/6/24.
//
//

#import <Foundation/Foundation.h>

@protocol FTJsonSerializable < NSObject>

-(void)deserialize:(NSDictionary*)jsonObject;
-(void)serialize:(NSMutableDictionary*)jsonObject;

@end
