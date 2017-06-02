//
//  ViewController.m
//  EasyUI
//
//  Created by 何霞雨 on 2017/4/5.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "ViewController.h"
#import "FTConsultUI.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)doConsult:(id)sender {
    
    EasyUISettings *settings = [[EasyUISettings alloc]init];
    
    settings.platformKey = @"0";
    settings.appId = @"101";
    settings.tel = @"15000000203";
    settings.account = @"xnzx";
    settings.dUserId = @"114750537156360124";
    settings.api = @"https://sdk.cdfortis.com";
    settings.port = 443;
    
    [[FTConsultUI instance] setup:settings startBlock:^(ConsultViewController *consultVC) {
        if (!consultVC) {
            return ;
        }
        [self presentViewController:consultVC animated:YES completion:nil];
    } finishBlock:^(ConsultViewController *consultVC, double callTime) {
        [consultVC dismissViewControllerAnimated:YES completion:nil];
    }];
    
}




@end
