//
//  PreImageViewController.h
//  cdoctor
//
//  Created by 成都富顿科技－向乾操 on 16/7/12.
//  Copyright © 2016年 ft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreImageViewController : UIViewController

@property (nonatomic, strong) UIImage *contentImage;
@property (nonatomic, copy) void (^preImageViewControllerButtonClicked) (UIImage *imageData, BOOL isSend);

@end
