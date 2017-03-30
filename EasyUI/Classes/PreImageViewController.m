//
//  PreImageViewController.m
//  cdoctor
//
//  Created by 成都富顿科技－向乾操 on 16/7/12.
//  Copyright © 2016年 ft. All rights reserved.
//

#import "PreImageViewController.h"

@interface PreImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation PreImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _contentImageView.image = _contentImage;
    [_cancelButton setTitle:@"重拍" forState:UIControlStateNormal];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
}
- (IBAction)buttonAction:(UIButton *)sender {
    
    if (self.preImageViewControllerButtonClicked) {
        self.preImageViewControllerButtonClicked(_contentImage,sender.tag == 10 ? NO : YES);
    }
}

@end
