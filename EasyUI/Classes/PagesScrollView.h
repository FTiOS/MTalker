//
//  LocalImageViewController.h
//  GoodPharmacist
//
//  Created by gophar on 14-10-10.
//  Copyright (c) 2014年 成都富顿科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PagesScrollViewDelegate;

@interface PagesScrollView : UIScrollView

@property (weak, nonatomic) id<PagesScrollViewDelegate>pagingViewDelegate;
@property (readonly) UIView *visiblePageView;
@property (assign) BOOL suspendTiling;

- (void)displayPagingViewAtIndex:(NSUInteger)index;
- (void)resetDisplay;

@end

@protocol PagesScrollViewDelegate <NSObject>

@required

- (Class)pagingScrollView:(PagesScrollView *)pagingScrollView classForIndex:(NSUInteger)index;
- (NSUInteger)pagingScrollViewPagingViewCount:(PagesScrollView *)pagingScrollView;
- (UIView *)pagingScrollView:(PagesScrollView *)pagingScrollView pageViewForIndex:(NSUInteger)index;
- (void)pagingScrollView:(PagesScrollView *)pagingScrollView preparePageViewForDisplay:(UIView *)pageView forIndex:(NSUInteger)index;
@optional
-(void)pagingScrollView:(PagesScrollView *)pagingScrollView didScrollatIndex:(NSInteger)index;
@end
