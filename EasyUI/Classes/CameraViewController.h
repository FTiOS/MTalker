//
//  HomeViewController.h
//  LLSimpleCameraExample
//
//  Created by Ömer Faruk Gül on 29/10/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLSimpleCamera.h"
#import <AssetsLibrary/AssetsLibrary.h>
@protocol CameraViewControllerDelegate;
@interface CameraViewController: UIViewController <LLSimpleCameraDelegate>
@property (nonatomic,weak)id<CameraViewControllerDelegate>delegate;
-(void)flashCamer;
@end

@protocol CameraViewControllerDelegate <NSObject>
- (void)cameraViewController:(CameraViewController *)cameraVC didCaptureImage:(UIImage *)image alasset:(ALAsset *)asset;

@end
