# MTalker

[![Version](https://img.shields.io/cocoapods/v/MTalker.svg?style=flat)](https://github.com/rRun/xy_podSepcs/tree/master/MTalker)
[![License](https://img.shields.io/cocoapods/l/MTalker.svg?style=flat)](https://github.com/rRun/xy_podSepcs/tree/master/MTalker)
[![Platform](https://img.shields.io/cocoapods/p/MTalker.svg?style=flat)](https://github.com/rRun/xy_podSepcs/tree/master/MTalker)

# EasyUI

[![Version](https://img.shields.io/cocoapods/v/MTalker.svg?style=flat)](https://github.com/rRun/xy_podSepcs/tree/master/EasyUI/)
[![License](https://img.shields.io/cocoapods/l/MTalker.svg?style=flat)](https://github.com/rRun/xy_podSepcs/tree/master/EasyUI/)
[![Platform](https://img.shields.io/cocoapods/p/MTalker.svg?style=flat)](https://github.com/rRun/xy_podSepcs/tree/master/EasyUI/)


## Example
if need easy ui,code:



        EasyUISettings *settings = [[EasyUISettings alloc]init];

        settings.platformKey = @"0";
        settings.appId = @"suibian";
        settings.tel = @"18200115355";
        settings.account = @"hjh";
        settings.dUserId = @"12";

        [[EasyUI instance] setup:settings startBlock:^(ConsultViewController *consultVC) {
            if (!consultVC) {
        return ;
        }
        [self presentViewController:consultVC animated:YES completion:nil];
        } finishBlock:^(ConsultViewController *consultVC, double callTime) {
        [consultVC dismissViewControllerAnimated:YES completion:nil];
        }];



else just need mtalker libaray,code:



        [[MTalkerClient shareTalker]loadSettings:[self settings] finishBlock:^(BOOL loadSuccess) {}];
        [MTalkerClient shareTalker].delegate = self;

        - (IBAction)mute:(id)sender {//静音
        if ([MTalkerClient shareTalker].avType == AV_Normal) {
        [MTalkerClient shareTalker].avType = AV_Mute|AV_Silent;
        }else{
        [MTalkerClient shareTalker].avType =AV_Normal;}
        }
        - (IBAction)picture:(id)sender {//上传图片
        [[MTalkerClient shareTalker]sendImage:@"www.baidu.com/xxx.png"];
        }
        - (IBAction)video:(id)sender {//视频切换
        [MTalkerClient shareTalker].isVideo = ![MTalkerClient shareTalker].isVideo;
        }
        - (IBAction)start:(id)sender {//开始咨询
        [[MTalkerClient shareTalker]login:[self simpleLogin]];
        }
        - (IBAction)end:(id)sender {//结束咨询
        [[MTalkerClient shareTalker]logout];
        }

        -(MTTalkerSetting *)settings{
        MTTalkerSetting *settings = [[MTTalkerSetting alloc]init];
        settings.decodeView = self.decodeView;
        settings.encodeView = self.encodeView;
        settings.api = @"https://xxx.xxx.xx:xxx/appService/appTwo!getServerAddress2.action";
        settings.parmas = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS",@"__os",@"2.17.5.0328",@"__ver",nil];
        settings.defaultVideo = YES;
        settings.keepTalkerType = YES;
        return settings;
        } 

        -(MTLoginInfo *)simpleLogin{
        return [MTLoginInfo simpleLogin:@"xxxx" User:@"13689098***"];
        }



## Requirements


To run the example project, clone the repo, and run `pod install --no-repo-update` from the Example directory first.

The podfile needs point sources :


    source 'https://github.com/rRun/xy_podSepcs.git'
    source 'https://github.com/CocoaPods/Specs.git'
    

    please do not use 
    
    "use_frameworks!"```

## Installation

MTalker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

if need using the ui framework,


```ruby
pod "EasyUI" 
```
else just use the mtalker libaray,

```ruby
pod "MTalker" 
```

## Author

rrun, hxy_sky@foxmail.com

## License

MTalker is available under the MIT license. See the LICENSE file for more info.
