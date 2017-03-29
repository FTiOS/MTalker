//
//  ConsultViewController.m
//  EasyUI
//
//  Created by 何霞雨 on 2017/3/29.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "ConsultViewController.h"
#import "Masonry.h"

#import "TPImageView.h"
#import "RMDownloadIndicator.h"

#import "NSBundle+EasyUI.h"
#import "UIColor+MyUtils.h"

@interface ConsultViewController (){
    UIView *pushDrugDetailsView;
    UITapGestureRecognizer *removeTapGes;
}


//view
@property (strong, nonatomic) IBOutlet UIView *StatusHeaderBar;
@property (weak, nonatomic) IBOutlet UILabel *DocterName;
@property (weak, nonatomic) IBOutlet UILabel *DoctorTitle;
@property (weak, nonatomic) IBOutlet UILabel *ConsultState;
@property (weak, nonatomic) IBOutlet UIImageView *NetWorkState;

@property (weak, nonatomic) IBOutlet UIImageView *BackgroundView;

@property (strong, nonatomic) IBOutlet UIView *MenuBar;
@property (weak, nonatomic) IBOutlet UIButton *MuteButton;
@property (weak, nonatomic) IBOutlet UIButton *HangUpButton;
@property (weak, nonatomic) IBOutlet UIButton *VideoButton;

@property (strong, nonatomic) IBOutlet UIView *UploadView;
@property (weak, nonatomic) IBOutlet UILabel *UploadState;
@property (weak, nonatomic) IBOutlet UILabel *pushDrugsNumber;
@property (strong, nonatomic) RMDownloadIndicator *uploadProgress;
@property (weak, nonatomic) IBOutlet UIImageView *uploadImage;

@property (strong, nonatomic) IBOutlet UIView *pushDrugView;
@property (weak, nonatomic) IBOutlet UILabel *UploadPercent;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopDistance;


@property (strong, nonatomic) IBOutlet UIView *VideoView;
@property (weak, nonatomic) IBOutlet UIView *DoctorView;
@property (weak, nonatomic) IBOutlet UIView *SelfPhotoView;

@property (strong, nonatomic) IBOutlet UIView *AudioView;
@property (weak, nonatomic) IBOutlet UIImageView *DoctorPhoto;
@property (weak, nonatomic) IBOutlet TPImageView *PhotoBackgroundView;

@property (weak, nonatomic) IBOutlet UIView *menuAudioView;
@property (weak, nonatomic) IBOutlet UIView *menuVideoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uploadLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *longDistanceLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nearDistanceLayout;

@property (nonatomic,weak)UINavigationController *photoNav;

@property (nonatomic,assign) NSInteger avatarsCount;

@property (strong, nonatomic) IBOutlet UIView *doctorBusiView;
@property (weak, nonatomic) IBOutlet UILabel *doctorBusiLabel;



//actions
- (IBAction)doMute:(id)sender;
- (IBAction)doHangUp:(id)sender;
- (IBAction)changeVideoOrAudio:(id)sender;

@end


@implementation ConsultViewController

+(instancetype)instance{
    ConsultViewController *consultVC = [[ConsultViewController alloc]initWithNibName:@"ConsultViewController" bundle:[NSBundle my_easyUIBundle]];
    
    return consultVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setupViews{
    
    [self.BackgroundView addSubview:self.VideoView];
    [self.BackgroundView addSubview:self.AudioView];
    
    [self.BackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.VideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.BackgroundView);
    }];
    
    [self.AudioView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.BackgroundView);
    }];
    
    self.AudioView.hidden=NO;
    self.VideoView.hidden=YES;
    
    self.avatarsCount = 0;
    
    if (!removeTapGes) {
        removeTapGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTapBackground:)];
        
    }
    
    [self.BackgroundView addGestureRecognizer:removeTapGes];
    [self.BackgroundView addSubview:pushDrugDetailsView];
    
    
    [self.MenuBar setFrame:CGRectMake(0, self.BackgroundView.frame.size.height-self.MenuBar.frame.size.height, self.MenuBar.frame.size.width, self.MenuBar.frame.size.height)];
    [self.BackgroundView addSubview:self.MenuBar];
    
    
    [self.MenuBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.BackgroundView.mas_left);
        make.bottom.equalTo(self.BackgroundView.mas_bottom);
        make.right.equalTo(self.BackgroundView.mas_right);
        make.height.equalTo(@146);
    }];
    
    
    [self.StatusHeaderBar setFrame:CGRectMake(0, 0, self.StatusHeaderBar.frame.size.width,  self.StatusHeaderBar.frame.size.height)];
    
    [self.BackgroundView addSubview:self.StatusHeaderBar];
    
    [self.StatusHeaderBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.BackgroundView.mas_left);
        make.top.equalTo(self.BackgroundView.mas_top);
        make.right.equalTo(self.BackgroundView.mas_right);
        make.height.equalTo(@50);
    }];
    
    self.doctorBusiView.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(0/255.0f) blue:(0/255.0f) alpha:0.3];
    self.doctorBusiLabel.text = @"对不起，医生忙碌，请稍后再试。";
    [self.AudioView addSubview:self.doctorBusiView];
    [self.doctorBusiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.AudioView).offset(20);
        make.right.equalTo(self.AudioView).offset(-20);
        make.top.equalTo(self.AudioView).offset(245+15);
        make.height.equalTo(@70);
    }];
    self.doctorBusiView.layer.cornerRadius = 5.0f;
    self.doctorBusiView.layer.masksToBounds = YES;
    
    [self.VideoButton setSelected:NO];
    [self.VideoButton setImage:[UIImage imageNamed:@"btn_104b"] forState:UIControlStateSelected];
    [self.VideoButton setImage:[UIImage imageNamed:@"btn_104a"] forState:UIControlStateNormal];
    self.VideoButton.hidden=YES;
    
    [self.MuteButton setSelected:NO];
    [self.MuteButton setImage:[UIImage imageNamed:@"btn_101b"] forState:UIControlStateSelected];
    [self.MuteButton setImage:[UIImage imageNamed:@"btn_101c"] forState:UIControlStateNormal];
    
    self.MuteButton.hidden=YES;
    
    self.SelfPhotoView.layer.masksToBounds=YES;
    self.SelfPhotoView.layer.borderWidth = 1.0;
    self.SelfPhotoView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    self.DoctorPhoto.layer.borderWidth = 1.0;
    self.DoctorPhoto.layer.borderColor=[[UIColor whiteColor] CGColor];
    
    //if(self.medType == RANDOM_DOCTOR ||self.medType == POINT_DOCTOR){// 医生
        self.longDistanceLayout.priority = UILayoutPriorityDefaultHigh;
        self.nearDistanceLayout.priority = UILayoutPriorityDefaultLow;
        self.pushDrugView.hidden = YES;
   // }else if (self.medType == POINT_PHARMACEUTIST ||self.medType == RANDOM_PHARMACEUTIST){
       // self.pushDrugView.hidden = YES;
  //  }
    
    //显示姓名 职称
    self.DocterName.hidden=YES;
    self.DoctorTitle.hidden=YES;
    
    UITapGestureRecognizer *uploadGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doUpload:)];
    uploadGes.numberOfTapsRequired=1;
    [self.UploadView addGestureRecognizer:uploadGes];
    
    UITapGestureRecognizer *pushDrugsGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doPushDrug:)];
    pushDrugsGes.numberOfTapsRequired=1;
    [self.pushDrugView addGestureRecognizer:pushDrugsGes];
    
    self.UploadView.hidden=YES;
    //    self.pushDrugView.hidden=YES;
    
    
    self.PhotoBackgroundView.layer.cornerRadius = self.PhotoBackgroundView.frame.size.height/2;
    self.PhotoBackgroundView.layer.borderWidth = 1;
    self.PhotoBackgroundView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.9].CGColor;
    self.PhotoBackgroundView.lineWidth=1.5;
    //    self.PhotoBackgroundView.tintColor=NAVBAR_BACKGROUDCOLOR;
    [self.PhotoBackgroundView setRippleEffectWithColor:[UIColor whiteColor]];
    
    
    //    self.uploadProgress
    self.uploadProgress=[[RMDownloadIndicator alloc]initWithFrame:CGRectMake(0, 0, 60, 60) type:kRMClosedIndicator];
    [self.uploadProgress setBackgroundColor:[UIColor clearColor]];
    [self.uploadProgress setFillColor:[UIColor whiteColor]];
    [self.uploadProgress setStrokeColor:[UIColor hexStringToColor:@"aaaaae"]];
    self.uploadProgress.radiusPercent = 0.45;
    [self.UploadView addSubview:self.uploadProgress];
    
    [self.uploadProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.UploadView);
        make.height.equalTo(@60);
        make.width.equalTo(@60);
    }];
    
    [self.uploadProgress loadIndicator];
    
    self.uploadProgress.hidden=YES;
    
    [self.UploadView bringSubviewToFront:self.UploadPercent];
    self.UploadPercent.center=self.UploadView.center;
}

#pragma mark - action
-(void)doTapBackground:(UITapGestureRecognizer *)ges{

}
-(void)doUpload:(UITapGestureRecognizer *)ges{
}
-(void)doPushDrug:(UITapGestureRecognizer *)ges{
    
}
- (IBAction)doMute:(id)sender{
}
- (IBAction)doHangUp:(id)sender{
}
- (IBAction)changeVideoOrAudio:(id)sender{
}

@end
