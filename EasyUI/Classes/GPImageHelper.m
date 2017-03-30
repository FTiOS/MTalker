//
//  GPImageHelper.m
//  GoodPharmacist
//
//  Created by gophar on 14-10-10.
//  Copyright (c) 2014年 成都富顿科技有限公司. All rights reserved.
//

#import "GPImageHelper.h"


@implementation GPImageHelper
+ (GPImageHelper *)sharedGPImageHelper{
    static GPImageHelper *imageHelper=nil;
    if (imageHelper==nil) {
        NSLog(@"init the image helper");
           imageHelper =[[GPImageHelper alloc]init];
        imageHelper.selectImgs=[[NSMutableArray alloc]init];
        [imageHelper initAsset];
    }
    return imageHelper;
}
- (void)initAsset
{
    if (self.assetsLibrary == nil)
    {
        NSLog(@"init the assetsLibrary");
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
}

-(void)getGroupList{
    NSLog(@"start,get the group list");
    [self initAsset];
    if (_assetGroups==nil)  _assetGroups = [[NSMutableArray alloc] init];
    else [_assetGroups removeAllObjects];
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (!group )
        {
            // end of enumeration
            NSLog(@"end, get the group list");
            if ([self.delegate respondsToSelector:@selector(didFinishGetGroupList:)]) {
                [self.delegate didFinishGetGroupList:_assetGroups];
                
            }
            return;
        }
        else{
            NSLog(@"%@,%d",group,*stop);
            BOOL isExist=NO;
            for (ALAssetsGroup *TEMP in _assetGroups) {
                if (TEMP==group) {
                    isExist=YES;
                    return;
                }
            }
            if (isExist) {
                return;
            }
            if ([[group valueForProperty:ALAssetsGroupPropertyName]isEqualToString:@"Camera Roll"]||[[group valueForProperty:ALAssetsGroupPropertyName]isEqualToString:@"相机胶卷"]) {
                    [_assetGroups insertObject:group atIndex:0];
                }
            else
                    [_assetGroups addObject:group];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"end, get the group list,error:%@",error);
        if ([self.delegate respondsToSelector:@selector(didFalseGetGroupList:)]) {
            [self.delegate didFalseGetGroupList:error];
        }
    }];
}
-(void)getPhotoListOfGroup:(ALAssetsGroup *)alGroup{
    [self initAsset];
    NSLog(@"start,get the image list");
    _assetPhotos = [[NSMutableArray alloc] init];
    [alGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    self.selectGroupIndex=[self.assetGroups indexOfObject:alGroup];
    if ([self.delegate respondsToSelector:@selector(didSelectGroup:atIndex:)]) {
        [self.delegate didSelectGroup:alGroup atIndex:self.selectGroupIndex];
    }
    [alGroup enumerateAssetsUsingBlock:^(ALAsset *alPhoto, NSUInteger index, BOOL *stop) {
        if(alPhoto == nil)
        {
            if ([self.delegate respondsToSelector:@selector(didFinishGetImages:)]) {
                [self.delegate didFinishGetImages:_assetPhotos];
            }
            NSLog(@"end,get the image list");
            return;
        }
//            [_assetPhotos addObject:alPhoto];
        [_assetPhotos insertObject:alPhoto atIndex:0];
    }];
}
-(void)getPhotoListOfGroupByIndex:(NSInteger)nGroupIndex{
    [self getPhotoListOfGroup:[_assetGroups objectAtIndex:nGroupIndex]];
}
- (NSInteger)getGroupCount{
    return _assetGroups.count;
}
- (NSInteger)getPhotoCountOfCurrentGroup{
    return _assetPhotos.count;
}
- (NSDictionary *)getGroupInfo:(NSInteger)nIndex{
    
    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:[_assetGroups[nIndex] valueForProperty:ALAssetsGroupPropertyName],@"name" ,
                       @([_assetGroups[nIndex] numberOfAssets]),@"count" ,
                       [UIImage imageWithCGImage:[(ALAssetsGroup*)_assetGroups[nIndex] posterImage]],@"thumbnail" , nil];
    return dic;
}
- (UIImage *)getCroppedImage:(NSURL *)urlImage
{
    __block UIImage *iImage = nil;
    __block BOOL bBusy = YES;
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        NSString *strXMP = rep.metadata[@"AdjustmentXMP"];
        if (strXMP == nil || [strXMP isKindOfClass:[NSNull class]])
        {
            CGImageRef iref = [rep fullResolutionImage];
            if (iref)
                iImage = [UIImage imageWithCGImage:iref scale:1.0 orientation:(UIImageOrientation)rep.orientation];
            else
                iImage = nil;
        }
        else
        {
            // to get edited photo by photo app
            NSData *dXMP = [strXMP dataUsingEncoding:NSUTF8StringEncoding];
            
            CIImage *image = [CIImage imageWithCGImage:rep.fullResolutionImage];
            
            NSError *error = nil;
            NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:dXMP
                                                         inputImageExtent:image.extent
                                                                    error:&error];
            if (error) {
                NSLog(@"Error during CIFilter creation: %@", [error localizedDescription]);
            }
            
            for (CIFilter *filter in filterArray) {
                [filter setValue:image forKey:kCIInputImageKey];
                image = [filter outputImage];
            }
            
            iImage = [UIImage imageWithCIImage:image scale:1.0 orientation:(UIImageOrientation)rep.orientation];
        }
        
        bBusy = NO;
    };
    
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
    {
        NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
    };
    
    [_assetsLibrary assetForURL:urlImage
                    resultBlock:resultblock
                   failureBlock:failureblock];
    
    while (bBusy)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    
    return iImage;
}
- (UIImage *)getImageFromAsset:(ALAsset *)asset type:(ASSET_PHOTO_TYPE) nType
{
    CGImageRef iRef = nil;
    
    if (nType == ASSET_PHOTO_THUMBNAIL)
        iRef = [asset thumbnail];
    else if (nType == ASSET_PHOTO_SCREEN_SIZE)
        iRef = [asset.defaultRepresentation fullScreenImage];
    else if (nType == ASSET_PHOTO_FULL_RESOLUTION)
    {
        NSString *strXMP = asset.defaultRepresentation.metadata[@"AdjustmentXMP"];
        NSData *dXMP = [strXMP dataUsingEncoding:NSUTF8StringEncoding];
        
        CIImage *image = [CIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
        
        NSError *error = nil;
        NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:dXMP
                                                     inputImageExtent:image.extent
                                                                error:&error];
        if (error) {
            NSLog(@"Error during CIFilter creation: %@", [error localizedDescription]);
        }
        
        for (CIFilter *filter in filterArray) {
            [filter setValue:image forKey:kCIInputImageKey];
            image = [filter outputImage];
        }
        
        UIImage *iImage = [UIImage imageWithCIImage:image scale:1.0 orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
        return iImage;
    }
    
    return [UIImage imageWithCGImage:iRef];
}
- (UIImage *)getImageAtIndex:(NSInteger)nIndex type:(ASSET_PHOTO_TYPE)nType
{
    if (nIndex>=[_assetPhotos count]) {
        return nil;
    }
    ALAsset *mdl=_assetPhotos[nIndex];

    return [self getImageFromAsset:mdl type:nType];
}
- (ALAsset *)getAssetAtIndex:(NSInteger)nIndex
{
    ALAsset *mdl=_assetPhotos[nIndex];
    return mdl;
}
- (void)clearData{
    _assetPhotos=nil;
    _assetGroups=nil;
}


//
-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock
{
    //write the image data to the assets library (camera roll)
    [[GPImageHelper sharedGPImageHelper].assetsLibrary writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation
                                                                completionBlock:^(NSURL* assetURL, NSError* error) {
                                                                    
                                                                    //error handling
                                                                    if (error!=nil) {
                                                                        completionBlock(error,nil);
                                                                        return;
                                                                    }
                                                                    
                                                                    //add the asset to the custom photo album
                                                                    [self addAssetURL: assetURL
                                                                              toAlbum:albumName
                                                                  withCompletionBlock:completionBlock];
                                                                    
                                                                }];
}

-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock
{
    __block BOOL albumWasFound = NO;
     NSString *albumName1=@"xxxxxxxxxxxxxx";
    //search all photo albums in the library
    if (albumName==nil) {
        albumName=@"Camera Roll";
        albumName1=@"相机胶卷";
    }
    
    [[GPImageHelper sharedGPImageHelper].assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        //compare the names of the albums
        if ([albumName compare: [group valueForProperty:ALAssetsGroupPropertyName]]==NSOrderedSame||[albumName1 compare: [group valueForProperty:ALAssetsGroupPropertyName]]==NSOrderedSame) {
            
            //target album is found
            albumWasFound = YES;
            
            //get a hold of the photo's asset instance
            [[GPImageHelper sharedGPImageHelper].assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                //add photo to the target album
                [group addAsset: asset];
                //run the completion block
                completionBlock(nil,asset);
            } failureBlock:^(NSError *error) {
                completionBlock(error,nil);
            }];
            //album was found, bail out of the method
            return;
        }
        if (group==nil && albumWasFound==NO) {
                NSError *error=[[NSError alloc]initWithDomain:@"没有找到对应的相册" code:100 userInfo:nil
                                ];
                completionBlock(error,nil);
        }
    } failureBlock:^(NSError *error) {
        completionBlock(error,nil);
    }];
}

//

@end
