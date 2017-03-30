//
//  UIViewController+Toast.h
//  GoodPharmacist
//
//  Created by hexiayu on 15/2/7.
//  Copyright (c) 2015年 成都富顿科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
typedef void(^finishBlock)(void);
@interface ToastView : UIView{
    finishBlock theBlock;
}
@property (nonatomic, strong) NSString *warningText;
@property (nonatomic, strong) UIImageView *iconIgv;
@property (nonatomic, copy) dispatch_block_t tapHandler;
@property (nonatomic, assign) float dimissDelay;
@property (nonatomic, strong) UILabel *label;

-(void)setFinshBlock:(finishBlock)block;
- (void)resetViews;

@end



@interface UIViewController (Toast)
/**
 *  Set the global default apperance of the top message, may be the appdelegate class is a good place to setup
 *
 *  @param apperance the top bar view config, the whole version will be @{ftToastBackgroundColor:[UIColor blueColor],ftToastTextColor : [UIColor yellowColor], ftToastIcon : [UIImage imageNamed:@"icon.png"], ftToastTextFont : [UIFont boldSystemFontOfSize:15.0]}
 */
+ (void)setToastMessageDefaultApperance:(NSDictionary *)apperance;
- (void)showToastMessage:(NSString *)message toastConfig:(NSDictionary *)config dismissDelay:(float)delay withTapBlock:(dispatch_block_t)tapHandler;
- (void)showToastMessage:(NSString *)message toastConfig:(NSDictionary *)config dismissDelay:(float)delay withTapBlock:(dispatch_block_t)tapHandler finishBlock:(finishBlock)block;
- (void)showToastMessage:(NSString *)message;
- (void)showToastMessage:(NSString *)message WithFinishBlock:finishBlock;
-(void) showCommonErrorMsg : (NSString*) msg WithFinishBlock:finishBlock;
-(void) removeToastMessage;
@end


extern NSString * const ftToastBackgroundColor;
extern NSString * const ftToastTextColor;
extern NSString * const ftToastTextFont;
extern NSString * const ftToastIcon;