//
//  AssetsViewController.m
//  FSImageViewer
//
//  Created by hexiayu on 15/3/17.
//  Copyright (c) 2015年 Felix Schulze. All rights reserved.
//

#import "AssetsViewController.h"
#import "AssestCollectionViewCell.h"
#import "ImageScanViewController.h"
#import "UIView+Toast.h"
#import "NSBundle+EasyUI.h"

@interface AssetsViewController ()<AssestCollectionViewCellDelegate>{
    NSMutableArray *tempArr;
}
@property (weak, nonatomic) IBOutlet UIButton *previewButton;

@end

@implementation AssetsViewController

#pragma mark -
#pragma mark View Life Cycle

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
//    [tempArr removeAllObjects];
    [self.finishButton setTitle:[NSString stringWithFormat:@"%@ (%lu/%lu)",@"完成",(unsigned long)tempArr.count,(unsigned long)self.dataSourceArray.count] forState:UIControlStateNormal];
    [self.collectionView reloadData];
}


-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(doCancel)];
    tempArr=[[NSMutableArray alloc]init];
    [self.collectionView registerNib:[UINib nibWithNibName:@"AssestCollectionViewCell" bundle:[NSBundle my_easyUIBundle]] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
}


-(void)doCancel{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UICollectionView Data Source

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset=[self.dataSourceArray objectAtIndex:indexPath.row];
    NSInteger isChecked=[tempArr indexOfObject:asset];
  
    AssestCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (isChecked>2000000) {
        cell.checkButton.selected=NO;
    }
    else
        cell.checkButton.selected=YES;
    cell.delegate=self;
    cell.imageView.image = [[GPImageHelper sharedGPImageHelper] getImageFromAsset:asset type:ASSET_PHOTO_THUMBNAIL];
    return cell;
}

-(void)didTap:(AssestCollectionViewCell *)cell{
    if (!cell.checkButton.selected) {
        if (self.maxSelectCount > 0 && tempArr.count == self.maxSelectCount) {
            NSString *msg = [NSString stringWithFormat:@"%@", @"一次最多只能选择9张照片"];
            [self.view makeToastToBottom:msg];
            return;
        }
    }
    
    NSInteger index=[self.collectionView indexPathForCell:cell].row;
    ALAsset *mdl=[self.dataSourceArray objectAtIndex:index];
 
    [cell.checkButton setSelected:!cell.checkButton.selected];
//    cell.checkButton.selected=!cell.checkButton.selected;
    BOOL isSelected=cell.checkButton.selected;
    if (isSelected) {
        [tempArr addObject:mdl];
    }
    else{
        [tempArr removeObject:mdl];
    }
    [self.finishButton setTitle:[NSString stringWithFormat:@"上传（%d/%d）",tempArr.count,self.dataSourceArray.count] forState:UIControlStateNormal];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSourceArray ? [self.dataSourceArray count] : 0;
}


#pragma mark -
#pragma mark UICollectionView Delegate


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //do somthing, for example push Scroll Controller
    ImageScanViewController *imageViewController = [[ImageScanViewController alloc] initWithNibName:@"ImageScanViewController" bundle:nil];
    imageViewController.displayImages=[GPImageHelper sharedGPImageHelper].assetPhotos;
    [self.navigationController pushViewController:imageViewController animated:NO];
    [imageViewController setDisplayCellAtIndex:indexPath.row];
    
}

- (IBAction)doScan:(id)sender{
    if ([tempArr count]<=0) {
        return;
    }
    ImageScanViewController *imageViewController = [[ImageScanViewController alloc] initWithNibName:@"ImageScanViewController" bundle:nil];
    imageViewController.displayImages=tempArr;
    [self.navigationController pushViewController:imageViewController animated:NO];
}
- (IBAction)doFinish:(id)sender{
    
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"UploadImage" object:tempArr];
        }];
 
}
@end
