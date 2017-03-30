//
//  AssestCollectionViewCell.h
//  FSImageViewer
//
//  Created by hexiayu on 15/3/17.
//  Copyright (c) 2015年 Felix Schulze. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AssestCollectionViewCellDelegate;
@interface AssestCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic,strong)id<AssestCollectionViewCellDelegate> delegate;
- (IBAction)didSelect:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@end
@protocol AssestCollectionViewCellDelegate <NSObject>
-(void)didTap:(AssestCollectionViewCell *)cell;
@end