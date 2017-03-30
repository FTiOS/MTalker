//
//  MTViewController.h
//  MTalker
//
//  Created by rrun on 03/21/2017.
//  Copyright (c) 2017 rrun. All rights reserved.
//

@import UIKit;

@interface MTViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *decodeView;
@property (weak, nonatomic) IBOutlet UIView *encodeView;


- (IBAction)mute:(id)sender;
- (IBAction)picture:(id)sender;
- (IBAction)video:(id)sender;
- (IBAction)start:(id)sender;
- (IBAction)end:(id)sender;

@end
