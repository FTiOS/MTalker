//
//  ImageScanViewController.m
//  GoodPharmacist
//
//  Created by gophar on 14-10-11.
//  Copyright (c) 2014年 成都富顿科技有限公司. All rights reserved.
//

#import "ImageScanViewController.h"
#import "GPImageHelper.h"
@interface ImageScanViewController ()
{
    NSMutableArray *mutableArr;
}
@property (readonly) NSArray *customToolbarItems;
@end

@implementation ImageScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mutableArr=[[NSMutableArray alloc]init];
    
    [mutableArr addObjectsFromArray:self.displayImages];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self setToolbarItems:self.customToolbarItems animated:NO];
    
    if (!self.NoDelete) { //10月09日翻译问题修改
//        checkButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0,70,20)];
//        [checkButton setTitle:LOCALIZATION(@"SelectText") forState:UIControlStateNormal];
//        [checkButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
//        [checkButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f,10.0f,0.0f,0.0f)];
//        [checkButton setImage:[UIImage imageNamed:@"album_preview_unchecked"] forState:UIControlStateNormal];
//        [checkButton setImage:[UIImage imageNamed:@"album_preview_checked"] forState:UIControlStateSelected];
//        [checkButton addTarget:self action:@selector(tapChecked:) forControlEvents:UIControlEventTouchUpInside];
//        
//        
//        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:checkButton];
//[checkButton setSelected:YES];
    }
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.toolbar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController setToolbarHidden:NO animated:NO];
    
    [self setTitleIndex:_currentIndex];
    
    _pageView=[[PagesScrollView alloc]initWithFrame:self.view.bounds];
    _pageView.pagingViewDelegate=self;
    
    
    [self.view addSubview:_pageView];
    [_pageView displayPagingViewAtIndex:_currentIndex];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        _pageView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    });
}
-(void)doBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
     [self.navigationController setToolbarHidden:YES];
}
- (NSArray *)customToolbarItems {
    UIBarButtonItem *flexItem2 = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                  target:self
                                  action:nil];
    UIBarButtonItem *flexItem3 = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                  target:self
                                  action:nil];
    
    
    sendButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [sendButton setBackgroundColor:[UIColor colorWithRed:28/255.0 green:97/255.0 blue:220/255.0 alpha:1]];
    [sendButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [sendButton.titleLabel setTextAlignment:NSTextAlignmentRight];
    [sendButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [sendButton addTarget:self action:@selector(tapSend:) forControlEvents:UIControlEventTouchUpInside];
    
    [sendButton setTitle:[NSString stringWithFormat:@"%@（%lu/%lu）",@"完成",(unsigned long)mutableArr.count,(unsigned long)(_displayImages.count<=9?_displayImages.count:9)] forState:UIControlStateNormal];
    
    UIBarButtonItem *sendButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sendButton];
    
    return @[flexItem2, flexItem3, sendButtonItem];
}

- (void)tapBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapSend:(id)sender {
//    [self.navigationController popToRootViewControllerAnimated:YES];
    if (mutableArr.count > 0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"UploadImage" object:mutableArr];
    }
    
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)tapChecked:(id)sender{
  
    UIButton *btn=(UIButton *)sender;
    if (mutableArr.count>=9&&!btn.isSelected) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"一次最多只能上传9张图片" delegate:nil cancelButtonTitle:@"确定"  otherButtonTitles: nil] show];
        return;
    }
    btn.selected=!btn.selected;
    NSInteger index=_currentIndex;
    ALAsset *mdl=[_displayImages objectAtIndex:index];
    NSInteger ischecked=[mutableArr  indexOfObject:mdl];
    if (ischecked<0 || !btn.selected) {
        [self deselectAsset:mdl];
    }
    else{
        if (mutableArr.count>=9) {
            [[[UIAlertView alloc]initWithTitle:nil message:@"一次最多只能上传9张图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            return;
        }
        [self selectAsset:mdl];
    }
    [sendButton setTitle:[NSString stringWithFormat:@"%@（%lu/%lu）",@"完成",(unsigned long)mutableArr.count,(unsigned long)(_displayImages.count<=9?_displayImages.count:9)] forState:UIControlStateNormal];
}
-(void)selectAsset:(ALAsset*)asset{
    [mutableArr addObject:asset];
}
-(void)deselectAsset:(ALAsset*)asset{
    [mutableArr removeObject:asset];
}
- (void)showMinimumSize:(id)sender {
    PhotoView *photoView  = (PhotoView *)_pageView.visiblePageView;
    [photoView updateZoomScale:photoView.minimumZoomScale];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    // suspend tiling while rotating
    _pageView.suspendTiling = YES;
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    _pageView.suspendTiling = NO;
    [_pageView  resetDisplay];
}
-(void)setDisplayCellAtIndex:(NSInteger)index
{
    _currentIndex=index;
}


#pragma mark -pageview delegate
- (Class)pagingScrollView:(PagesScrollView *)pagingScrollView classForIndex:(NSUInteger)index{
    return [PhotoView class];
}
- (NSUInteger)pagingScrollViewPagingViewCount:(PagesScrollView *)pagingScrollView{
    _totalImages=[_displayImages count];
    return _totalImages;
}

- (UIView *)pagingScrollView:(PagesScrollView *)pagingScrollView pageViewForIndex:(NSUInteger)index{
    PhotoView *photoView = [[PhotoView alloc] initWithFrame:_tableView.bounds];
    photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    photoView.photoViewDelegate = self;
    return photoView;

}
- (void)pagingScrollView:(PagesScrollView *)pagingScrollView preparePageViewForDisplay:(UIView *)pageView forIndex:(NSUInteger)index{
    [self setTitleIndex:index];
    PhotoView *photoView = (PhotoView *)pageView;
    ALAsset *mdl=[_displayImages objectAtIndex:index];
    NSInteger check=[mutableArr indexOfObject:mdl];
    if (check<0 || check > _displayImages.count) {
       checkButton.selected=NO;
    }
    else{
        checkButton.selected=YES;
    }

    [photoView displayImage:[[GPImageHelper sharedGPImageHelper] getImageFromAsset:mdl type:ASSET_PHOTO_THUMBNAIL]];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image=[[GPImageHelper sharedGPImageHelper] getImageFromAsset:mdl type:ASSET_PHOTO_SCREEN_SIZE];
        dispatch_async(dispatch_get_main_queue(), ^{
            [photoView displayImage:image];
        });
        
    });
}
-(void)pagingScrollView:(PagesScrollView *)pagingScrollView didScrollatIndex:(NSInteger)index{
    NSInteger allCount=[_displayImages count];
    if (index>=allCount) {
        return;
    }
    checkButton.enabled=YES;
    _currentIndex=index;
    [self setTitleIndex:index];
    ALAsset *mdl=[_displayImages objectAtIndex:index];
    NSInteger check=[mutableArr indexOfObject:mdl];
    if (check<0|| check > _displayImages.count) {
        checkButton.selected=NO;
    }
    else{
        checkButton.selected=YES;
    }
    
}
-(void)changeImage:(NSArray *)array{
    
}
#pragma mark - PhotoViewDelegate
#pragma mark -

- (void)photoViewDidSingleTap:(PhotoView *)photoView {
//    [self toggleFullScreen];
}

#pragma mark -tools
- (void)toggleFullScreen {
    if (self.navigationController.navigationBar.alpha == 0.0) {
        // fade in navigation
        
        [UIView animateWithDuration:0.4 animations:^{
            self.navigationController.navigationBar.alpha = 1.0;
            self.navigationController.toolbar.alpha = 1.0;
        } completion:^(BOOL finished) {
            self.navigationController.navigationBarHidden=NO;
        }];
    }
    else {
        // fade out navigation
        self.navigationController.navigationBarHidden=YES;
        [UIView animateWithDuration:0.4 animations:^{
            self.navigationController.navigationBar.alpha = 0.0;
            self.navigationController.toolbar.alpha = 0.0;
        } completion:^(BOOL finished) {
        }];
    }
}

-(void)setTitleIndex:(NSInteger)index{
    NSInteger scanNum=index+1;
    NSInteger scanTotal;
    scanTotal=_displayImages.count;
    //LOCALIZATION(@"PreviewText")
    self.navigationItem.title=[NSString stringWithFormat:@"%ld/%ld", (long)scanNum,(long)scanTotal];
}
@end
