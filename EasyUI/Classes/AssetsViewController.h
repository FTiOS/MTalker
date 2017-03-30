//
//  AssetsViewController.h
//  FSImageViewer
//
//  Created by hexiayu on 15/3/17.
//  Copyright (c) 2015年 Felix Schulze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetsViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)doScan:(id)sender;
- (IBAction)doFinish:(id)sender;
@property(nonatomic,strong) NSArray *dataSourceArray;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
//最大选择数量
@property NSInteger maxSelectCount;
@end
