//
//  ViewController.m
//  ChatDemo
//
//  Created by 何霞雨 on 17/3/1.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "ViewController.h"

#import <ftcodec/FTVideoTalker.h>
#import <FTCommandClient/FTCommandClient.h>

@interface ViewController ()
{
    FTVideoTalker *talker;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)didConsult:(id)sender {
}
- (IBAction)startConsult:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [talker stopStream];
}
- (IBAction)doConsult:(id)sender {
}



@end
