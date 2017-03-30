//
//  ImageScanViewController.h
//  GoodPharmacist
//
//  Created by gophar on 14-10-11.
//  Copyright (c) 2014年 成都富顿科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPImageHelper.h"
#import "PagesScrollView.h"
#import "PhotoView.h"


@interface ImageScanViewController : UIViewController<PagesScrollViewDelegate,PhotoViewDelegate>
{
    UITableView *_tableView;
    BOOL isTaped;
    
    NSInteger _currentIndex;
    NSInteger _totalImages;
    
    PagesScrollView *_pageView;
    NSMutableArray *_displayImages;
    
    UIButton *sendButton;
    UIBarButtonItem *backButton;
    UIButton *checkButton;
}

@property(nonatomic,strong)NSMutableArray *displayImages;

@property BOOL isScanView;
@property(nonatomic) BOOL NoDelete;
-(void)setDisplayCellAtIndex:(NSInteger)index;

@end

