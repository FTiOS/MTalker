//
//  GPImageHelper.h
//  GoodPharmacist
//
//  Created by gophar on 14-10-10.
//  Copyright (c) 2014年 成都富顿科技有限公司. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void (^SaveImageCompletion)(NSError *error,ALAsset*asset);

typedef enum{
    ASSET_PHOTO_THUMBNAIL,
    ASSET_PHOTO_SCREEN_SIZE,
    ASSET_PHOTO_FULL_RESOLUTION
} ASSET_PHOTO_TYPE;

@protocol GPImageHelperDelegate;
@interface GPImageHelper : NSObject
@property NSInteger selectGroupIndex;
@property (nonatomic, strong)   ALAssetsLibrary			*assetsLibrary;
@property (nonatomic, strong)   NSMutableArray          *assetPhotos;
@property (nonatomic, strong)   NSMutableArray          *assetGroups;
@property (nonatomic,weak)id<GPImageHelperDelegate> delegate;
@property (nonatomic,strong)NSMutableArray *selectImgs;
+ (GPImageHelper *)sharedGPImageHelper;

// get album list from asset
- (void)getGroupList;
// get photos from specific album with ALAssetsGroup object
- (void)getPhotoListOfGroup:(ALAssetsGroup *)alGroup;
// get photos from specific album with index of album array
- (void)getPhotoListOfGroupByIndex:(NSInteger)nGroupIndex;
//// get photos from camera roll
//- (void)getSavedPhotoList:(void (^)(NSArray *))result error:(void (^)(NSError *))error;


- (NSInteger)getGroupCount;
- (NSInteger)getPhotoCountOfCurrentGroup;
- (NSDictionary *)getGroupInfo:(NSInteger)nIndex;

- (void)clearData;



// utils
- (UIImage *)getCroppedImage:(NSURL *)urlImage;
- (UIImage *)getImageFromAsset:(ALAsset *)asset type:(ASSET_PHOTO_TYPE)nType;
- (UIImage *)getImageAtIndex:(NSInteger)nIndex type:(ASSET_PHOTO_TYPE)nType;
- (ALAsset *)getAssetAtIndex:(NSInteger)nIndex;


-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;

@end

@protocol GPImageHelperDelegate <NSObject>
// finished get album list from asset
@optional
-(void)didFinishGetGroupList:(NSArray*)/*the images groups*/groupsArray;
-(void)didFalseGetGroupList:(NSError *)error;
-(void)didFinishGetImages:(NSArray *)imagesArray;

-(void)didSelectGroup:(ALAssetsGroup *)group atIndex:(NSInteger)index;
-(void)didAddedAsset:(ALAsset*)asset atIndex:(NSInteger)index;
-(void)didDeletedAsset:(ALAsset*)asset atIndex:(NSInteger)index;


@end