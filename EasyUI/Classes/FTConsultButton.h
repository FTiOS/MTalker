//
//  FTConsultButton.h
//  BYAlertView
//
//  Created by ft on 16/10/17.
//  Copyright © 2016年 BaoYong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTConsultButton : UIButton

@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UIImage *ft_selectedImage;
@property (nonatomic, strong) UIImage *ft_normalImage;
@property (nonatomic, strong) UIImage *ft_highlightImage;

@property (nonatomic, strong) NSString *descript;
@property (nonatomic, strong) NSString *selectedTitle; //seletedText

@property (nonatomic, strong) UIColor *ft_selectedColor; //可选设置
@property (nonatomic, strong) UIColor *ft_normalColor;

- (instancetype)initWithFrame:(CGRect)frame;
/*设置完图片后 必须调用*/
- (void)setUpSubview;

@end
