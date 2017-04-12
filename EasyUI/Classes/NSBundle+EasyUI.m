//
//  NSBundle+MyLibrary.m
//  EasyUI
//
//  Created by 何霞雨 on 2017/3/29.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "NSBundle+EasyUI.h"
#import "FTConsultUI.h"

@implementation NSBundle (EasyUI)
+ (NSBundle *)my_easyUIBundle {
    return [self bundleWithURL:[self my_myLibraryBundleURL]];
}
+ (NSURL *)my_myLibraryBundleURL {
    NSBundle *bundle = [NSBundle bundleForClass:[FTConsultUI class]];
    return [bundle URLForResource:@"EasyUI" withExtension:@"bundle"];
}

@end
