//
//  AssestCollectionViewCell.m
//  FSImageViewer
//
//  Created by hexiayu on 15/3/17.
//  Copyright (c) 2015年 Felix Schulze. All rights reserved.
//

#import "AssestCollectionViewCell.h"

@implementation AssestCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)didSelect:(id)sender {
//    self.checkButton.selected=!self.checkButton.selected;
    if ([self.delegate respondsToSelector:@selector(didTap:)]) {
        [self.delegate didTap:self];
    }
}
@end
