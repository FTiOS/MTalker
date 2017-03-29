//
//  FTTcpClient.m
//  Talkback
//
//  Created by xiachao on 14/10/22.
//
//

#import "FTTcpClient.h"
#define TAG "FTTcpClient:"


@interface FTTcpClient ()<NSStreamDelegate>{
    NSInputStream * _input;
    NSOutputStream * _output;
    NSThread *_thread;
    NSRunLoop * _runLoop;
}
@end

@implementation FTTcpClient


-(instancetype)init{
  
    
    self = [super init];
    if (self) {
        _status = TCP_STATUS_CONNECTING;
    }
    return self;
}

- (void)dealloc{
    [self close];
}

-(BOOL) isOpen{
    return _input!=nil;
}


-(BOOL)open{
    if(_ip.length <=0 || _port<=0 || _port>=65535){
        return NO;
    }
    
    if (self.isOpen) {
        return YES;
    }
    _status = TCP_STATUS_CONNECTING;

    CFReadStreamRef     readStream = NULL;
    CFWriteStreamRef    writeStream= NULL;
    CFStreamCreatePairWithSocketToHost(NULL,
                                       (__bridge CFStringRef) _ip,
                                       _port,
                                       &readStream,
                                       &writeStream);
    assert(readStream!=NULL && readStream!=NULL);
    
    CFReadStreamSetProperty(readStream, kCFStreamNetworkServiceType, kCFStreamNetworkServiceTypeVoIP);
    CFWriteStreamSetProperty(writeStream, kCFStreamNetworkServiceType, kCFStreamNetworkServiceTypeVoIP);
    
    _input = CFBridgingRelease(readStream);
    _output = CFBridgingRelease(writeStream);
    
    [_input setDelegate:self];
    [_output setDelegate:self];
    
    
    _thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:nil];
    [_thread start];
    while (_runLoop==nil) {
        [NSThread sleepForTimeInterval:0.02];
    }
    
    [_input scheduleInRunLoop:_runLoop
                      forMode:NSDefaultRunLoopMode];
    [_output scheduleInRunLoop:_runLoop
                       forMode:NSDefaultRunLoopMode];
    
    [_input open];
    [_output open];
    
    return YES;
}

-(void)close{
    
    if (self.isOpen) {
        [_input close];
        [_output close];
        
        [_input removeFromRunLoop:_runLoop
                          forMode:NSDefaultRunLoopMode];
        [_output removeFromRunLoop:_runLoop
                           forMode:NSDefaultRunLoopMode];
        [_thread cancel];
        _thread = nil;
        _runLoop = nil;
        _input = nil;
        _output = nil;
    }
}

-(int)send:(const uint8_t *)buffer maxLength:(int)len{
    if (!self.isOpen) {
        return 0;
    }
    if(!_output.hasSpaceAvailable)
        return 0;
        
    int writed = (int)[_output write:buffer maxLength:len];
    return writed;
}


-(int)recv:(uint8_t *)buffer maxLength:(int)len{
    if (!_input.hasBytesAvailable) {
        return 0;
    }
    
    return (int)[_input read:buffer maxLength:len];
}

- (void)run:(id)param{
    _runLoop = [NSRunLoop currentRunLoop];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate distantFuture]];
    } while (![NSThread currentThread].isCancelled);

}
-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    if(eventCode==NSStreamEventHasSpaceAvailable){
        if(_status==TCP_STATUS_CONNECTING){
            _status = TCP_STATUS_CONNECT_SUCCESS;
            NSLog(@TAG"connect success ip:%@,port:%d", _ip, _port);
            [_delegate onStatus:_status];
        }
    }else if(eventCode == NSStreamEventHasBytesAvailable){
       // NSLog(@TAG"onRecv");
        [_delegate onRecv];
    }else if(eventCode == NSStreamEventErrorOccurred){
        //NSLog(@TAG"NSStreamEventErrorOccurred");
        
        if(_status==TCP_STATUS_CONNECT_SUCCESS){
            _status=TCP_STATUS_DISCONNECTED;
            NSLog(@TAG"disconnect  ip:%@,port:%d", _ip, _port);
            [_delegate onStatus:_status];
            
        }else if(_status==TCP_STATUS_CONNECTING){
            _status =TCP_STATUS_CONNECT_FAIL;
            NSLog(@TAG"connect fail ip:%@,port:%d", _ip, _port);
            [_delegate onStatus:_status];
        }
    }else if(eventCode == NSStreamEventEndEncountered){
        if(_status==TCP_STATUS_CONNECT_SUCCESS){
            _status=TCP_STATUS_DISCONNECTED;
            NSLog(@TAG"disconnect  ip:%@,port:%d", _ip, _port);
            [_delegate onStatus:_status];
        }
     
    }
}

@end
