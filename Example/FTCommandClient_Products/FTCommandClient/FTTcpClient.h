//
//  FTTcpClient.h
//  Talkback
//
//  Created by xiachao on 14/10/22.
//
//

#import <Foundation/Foundation.h>

//tcp连接状态
#define TCP_STATUS_CONNECTING  0//连接中
#define TCP_STATUS_CONNECT_SUCCESS  1//连接成功
#define TCP_STATUS_CONNECT_FAIL  2//连接失败
#define TCP_STATUS_DISCONNECTED  3//连接断开

@protocol FTTcpClientDelegate <NSObject>

-(void) onStatus:(int) status;
-(void) onRecv;

@end

@interface FTTcpClient : NSObject

@property (nonatomic,strong) NSString* ip;
@property (nonatomic) int port;
@property (nonatomic,weak) id<FTTcpClientDelegate>delegate;
@property (nonatomic,readonly) int status;

-(instancetype) init;

-(BOOL) open;
-(BOOL) isOpen;
-(void) close;

-(int) send:(const uint8_t*) buffer maxLength:(int)len;
-(int) recv:( uint8_t*) buffer maxLength:(int)len;
@end
