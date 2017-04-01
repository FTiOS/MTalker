//
//  MTViewController.m
//  MTalker
//
//  Created by rrun on 03/21/2017.
//  Copyright (c) 2017 rrun. All rights reserved.
//

#import "MTViewController.h"
#import "MTalkerClient.h"

@interface MTViewController ()<MTTalkerCommandDelegate>

@end

@implementation MTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //配置
    [[MTalkerClient shareTalker]loadSettings:[self settings]];
    [MTalkerClient shareTalker].delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mute:(id)sender {
    if ([MTalkerClient shareTalker].avType == AV_Normal) {
        [MTalkerClient shareTalker].avType = AV_Mute|AV_Silent;
    }else{
        [MTalkerClient shareTalker].avType =AV_Normal;
    }
}

- (IBAction)picture:(id)sender {
    [[MTalkerClient shareTalker]sendImage:@"www.baidu.com/xxx.png"];
}

- (IBAction)video:(id)sender {
    [MTalkerClient shareTalker].isVideo = ![MTalkerClient shareTalker].isVideo;
}

- (IBAction)start:(id)sender {
    [[MTalkerClient shareTalker]login:[self simpleLogin] finishBlock:^(BOOL loginSuccess) {
        
    }];
}

- (IBAction)end:(id)sender {
    [[MTalkerClient shareTalker]logout];
}

#pragma mark - setting
-(MTTalkerSetting *)settings{
   MTTalkerSetting *settings = [[MTTalkerSetting alloc]init];
    settings.decodeView = self.decodeView;
    settings.encodeView = self.encodeView;
    settings.api = @"https://9.cdfortis.com:8443/appService/appTwo!getServerAddress2.action";
    settings.parmas = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS",@"__os",@"2.17.5.0328",@"__ver",nil];
    settings.defaultVideo = YES;
    settings.keepTalkerType = YES;
    return settings;
} 
#pragma mark - login
-(MTLoginInfo *)simpleLogin{
    return [MTLoginInfo simpleLogin:@"gaofen" User:@"18200115355"];
}

#pragma mark - MTTalkerCommandDelegate
//command-命令，instance-传递的参数，info-参数的作用解释说明
-(void)receiveCommand:(CommandType)command withInstance:(NSString *)instance withInfo:(NSString*)info{
    NSLog(@"%@:%ld,%@",info,(long)command,instance);
}
//drugs-药品数据，pharmacy-药店数据,postage-邮费
-(void)receiveDrugs:(NSArray<MTDrug *> *)drugs withPharmacy:(MTPharmacy *)pharmacy withPostage:(double)postage{
    NSLog(@"收到药品:%f：%\n%@",postage,drugs,pharmacy);
}
@end
