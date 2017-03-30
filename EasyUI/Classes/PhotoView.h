//
//  LocalImageViewController.h
//  GoodPharmacist
//
//  Created by gophar on 14-10-10.
//  Copyright (c) 2014年 成都富顿科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoViewDelegate;

@interface PhotoView : UIScrollView
{
    UIImageView *_imageView;
}
@property (weak, nonatomic) id<PhotoViewDelegate> photoViewDelegate;

@property (nonatomic,strong)UIImageView *imageView;
- (void)prepareForReuse;
- (void)displayImage:(UIImage *)image;

- (void)updateZoomScale:(CGFloat)newScale;
- (void)updateZoomScale:(CGFloat)newScale withCenter:(CGPoint)center;

@end

@protocol PhotoViewDelegate <NSObject>

@optional

- (void)photoViewDidSingleTap:(PhotoView *)photoView;

@end