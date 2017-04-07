//
//  MTDevice.m
//  MTalker
//
//  Created by 何霞雨 on 2017/3/22.
//  Copyright © 2017年 rrun. All rights reserved.
//

#import "MTDevice.h"
#import <UIKit/UIDevice.h>
#import <UIKit/UIScreen.h>

#import <mach/machine.h>
#import <mach/mach_host.h>
#import <sys/utsname.h>
#import <AdSupport/ASIdentifierManager.h>

#import "KeychainItemWrapper/KeychainItemWrapper.h"

#define UDID @"com.cdfortis.device"

@implementation MTDevice

-(id)init{
    self=[super init];
    if (self) {
        [self initDeviceInfo];
        [self initAppInfo];
        [self bindUDID];
    }
    return self;
}

//设备信息
-(void)initDeviceInfo{
    //设备信息
    UIDevice *device = [UIDevice currentDevice];
    NSString *name = device.name;       //获取设备所有者的名称
    NSString *model = device.model;      //获取设备的类别
    NSString *type = device.localizedModel; //获取本地化版本
    NSString *systemName = device.systemName;   //获取当前运行的系统
    NSString *systemVersion = device.systemVersion;//获取当前系统的版本
    NSString *osType = @"iOS";
    
    //    struct utsname systemInfo;
    //    uname(&systemInfo);
    //    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //    model = deviceString;//设备详细类别 借鉴：http://www.cnblogs.com/shadox/archive/2013/02/05/2893017.html
    
    model = [self getDeviceType];
    if(!model){
        model = @"Unknown model";
    }
    //系统架构
    NSString *cpu=[self cpuNameByType:[self getSubCpuType]];//获取cpu
    //屏幕信息
    UIScreen *screen=[UIScreen mainScreen];
    CGFloat scale_screen = screen.scale;
    CGRect rect_screen = [screen bounds];
    CGSize size_screen = rect_screen.size;
    NSString *resolution=[NSString stringWithFormat:@"%d*%d",(int)(size_screen.width*scale_screen),(int)(size_screen.height*scale_screen)];
    NSString *dpi=[NSString stringWithFormat:@"%d",(int)screen.scale];
    
    NSLog(@"系统信息");
    NSLog(@"系统信息_名字:%@",name);
    NSLog(@"系统信息_类别:%@",model);
    NSLog(@"系统信息_本地化版本:%@",type);
    NSLog(@"系统信息_系统:%@",systemName);
    NSLog(@"系统信息_CPU:%@",cpu);
    NSLog(@"系统信息_系统类型:%@",osType);
    NSLog(@"系统信息_系统版本:%@",systemVersion);
    NSLog(@"系统信息_分辨率:%@",resolution);
    NSLog(@"系统信息_dpi:%@",dpi);
    
    self.resolution=resolution;
    self.dpi=dpi;
    self.osType= [NSString stringWithFormat:@"%@",osType];
    self.channel=@"appstore";
    self.osVersion = systemVersion;
    self.deviceType=model;
    self.cpu=cpu;
}

//app信息
-(void)initAppInfo{
    NSDictionary *appInfo=[[NSBundle mainBundle] infoDictionary];
    NSLog(@"软件信息:\n%@",appInfo);
    NSString *version=[appInfo objectForKey:@"CFBundleShortVersionString"];//版本号
    NSString *buildCode=[appInfo objectForKey:@"CFBundleVersion"];//编译号
    
    self.version=[NSString stringWithFormat:@"%@.%@",version,buildCode];
    
    NSString *bundleIdentifier=[appInfo objectForKey:@"CFBundleIdentifier"];//app ID
    self.appId=bundleIdentifier;
    
}

-(void)bindUDID{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc]
                                         initWithIdentifier:@"UUID"
                                         accessGroup:nil];
    NSString *strUUID = [keychainItem objectForKey:(__bridge id)kSecValueData];
    
    if (![strUUID isKindOfClass:[NSString class]]||strUUID==nil)
    {
        NSError *error=nil;
        NSString *udid=[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];;
        if (error) {
            NSLog(@"uiid:%@,error:%@",udid,[error localizedDescription]);
        }
        [keychainItem setObject:UDID forKey:(__bridge id)kSecAttrAccount];
        [keychainItem setObject:udid forKey:(__bridge id)kSecValueData];
        
        strUUID=udid;
    }
    self.deviceId = strUUID;
}

#pragma mark - 设备类型
-(NSString *)getDeviceType{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    
    static NSDictionary* deviceNamesByCode = nil;
    if (!deviceNamesByCode) {
        deviceNamesByCode = @{@"i386"      :@"Simulator",
                              @"x86_64"    :@"Simulator",
                              @"iPod1,1"   :@"iPod Touch",
                              @"iPod2,1"   :@"iPod Touch",
                              @"iPod3,1"   :@"iPod Touch",
                              @"iPod4,1"   :@"iPod Touch",
                              @"iPhone1,1" :@"iPhone",
                              @"iPhone1,2" :@"iPhone",
                              @"iPhone2,1" :@"iPhone",
                              @"iPad1,1"   :@"iPad",
                              @"iPad2,1"   :@"iPad 2",
                              @"iPad3,1"   :@"iPad",
                              @"iPhone3,1" :@"iPhone 4",
                              @"iPhone4,1" :@"iPhone 4S",
                              @"iPhone5,1" :@"iPhone 5",
                              @"iPhone5,2" :@"iPhone 5",
                              @"iPad3,4"   :@"iPad",
                              @"iPad2,5"   :@"iPad Mini",
                              @"iPhone5,3" :@"iPhone 5c",
                              @"iPhone5,4" :@"iPhone 5c",
                              @"iPhone6,1" :@"iPhone 5s",
                              @"iPhone6,2" :@"iPhone 5s",
                              @"iPad4,1"   :@"iPad Air",
                              @"iPad4,2"   :@"iPad Air",
                              @"iPad2,5"   :@"iPad Mini",
                              @"iPad2,6"   :@"iPad Mini" ,
                              @"iPad2,7"   :@"iPad Mini",
                              @"iPad4,4"   :@"iPad Mini",
                              @"iPad4,5"   :@"iPad Mini" ,
                              @"iPad4,6"   :@"iPad Mini",
                              @"iPad4,7"   :@"iPad Mini",
                              @"iPad4,8"   :@"iPad Mini",
                              @"iPad4,9"   :@"iPad Mini",
                              @"iPhone7,1" :@"iPhone 6 Plus",       // Phone 6 Plus
                              @"iPhone7,2" :@"iPhone 6",            // Phone 6 Plus
                              };
    }
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    
    if(!deviceName){
        deviceName = code;
    }
    return deviceName;
}

#pragma mark -CPU
-(cpu_type_t)getSubCpuType{
    host_basic_info_data_t hostInfo;
    mach_msg_type_number_t infoCount=HOST_BASIC_INFO_COUNT;
    kern_return_t ret=host_info(mach_host_self(),HOST_BASIC_INFO,(host_info_t)&hostInfo,&infoCount);
    if (ret==KERN_SUCCESS) {
        NSLog(@"the cpu_subtype is:%d",hostInfo.cpu_subtype);
    }
    return hostInfo.cpu_type;
}
-(NSString *)cpuNameByType:(cpu_type_t)type{
    NSString *cpuName=@"unknown";
    switch (type) {
        case CPU_TYPE_ANY:
            cpuName=@"Any";
            break;
        case CPU_TYPE_VAX:
            cpuName=@"Vax";
            break;
        case CPU_TYPE_MC680x0:
            cpuName=@"MC680x0";
            break;
            //        case CPU_TYPE_X86: x86 ==i386
            //            cpuName=@"X86";
            //            break;
        case CPU_TYPE_I386:
            cpuName=@"I386";
            break;
        case CPU_TYPE_X86_64:
            cpuName=@"X86_64";
            break;
        case CPU_TYPE_MC98000:
            cpuName=@"MC98000";
            break;
        case CPU_TYPE_HPPA:
            cpuName=@"HPPA";
            break;
        case CPU_TYPE_ARM:
            cpuName=@"ARM";
            break;
        case CPU_TYPE_ARM64:
            cpuName=@"ARM64";
            break;
        case CPU_TYPE_MC88000:
            cpuName=@"MC88000";
            break;
        case CPU_TYPE_SPARC:
            cpuName=@"SPARC";
            break;
        case CPU_TYPE_I860:
            cpuName=@"I860";
            break;
        case CPU_TYPE_POWERPC:
            cpuName=@"POWERPC";
            break;
        case CPU_TYPE_POWERPC64:
            cpuName=@"POWERPC64";
            break;
        default:
            cpuName=@"unknown";
            break;
    }
    return cpuName;
}

@end
