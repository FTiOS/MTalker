//
//  UIViewController+Toast.m
//  GoodPharmacist
//
//  Created by hexiayu on 15/2/7.
//  Copyright (c) 2015年 成都富顿科技有限公司. All rights reserved.
//

#import "UIViewController+Toast.h"


#define kToastHeight 38.0f
#define kDefaultDimissDelay 2.0f


NSString * const ftToastBackgroundColor = @"ToastBackgroundColor";
NSString * const ftToastTextColor = @"ToastTextColor";
NSString * const ftToastTextFont = @"ToastTextFont";
NSString * const ftToastIcon = @"ToastBarIcon";


static NSMutableDictionary *__defaultTopMessageConfig = nil;


@interface  ToastView()
@property (nonatomic, strong) NSTimer *dimissTimer;
@end



@implementation ToastView
- (void)dealloc
{
    [self.dimissTimer invalidate];
    self.dimissTimer = nil;
}
-(void)setFinshBlock:(finishBlock)block{
    theBlock =block;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
        self.label.backgroundColor = [UIColor clearColor];
//        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.label];
        
        self.iconIgv = [[UIImageView alloc] init];
        [self addSubview:self.iconIgv];
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        swipe.direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:swipe];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNow)];
        [self addGestureRecognizer:tap];
        
        [self resetViews];
    }
    return self;
}

- (void)resetViews
{
    if (!__defaultTopMessageConfig) {

        
        __defaultTopMessageConfig = [@{ftToastBackgroundColor : [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.95], ftToastTextColor : [UIColor whiteColor],ftToastTextFont : [UIFont boldSystemFontOfSize:15.0]} mutableCopy];
    }
    
    self.iconIgv.image = __defaultTopMessageConfig[ftToastIcon];
    self.backgroundColor = __defaultTopMessageConfig[ftToastBackgroundColor];
    self.label.textColor = __defaultTopMessageConfig[ftToastTextColor];
    self.label.font = __defaultTopMessageConfig[ftToastTextFont];
}

- (void)layoutSubviews
{
    //CGSize textSize = [self.label.text sizeWithFont:self.label.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.bounds) * 0.9, 20.f) lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize textSize = [self.label.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.bounds)*0.9,20.f) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes: @{NSFontAttributeName: self.label.font} context:nil].size;
    
    CGFloat betweenIconAndText  = 10.0f;
    CGFloat iconWidth = 20.0f;
    if (!self.iconIgv.image) {
        iconWidth = 0.0f;
    }
    self.iconIgv.frame = CGRectMake((CGRectGetWidth(self.bounds) - (textSize.width + iconWidth + betweenIconAndText)) * 0.5, (CGRectGetHeight(self.bounds) - iconWidth) * 0.5, iconWidth, iconWidth);
    self.label.frame = CGRectMake(CGRectGetMaxX(self.iconIgv.frame) + betweenIconAndText, (CGRectGetHeight(self.bounds) - textSize.height) * 0.5, textSize.width+10, textSize.height);
}

- (void)setWarningText:(NSString *)warningText
{
    _warningText = warningText;
    self.label.text = _warningText;
    [self setNeedsLayout];
}

- (void)tapNow
{
    if (self.tapHandler) {
        self.tapHandler();
    }
}

- (void)dismiss
{
    CGRect selfFrame = self.frame;
    selfFrame.origin.y -= CGRectGetHeight(selfFrame);
    
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = selfFrame;
        self.alpha = 0.3;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (theBlock!=nil) {
            theBlock();
        }
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview) {
        self.alpha = 1.0;
        CGRect selfFrame = self.frame;
        selfFrame.origin.y -= CGRectGetHeight(selfFrame);
        self.frame = selfFrame;
        selfFrame.origin.y = 0;
        
        [UIView animateWithDuration:0.25f animations:^{
            self.frame = selfFrame;
        } completion:^(BOOL finished) {
            [super willMoveToSuperview:newSuperview];
        }];
        
        [self.dimissTimer invalidate];
        self.dimissTimer = nil;
        self.dimissTimer = [NSTimer scheduledTimerWithTimeInterval:(self.dimissDelay == 0 ? kDefaultDimissDelay : self.dimissDelay) target:self selector:@selector(dismiss) userInfo:nil repeats:0];
    }else {
        [self.dimissTimer invalidate];
        self.dimissTimer = nil;
        [super willMoveToSuperview:newSuperview];
    }
}

-(void) setDimissDelay:(float)dimissDelay
{
    _dimissDelay = dimissDelay;
    if (self.dimissTimer != nil) {
        [self.dimissTimer invalidate];
        self.dimissTimer = nil;
        self.dimissTimer = [NSTimer scheduledTimerWithTimeInterval:(self.dimissDelay == 0 ? kDefaultDimissDelay : self.dimissDelay) target:self selector:@selector(dismiss) userInfo:nil repeats:0];
    }
}

@end

static char ToastWarningKey;
@implementation UIViewController (Toast)
+ (void)setToastMessageDefaultApperance:(NSDictionary *)apperance
{
    if (!__defaultTopMessageConfig) {
        __defaultTopMessageConfig = [NSMutableDictionary dictionary];
    }
    if (apperance) {
        UIColor *bgColor = apperance[ftToastBackgroundColor];
        if (bgColor && [bgColor isKindOfClass:[UIColor class]]) {
            __defaultTopMessageConfig[ftToastBackgroundColor] = bgColor;
        }
        
        UIColor *textColor = apperance[ftToastTextColor];
        if (textColor && [textColor isKindOfClass:[UIColor class]]) {
            __defaultTopMessageConfig[ftToastTextColor] = textColor;
        }
        
        UIImage *icon = apperance[ftToastIcon];
        if (icon && [icon isKindOfClass:[UIImage class]]) {
            __defaultTopMessageConfig[ftToastIcon] = icon;
        }
        
        UIFont *font = apperance[ftToastTextFont];
        if (font && [font isKindOfClass:[UIFont class]]) {
            __defaultTopMessageConfig[ftToastTextFont] = font;
        }
    }
}

- (void)showToastMessage:(NSString *)message
{
    [self showToastMessage:message toastConfig:nil dismissDelay:kDefaultDimissDelay withTapBlock:nil];
}
- (void)showToastMessage:(NSString *)message WithFinishBlock:finishBlock{
    [self showToastMessage:message toastConfig:nil dismissDelay:kDefaultDimissDelay withTapBlock:nil finishBlock:finishBlock];
}
- (void)showToastMessage:(NSString *)message toastConfig:(NSDictionary *)config dismissDelay:(float)delay withTapBlock:(dispatch_block_t)tapHandler{
    [self showToastMessage:message toastConfig:config dismissDelay:delay withTapBlock:tapHandler finishBlock:nil];
}

-(void) removeToastMessage
{
    ToastView *topView=(ToastView*)objc_getAssociatedObject(self, &ToastWarningKey);
    [topView dismiss];
}

- (void)showToastMessage:(NSString *)message toastConfig:(NSDictionary *)config dismissDelay:(float)delay withTapBlock:(dispatch_block_t)tapHandler finishBlock:(finishBlock)block
{
    ToastView *topV = objc_getAssociatedObject(self, &ToastWarningKey);
    topV.tag = 9999;
    if (!topV) {
        topV = [[ToastView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kToastHeight)];
        objc_setAssociatedObject(self, &ToastWarningKey, topV, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (block!=nil) {
        [topV setFinshBlock:block];
    }
    topV.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kToastHeight);
    topV.warningText = message;
    topV.tapHandler = tapHandler;
    topV.dimissDelay = delay;
    
    if (config) {
        UIColor *bgColor = config[ftToastBackgroundColor];
        if (bgColor && [bgColor isKindOfClass:[UIColor class]]) {
            topV.backgroundColor = bgColor;
        }
        
        UIColor *textColor = config[ftToastTextColor];
        if (textColor && [textColor isKindOfClass:[UIColor class]]) {
            topV.label.textColor = textColor;
        }
        
        UIImage *icon = config[ftToastIcon];
        if (icon && [icon isKindOfClass:[UIImage class]]) {
            topV.iconIgv.image = icon;
        }
        
        UIFont *font = config[ftToastTextFont];
        if (font && [font isKindOfClass:[UIFont class]]) {
            topV.label.font = font;
        }
        
    }else {
        [topV resetViews];
    }
    
    [self.view addSubview:topV];
}

-(void)showCommonErrorMsg:(NSString *)msg WithFinishBlock:(id)finishBlock
{
    NSDictionary *config = @{ftToastBackgroundColor : [UIColor redColor],ftToastTextColor : [UIColor whiteColor]};
    [self showToastMessage:msg toastConfig:config dismissDelay:1 withTapBlock:nil finishBlock:finishBlock];
}

@end
