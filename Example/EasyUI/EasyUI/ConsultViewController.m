//
//  ConsultViewController.m
//  GoodPharmacist
//
//  Created by hexiayu on 14/12/1.
//  Copyright (c) 2014年 成都富顿科技有限公司. All rights reserved.
//

#import "ConsultViewController.h"
#import "MedicalStoreDetailController.h"

#import "NSString+PicPath.h"
#import "NSURL+ImageUrl.h"
#import "UIViewController+Toast.h"
#import "UIImageView+WebCache.h"
#import "UIColor+MyUtils.h"

#import "LocalDataUtil.h"
#import "UploadManager.h"

#import "AppDelegate.h"

#import "BaseUrl.h"
#import "AppClient.h"
#import "RegistClient.h"

#import "LXActionSheet.h"
#import "GPImageHelper.h"
#import "FTBase64.h"

#import "CameraViewController.h"

#import "AssetsViewController.h"
#import "AssetTableViewController.h"
#import "NewEvaController.h"
#import "DrugsOrderDetailViewController.h"

#import "DeliveryInfo.h"
#import "DrogToBy.h"

#import <Masonry/Masonry.h>
#import "UIViewController+Toast.h"
#import "PreImageViewController.h"
#import "UIImage+FixOrientation.h"
#import "UserCenter.h"

static BOOL startLoad=NO;
@interface ConsultViewController ()<CameraViewControllerDelegate,UIAlertViewDelegate,LXActionSheetDelegate,UploadManagerDelegate>
{
    
    NSString *status;
    MedicalStore * _deliveryInfo;
    NSInteger duration;
    NSTimer *durationTimer;
    
    UIView *pushDrugDetailsView;
    UITapGestureRecognizer *removeTapGes;
    
    NSString *displayPushDrugs;
    UILabel *pushDrugLabel;
    
    BOOL isShowDrugs;
    
    BOOL hasPushedToImageView;
    
    BOOL isTalking;
    BOOL consultByVideo;
    BOOL isShowMenu;
    
    NSDate *lastChangeVideoTime;
    
    NSString *currentDrugsStr;//推荐的药片字符串
    
    NSInteger count;
}

@property (nonatomic,strong)Doctor *Docter;
@property BOOL hasOnImageView;//图片是否上传中
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

@property (nonatomic) BOOL isNeedJumpEva;

//actions
- (IBAction)doMute:(id)sender;
- (IBAction)doHangUp:(id)sender;
- (IBAction)changeVideoOrAudio:(id)sender;

@end

@implementation ConsultViewController

-(void)initViews{
    
//    self.BackgroundView.frame=[[UIScreen mainScreen]bounds];
//    self.VideoView.frame=self.BackgroundView.bounds;
//    self.AudioView.frame=self.BackgroundView.bounds;
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
        removeTapGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTap:)];
        
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
    self.doctorBusiLabel.text = LOCALIZATION(@"ConsultDoctorBusiText");
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
    
    if(self.medType == RANDOM_DOCTOR ||self.medType == POINT_DOCTOR){// 医生
        self.longDistanceLayout.priority = UILayoutPriorityDefaultHigh;
        self.nearDistanceLayout.priority = UILayoutPriorityDefaultLow;
        self.pushDrugView.hidden = YES;
    }else if (self.medType == POINT_PHARMACEUTIST ||self.medType == RANDOM_PHARMACEUTIST){
        self.pushDrugView.hidden = YES;
    }
    
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

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 999) {
        [self doHangUp:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isNeedJumpEva = NO;
//    [SystemUtil setDataForKey:CHAT_DATE_KEY withValue:[NSString stringWithFormat:@"%d",CAN_NOT_SHOW]];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // Do any additional setup after loading the view from its nib.
    [self initViews];
    
    [self displayDoctorView];
    
    status = LOCALIZATION(@"CsultInline");
    self.ConsultState.text=status;
    
    isShowMenu=YES;
    isShowDrugs=YES;

    if (!self.shareTalker) {
        
        self.shareTalker=[TalkEngine shareTalkEngine];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(doCallProcess:) name:CALLSTATUS object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(doGetUser:) name:GETTEDDOCTORINFO object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadSomeAssets:) name:@"UploadImage" object:nil];
        
        self.shareTalker.others = self.others;
        
        NSString *tokenId = [UserCenter shareUserCenter].token;
        if(tokenId.length == 0){
            tokenId = @"";
        }
//        if(self.orderId == nil){
//            [self.shareTalker login:self.consultType
//                           originId:self.orignId
//                           strategy:self.medType
//                             doctor:self.doctorModel
//                         CreditCard:self.card
//                        WithChainId:[self.thirdPartInfo ft_stringForKey:@"chainId"]
//                            tokenId:tokenId];
//        }else{
//            //多一个order id
//            [self.shareTalker login:self.consultType
//                            orderId:self.orderId
//                           originId:self.orignId
//                           strategy:self.medType
//                             doctor:self.doctorModel
//                         CreditCard:self.card
//                        WithChainId:[self.thirdPartInfo ft_stringForKey:@"chainId"]
//                            tokenId:tokenId];
//        }
        [self getDoctorCardData];
    }
    if (self.shareTalker.pushDrugs && self.shareTalker.pushDrugs.count > 0) {
        [self.shareTalker.pushDrugs removeAllObjects];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doHangUp:) name:NOT_SUPPORT_MIC_PERISS object:nil];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
     [ [ UIApplication sharedApplication] setIdleTimerDisabled:YES ] ;
    self.navigationController.navigationBarHidden=YES;
    
    self.doctorBusiView.hidden = YES;
    
    [self.PhotoBackgroundView startAnimating];
  
    if (self.shareTalker.status==STATUS_TALKING&&consultByVideo==YES) {
        consultByVideo=NO;
        [self.shareTalker openVideoWithEncoderView:self.SelfPhotoView DecoderView:self.DoctorView];
    }
    if(self.isNeedJumpEva){
        [self JumpNewEvaController];
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    if (self.shareTalker.status==STATUS_TALKING&&self.shareTalker.talkerStatus==TALKER_TYPE_VIDEO) {
        consultByVideo=YES;
        [self.shareTalker closeVideo];
    }
    
     [[ UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
}

#pragma mark - getDoctorCardData update DoctorModel
-(void)getDoctorCardData
{
    NSInteger type = 0;
    NSString *account = @"";
    //获取新的医生资料
    
    if(self.medType == RANDOM_DOCTOR ||self.medType == POINT_DOCTOR){
        type = 0;
        account = self.doctorModel.providerId;
    }else if (self.medType == POINT_PHARMACEUTIST ||self.medType == RANDOM_PHARMACEUTIST){
        type = 1;
        account = self.doctorModel.account;
    }
    
    __weak ConsultViewController *weakSelf = self;
    [RegistClient getDoctorCardWithType:type
                             andAccount:account
                                success:^(Doctor *model) {
                   
                                    weakSelf.doctorModel = model;
                                    [weakSelf displayDoctorView];
                                } failed:nil];
}

#pragma mark - 上传图片

-(void)doUpload:(UITapGestureRecognizer *)ges{//点击上传按钮
   
//    //暂时不支持
//    [[[UIAlertView alloc]initWithTitle:nil message:LOCALIZATION(@"DevelopingModule") delegate:nil cancelButtonTitle:LOCALIZATION(@"OkText") otherButtonTitles: nil] show];
//    return;
//

    //LOCALIZATION(@"LXUploadText")
    LXActionSheet *actionSheet = [[LXActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:LOCALIZATION(@"CancelText") destructiveButtonTitle:nil otherButtonTitles:@[LOCALIZATION(@"PhotoAlbum"), LOCALIZATION(@"TheCamera")]];
    [actionSheet showInView:self.view];

    startLoad = NO;
    

}

-(void)uploadSomeAssets:(NSNotification *)noti{
    NSArray *asserts=noti.object;
    
    self.asserts=asserts;
    
    NSInteger assertCount = [asserts count];
    NSMutableArray *images = [NSMutableArray array];
    
    for (int i = 0; i < assertCount; ++ i) {
        [images addObject:[self getImageFromAsset:asserts[i]]];
    }
    [self updatePic:images updateNumber:(int)assertCount Progress:^(NSProgress *progress,int number) {
        
        NSLog(@"number = %d  progress = %@",number,progress);
        
    } success:^(NSString *path) {
        [self.shareTalker sendImage:path];
    } failed:^(NSError *error) {
        
    }];
//    if ([asserts count] != 0) {
//        UploadManager *upload=[[UploadManager alloc]init];
//        upload.delegate=self;
//        
//        NSMutableDictionary *temp=[[NSMutableDictionary alloc]init];
//        [temp setObject:@"img" forKey:FILEKEY];
//        
//        [temp setObject:([TalkEngine shareTalkEngine].busiId.length == 0 ? @"0" : [TalkEngine shareTalkEngine].busiId) forKey:@"busiId"];
//        [upload uploadFileByHttp:asserts WithUrl:[BaseUrl urlWithTestPath:@"uploadPic"] WithParams:temp WithSingleUpload:YES];
//    }
}

- (void)updatePic:(NSArray <__kindof UIImage *> *)avatars updateNumber:(int)number Progress:(void (^)(NSProgress * progress, int number))progresscall success:(void(^)(NSString * path))successCall failed:(void(^)(NSError *error)) failedCall {
    -- number;
    if (number < 0) {
        self.uploadImage.hidden = NO;
        self.UploadView.userInteractionEnabled = YES;
        self.UploadPercent.hidden = YES;
        self.uploadProgress.hidden = YES;
        [self.uploadProgress updateWithTotalBytes:1 downloadedBytes:0];
        return;
    }
    UIImage *avatar = avatars[number];
    NSData *imageData = UIImageJPEGRepresentation(avatar, 1);
    
    NSMutableDictionary *temp=[[NSMutableDictionary alloc]init];
    [temp ft_setObject:imageData forKey:@"file"];
    [temp ft_setObject:([TalkEngine shareTalkEngine].busiId.length == 0 ? @"0" : [TalkEngine shareTalkEngine].busiId) forKey:@"busiId"];
    [temp ft_setObject:@"jpg" forKey:FILETYPE];
    [temp ft_setObject:@"file" forKey:FILEKEY];
    [temp ft_setObject:@"image/jpeg" forKey:MIMETYPE];
    
    if (self.medType == RANDOM_DOCTOR || self.medType == POINT_DOCTOR) {
        [temp ft_setObject:@"0" forKey:@"type"];
    }else {
        [temp ft_setObject:@"1" forKey:@"type"];
    }
    
    __weak typeof(self)weakSelf = self;
    
//    NSString *strSuccess = [NSString stringWithFormat:LOCALIZATION(@"UploadImageSuccess"),self.asserts.count - number];
//    NSString *strFialed = [NSString stringWithFormat:LOCALIZATION(@"UploadImageFailed"),self.asserts.count - number];
    NSString *countStr = [NSString stringWithFormat:@"%dnum", (int)(self.asserts.count - number)];
    NSString *strSuccess = [NSString stringWithFormat:@"%@ %@", LOCALIZATION(countStr), LOCALIZATION(@"UploadSuccessText")];
    NSString *strFialed = [NSString stringWithFormat:@"%@ %@", LOCALIZATION(countStr), LOCALIZATION(@"UploadFailedText")];
    BaseURLRequest *request = [BaseURLRequest shareNetRequest];
    request.maxDuration = 600;// 600s
    
    self.avatarsCount = avatars.count;
    [request JsonPostSingleFile:[BaseUrl urlWithDoctorPath:@"addBusiPic"] forParams:temp forFile:imageData forProgress:^(NSProgress *progress) {
        [weakSelf uploadingHttpImageAtIndx:avatars.count-number Process:progress.fractionCompleted];
    } successCall:^(NSDictionary *responseObject) {
        NSString *path = [responseObject ft_stringForKey:@"result"];
        successCall(path);
        [weakSelf showToastMessage:strSuccess];
        [weakSelf updatePic:avatars updateNumber:number Progress:^(NSProgress *progress, int number) {
            progresscall(progress,number);
        } success:^(NSString *path) {
            successCall(path);
        } failed:^(NSError *error) {
            failedCall(error);
        }];
    } failedCall:^(NSError *error) {
        failedCall(error);
        [weakSelf showToastMessage:strFialed];
        [weakSelf updatePic:avatars updateNumber:number Progress:^(NSProgress *progress, int number) {
            progresscall(progress,number);
        } success:^(NSString *path) {
            successCall(path);
        } failed:^(NSError *error) {
            failedCall(error);
        }];
    }];
}

//获取image
-(UIImage *)getImageFromAsset:(ALAsset *)assert{
    CGImageRef ref= assert.defaultRepresentation.fullScreenImage;
    
    UIImage *image=[UIImage imageWithCGImage:ref];
    return image;
}

#pragma mark - 上传图片 LXActionSheetDelegate

- (void)didClickOnButtonIndex:(NSInteger *)buttonIndex
{
    if (count == 9) {
        [self showCommonErrorMsg:LOCALIZATION(@"PhotoLimitText") WithFinishBlock:nil];
        return;
    }
    NSLog(@"%d",(int)buttonIndex);
    if ((int)buttonIndex==0) {
        
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        
        if (author!=ALAuthorizationStatusAuthorized&&author!=ALAuthorizationStatusNotDetermined) {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:LOCALIZATION(@"AuthorPhotoText1") delegate:nil cancelButtonTitle:LOCALIZATION(@"OkText") otherButtonTitles:nil];
            [alertView show];
            return;
        }
        
        AssetTableViewController *table=[[AssetTableViewController alloc]initWithNibName:@"AssetTableViewController" bundle:nil];
        table.title=LOCALIZATION(@"PhotoAlbum");
        table.maxSelectCount = 9;
        UINavigationController *imagePickerNav=[[UINavigationController alloc]initWithRootViewController:table];
        //        [imagePickerNav.navigationBar setBarTintColor:NAVBAR_BACKGROUDCOLOR];
        self.photoNav=imagePickerNav;
        
        [self.navigationController presentViewController:imagePickerNav animated:NO completion:^{
            self.hasOnImageView=YES;
        }];
    }
    else if((int)buttonIndex==1){
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus!=AVAuthorizationStatusAuthorized&&authStatus!=AVAuthorizationStatusNotDetermined) {
            [[[UIAlertView alloc]initWithTitle:nil message:LOCALIZATION(@"AuthorPhotoText") delegate:nil cancelButtonTitle:LOCALIZATION(@"OkText") otherButtonTitles: nil]show];
            return;
        }
        
        //        CameraViewController *homeVC=[[CameraViewController alloc]init];
        //        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:homeVC];
        //        nav.navigationBarHidden=YES;
        //        self.photoNav=nav;
        
        CameraViewController *cameraVC = [[CameraViewController alloc]init];
        cameraVC.delegate=self;
        [self presentViewController:cameraVC animated:YES completion:nil];
        
        //        [self.navigationController presentViewController:nav animated:NO completion:^{
        //            self.hasOnImageView=YES;
        //        }];

        
      }
    
}

#pragma mark - <CameraViewControllerDelegate>
- (void)cameraViewController:(CameraViewController *)cameraVC didCaptureImage:(UIImage *)image alasset:(ALAsset *)asset {

    PreImageViewController *pre = [[PreImageViewController alloc] init];
    pre.contentImage = [image fixOrientation];//做了一次镜像
    __weak typeof(self)weakSelf = self;
    __weak typeof(PreImageViewController *)preWeak = pre;
    pre.preImageViewControllerButtonClicked = ^ (UIImage *contentImage, BOOL isSend) {
        if (isSend) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [weakSelf updatePic:@[contentImage] updateNumber:1 Progress:^(NSProgress *progress, int number) {
                } success:^(NSString *path) {
                    [weakSelf.shareTalker sendImage:path];
                } failed:^(NSError *error) {
                }];
            });
          
                [preWeak dismissViewControllerAnimated:NO completion:^{
                    [cameraVC dismissViewControllerAnimated:YES completion:nil];
                }];
           
        }else {
            
                [preWeak  dismissViewControllerAnimated:NO completion:^{
                    self.asserts = @[];
                    [cameraVC flashCamer];
                }];
        }
    };
    [cameraVC presentViewController:pre animated:NO completion:^{
        if(asset){
            self.asserts = @[asset];
        }else{
            self.asserts = @[];
        }
    }];
}

#pragma mark -assert upload delegate
-(void)didStartHttpUploadImage{//开始上传

    if (startLoad==NO) {
        count=0;
        self.hasOnImageView=NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.UploadView.userInteractionEnabled=NO;
            [self showToastMessage:LOCALIZATION(@"PhotoUploadStartText") toastConfig:nil dismissDelay:2 withTapBlock:nil];
            self.uploadImage.image=[UIImage imageNamed:@"btn_102a"];
            self.UploadPercent.hidden=NO;
            self.uploadProgress.hidden=NO;
        });
        startLoad=YES;
    }
   
}

-(void)didEndHttpUploadImageAtIndex:(NSInteger)index SuccessInfo:(NSDictionary *)successInfo{//上传成功single
    
    [[TalkEngine shareTalkEngine]sendImage:[successInfo objectForKey:@"result"]];
    count = count + 1;
    [self showToastMessage:[NSString stringWithFormat:@"第%d张图片上传成功",(int)(index+1)]];
    if (count==self.asserts.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.UploadPercent.hidden=YES;
            self.UploadView.userInteractionEnabled=YES;
            self.UploadPercent.text=LOCALIZATION(@"ImageText");
            [self.uploadProgress updateWithTotalBytes:1 downloadedBytes:0];
            self.uploadProgress.hidden=YES;
            self.uploadImage.image=[UIImage imageNamed:@"btn_105a"];
             count=0;
        });
        startLoad=NO;
    }
}

-(void)failedUploadHttpImageAtIndx:(NSInteger)index{//上传失败single
    count = count <= 0 ? 0 : count-1;
    NSDictionary *topBarConfig = @{ftToastBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.9], ftToastTextColor : [UIColor whiteColor], ftToastTextFont : [UIFont boldSystemFontOfSize:15.0]};
    [self showToastMessage:[NSString stringWithFormat:@"第%d张图片上传失败",(int)(index+1)] toastConfig:topBarConfig dismissDelay:2.0 withTapBlock:nil];
    if (count==self.asserts.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.UploadPercent.hidden=YES;
            self.UploadView.userInteractionEnabled=YES;
            self.UploadPercent.text=@"图片";
            self.uploadProgress.hidden=YES;
            [self.uploadProgress updateWithTotalBytes:1 downloadedBytes:0];
            self.uploadImage.image=[UIImage imageNamed:@"btn_105a"];
            count=0;
        });
        startLoad=NO;
    }
}

- (void)uploadingHttpImageAtIndx:(NSInteger)index Process:(float)process{//单张进度
    dispatch_async(dispatch_get_main_queue(), ^{
        self.uploadImage.hidden = YES;
        self.UploadView.userInteractionEnabled = NO;
        self.UploadPercent.hidden = NO;
        self.uploadProgress.hidden = NO;
        self.UploadPercent.text=[NSString stringWithFormat:@"%d/%d",(int)index,(int)self.avatarsCount];
        [self.uploadProgress updateWithTotalBytes:1 downloadedBytes:process];
    });
}
#pragma mark -action delegate
- (void)didClickOnDestructiveButton
{
    NSLog(@"destructuctive");
}

- (void)didClickOnCancelButton
{
    NSLog(@"cancelButton");
}

#pragma mark - 推药
-(void)doPushDrug:(UITapGestureRecognizer *)ges{//点击推药按钮
//    
//    //暂时不支持
//    [[[UIAlertView alloc]initWithTitle:nil message:@"程序员正在努力的开发中..." delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil] show];
//    return;
    
    if (_pushDrugs.count==0||_pushDrugs==nil) {
        NSDictionary *topBarConfig = @{ftToastBackgroundColor:[UIColor colorWithRed:0.9 green:0 blue:0 alpha:0.9], ftToastTextColor : [UIColor whiteColor], ftToastTextFont : [UIFont boldSystemFontOfSize:15.0]};
        [self showToastMessage:LOCALIZATION(@"NoDrugsText") toastConfig:topBarConfig dismissDelay:5.0 withTapBlock:nil];
        return;
    }
    [self showOrHidePushDrugView:!isShowDrugs];
}
-(void)showMenuView:(BOOL)isShow{
    
    isShowMenu=isShow;
    if (isShowMenu) {
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            self.TopDistance.constant=50;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.MenuBar.alpha=1;
                self.StatusHeaderBar.alpha=1;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
    else{
        int time=0;
        if (isShowDrugs==YES) {
            [self showOrHidePushDrugView:NO];
            time=0.6;
        }
        if(self && [self respondsToSelector:@selector(deleyHidepushDrugView)]){
            [self performSelector:@selector(deleyHidepushDrugView) withObject:nil afterDelay:time];
        }
    }
}
-(void)deleyHidepushDrugView{
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self.MenuBar.alpha=0;
        self.StatusHeaderBar.alpha=0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.TopDistance.constant=0;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }];
}
-(void)showOrHidePushDrugView:(BOOL)isShow{
    isShowDrugs=isShow;
    if (isShow) {
        int time=0;
        if (isShowMenu==NO) {
            [self showMenuView:YES];
            time=0.6;
        }
        if(self && [self respondsToSelector:@selector(showPushDrug)]){
            [self performSelector:@selector(showPushDrug) withObject:nil afterDelay:time];
        }
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            pushDrugDetailsView.alpha=0;
        } completion:^(BOOL finished) {
            [pushDrugDetailsView removeFromSuperview];
            pushDrugDetailsView=nil;
        }];
    }
}
-(void)showPushDrug{
    
    if (!pushDrugDetailsView) {
        pushDrugDetailsView=[[UIView alloc]initWithFrame:self.MenuBar.frame];
        pushDrugDetailsView.frame=CGRectMake(8, self.MenuBar.frame.origin.y-120-8, self.BackgroundView.frame.size.width-16, 120);
        pushDrugDetailsView.backgroundColor=[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3];
        pushDrugDetailsView.layer.borderColor=[[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3]CGColor];
        pushDrugDetailsView.layer.borderWidth=1;
        pushDrugDetailsView.layer.cornerRadius=10;
        pushDrugDetailsView.layer.masksToBounds=YES;
    }
    pushDrugDetailsView.alpha=1;
    [self.BackgroundView addSubview:pushDrugDetailsView];
    if (!pushDrugLabel) {
        pushDrugLabel=[[UILabel alloc]initWithFrame:CGRectMake(8,10, pushDrugDetailsView.frame.size.width-16, pushDrugDetailsView.frame.size.height-40)];
        pushDrugLabel.font=[UIFont systemFontOfSize:13];
        pushDrugLabel.textColor=[UIColor whiteColor];
        pushDrugLabel.numberOfLines=5;
    }
    pushDrugLabel.text=displayPushDrugs;
    [pushDrugDetailsView addSubview:pushDrugLabel];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        pushDrugDetailsView.alpha=1;
        
    } completion:^(BOOL finished) {
        
    }];
}
-(void)doTap:(UITapGestureRecognizer *)ges{
    if (self.shareTalker.status==STATUS_TALKING) {
        [self showMenuView:!isShowMenu];
    }
    
}

-(void)initCanTalkView{
    
    self.MuteButton.hidden=NO;
    self.VideoButton.hidden=NO;
    self.DocterName.hidden=NO;
    self.DoctorTitle.hidden=NO ;
    self.UploadView.hidden=NO;
    
    if(self.medType == RANDOM_DOCTOR ||self.medType == POINT_DOCTOR){// 医生
        self.pushDrugView.hidden=YES;
    }else if (self.medType == POINT_PHARMACEUTIST ||self.medType == RANDOM_PHARMACEUTIST){
         self.pushDrugView.hidden=NO;;
    }
   
}
#pragma mark - 显示医生信息
-(void)displayDoctorView{
    self.DocterName.hidden=NO;
    self.DoctorTitle.hidden=NO;

    if(self.medType == POINT_PHARMACEUTIST ||self.medType == RANDOM_PHARMACEUTIST){
        self.DocterName.text = [self.doctorModel pharmacistNameString];
    }else{
        self.DocterName.text= [self.doctorModel specialNameString];
    }
    self.DocterName.preferredMaxLayoutWidth = 70;
    self.DocterName.numberOfLines = 0;

    self.DoctorTitle.text=self.doctorModel.title;
    [self.DoctorPhoto sd_setImageWithURL:[NSURL BigImageURLWithString:[NSString stringWithPicPath:self.doctorModel.avatar]] placeholderImage:[UIImage imageNamed:@"doctorDefaultIcon"]];
    
    [self.view layoutIfNeeded];
}
-(void)runDurationTimer{
    duration++;
    NSString *second=[NSString stringWithFormat:@"%@",((int)duration/60)<=9?[NSString stringWithFormat:@"0%d",((int)duration/60)]:[NSString stringWithFormat:@"%d",((int)duration/60)]];
    NSString *minute=[NSString stringWithFormat:@"%@",((int)duration%60)<=9?[NSString stringWithFormat:@"0%d",((int)duration%60)]:[NSString stringWithFormat:@"%d",((int)duration%60)]];
    self.ConsultState.text=[NSString stringWithFormat:@"%@:%@",second,minute];
}
-(void)changeToVideo:(BOOL)isVideo{
    if (isVideo) {
        self.VideoView.hidden=NO;
        self.AudioView.hidden=YES;
        self.VideoButton.selected=YES;
        [self showToastMessage:LOCALIZATION(@"OpenVideoText")];
    }
    else {
        self.VideoView.hidden=YES;
        self.AudioView.hidden=NO;
        self.VideoButton.selected=NO;
        [self showToastMessage:LOCALIZATION(@"CloseVideoText")];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    self.navigationController.navigationBarHidden=NO;
}
-(void)doGetUser:(NSNotification *)noti{
    self.Docter=noti.object;
    [self displayDoctorView];
                                                                                         ;
    
}
-(void)doCallProcess:(NSNotification *)noti{
    
    //self.doctorBusiView.hidden = YES;
//    NSString *titleName=[self.Docter.phartype substringFromIndex:(self.Docter.phartype.length-2)];
//    NSString *titleName = self.Docter.title;
    NSDictionary *refDic=noti.object;
    
    int command=[[refDic ft_numberForKey:@"command"]intValue];
    int value=[[refDic ft_numberForKey:@"value"]intValue];
//    NSString *stringValue=[refDic ft_stringForKey:@"stringValue"];
   
//    status=nil;
    if(command == FT_PROTO_MOBILE_LOGIN){
        if(value!=0){
            
            status = LOCALIZATION(@"CsultFailed");
            
            [self hideCallBorad];
            self.NetWorkState.image=[UIImage imageNamed:@"network_close"];
            if(self && [self respondsToSelector:@selector(delayShowStatus:)]){
                [self performSelector:@selector(delayShowStatus:) withObject:nil afterDelay:5];
            }
        }else{
            status = LOCALIZATION(@"CsultInline");
          
        }
    }else if(command==FT_PROTO_HEARTBEAT){
        
    }else if(command==FT_PROTO_LOGOUT){
        
        status = LOCALIZATION(@"CsultEnd");
        [self hideCallBorad];
        if(self && [self respondsToSelector:@selector(delayShowStatus:)]){
             [self performSelector:@selector(delayShowStatus:) withObject:nil afterDelay:0.3];
        }
        
    }else if(command==FT_PROTO_DISCONNECT){
                //在收到以下命令以后会马上收到该命令
        //FT_PROTO_END_BUSINESS
        //FT_PROTO_LEAVE
        //FT_PROTO_MATCHER_OFFLINE
        //FT_PROTO_MATCH_FAILURE
//        status=@"连接断开";
        [self hideCallBorad];
        self.NetWorkState.image=[UIImage imageNamed:@"network_close"];
        if(self && [self respondsToSelector:@selector(delayShowStatus:)]){
            [self performSelector:@selector(delayShowStatus:) withObject:nil afterDelay:5]; //走了第二次
        }
    }else if(command==FT_PROTO_MATCH_WAIT){
        status = [NSString stringWithFormat:LOCALIZATION(@"CsultWait"),value];
    }else if(command==FT_PROTO_MATCH_SUCCESS){
        status = LOCALIZATION(@"CsultWaitAnswer");
    }else if(command==FT_PROTO_MATCH_FAILURE){
        if (self.medType==1||self.medType==3) {
            status =LOCALIZATION(@"CsultDoctorOffline");
        }else if(self.medType==2||self.medType==4){
            status = LOCALIZATION(@"CsultMedtiorOffline");
        }else{
            status= LOCALIZATION(@"CsultBeOffline");
        }
        
    }else if(command==FT_PROTO_AV_START){

        self.Docter=[TalkEngine shareTalkEngine].doctor;
        
        [self.PhotoBackgroundView stopAnimating];
        [self.PhotoBackgroundView startRippleEffec];
        
        [self initCanTalkView];
        
        if ([self getInitConsultType]) {
            [self changeVideoOrNot:YES];
        }

        isTalking=YES;
        status = LOCALIZATION(@"Csulting");
        
        if (durationTimer) {
            [durationTimer invalidate];
            durationTimer=nil;
        }
         durationTimer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(runDurationTimer) userInfo:nil repeats:YES];
        
    }else if(command==FT_PROTO_PUSH_DRUG){

//        NSLog(@TAG"收到推荐药品");
        self.pushDrugs=self.shareTalker.pushDrugs;
        _deliveryInfo=self.shareTalker.deliveryInfo;
    
        NSInteger allCount=self.pushDrugs.count;
        
        NSString *temp=[[NSString alloc]init];
        for (Drug *drug in _pushDrugs) {
            temp=[temp stringByAppendingString:[NSString stringWithFormat:@"%@ (%ld)\n",drug.drugName,(long)drug.drugNum]];
        }
        if ([temp length]>2) {
            displayPushDrugs=[temp substringToIndex:temp.length-1];
        }
        else
            displayPushDrugs=temp;
        
        if (allCount!=0) {
            self.pushDrugsNumber.text=[NSString stringWithFormat:@"%ld",(long)allCount];
            self.pushDrugsNumber.hidden=NO;
        }
        else{
            self.pushDrugsNumber.text=@"";
            self.pushDrugsNumber.hidden=YES;
        }
        if (isShowDrugs) {
            pushDrugLabel.text=displayPushDrugs;
        }
        
        [self showOrHidePushDrugView:YES];
        //    [self pushLocalTip];
    }else if(command==FT_PROTO_END_BUSINESS){
        [self hideCallBorad];

        status = LOCALIZATION(@"CsultThanks");
        
        if(self && [self respondsToSelector:@selector(delayShowStatus:)]){
            [self performSelector:@selector(delayShowStatus:) withObject:nil afterDelay:0.3]; //第一次
        }
        status = LOCALIZATION(@"CsultEnd");
    }else if(command==FT_PROTO_LEAVE){
        
        self.doctorBusiView.hidden = NO;
        if (self.medType==1||self.medType==3) {
            status = LOCALIZATION(@"CsultDoctorOffline");
        }else if(self.medType==2||self.medType==4){
            status = LOCALIZATION(@"CsultMedtiorOffline");
        }else{
            status=LOCALIZATION(@"CsultBeOffline");
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.doctorBusiView.hidden = YES;
        });
    }else if(command==FT_PROTO_MATCHER_OFFLINE){
        
        if (self.medType==1||self.medType==3) {
            status = LOCALIZATION(@"CsultDoctorOffline");
        }else if(self.medType==2||self.medType==4){
            status = LOCALIZATION(@"CsultMedtiorOffline");
        }else{
            status=LOCALIZATION(@"CsultBeOffline");
        }
    }else if(command==CONNECT_STATUS_CONNECT_FAIL){
        status = LOCALIZATION(@"CsultFailed");
        [self hideCallBorad];
        self.NetWorkState.image=[UIImage imageNamed:@"network_close"];
        
        if(self && [self respondsToSelector:@selector(delayShowStatus:)]){
            [self performSelector:@selector(delayShowStatus:) withObject:nil afterDelay:5];
        }
    }else if(command==CONNECT_STATUS_DISCONNECTED){
        status = LOCALIZATION(@"CsultCutDown");
         [self hideCallBorad];
        self.NetWorkState.image=[UIImage imageNamed:@"network_close"];
        if(self && [self respondsToSelector:@selector(delayShowStatus:)]){
            [self performSelector:@selector(delayShowStatus:) withObject:nil afterDelay:5];
        }
    }else if(command==32){ //FT_PROTO_AV_ERROR 医生端接入异常
        self.doctorBusiLabel.text = LOCALIZATION(@"ConsultDoctorLineError");
        self.doctorBusiView.hidden = NO;
        status = LOCALIZATION(@"DoctorError");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideCallBorad];
        });
    }
    
    self.ConsultState.text=status;
    
}

-(void)pushLocalTip{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //设置10秒之后
    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:1];
    if (notification != nil) {
        // 设置推送时间
        notification.fireDate = pushDate;
        // 设置时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        // 设置重复间隔
        notification.repeatInterval = kCFCalendarUnitDay;
        // 推送声音
        notification.soundName = UILocalNotificationDefaultSoundName;
        // 推送内容
        notification.alertBody = [NSString stringWithFormat:@"推荐药品:\n%@",displayPushDrugs];
        //显示在icon上的红色圈中的数子
        notification.applicationIconBadgeNumber += 1;
        //设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *info = [NSDictionary dictionaryWithObject:displayPushDrugs forKey:@"pushDrugs"];
        
        notification.userInfo = info;
        //添加推送到UIApplication
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notification];
        }
}
//延迟显示状态  需要解决
-(void)delayShowStatus:(NSString *)statusStr{
    if (self.hasOnImageView==YES&&self.photoNav!=nil) {
        NSLog(@"need quit photonav firstly,then do hangup");
        [self.photoNav dismissViewControllerAnimated:NO completion:^{
             [self doHangUp:nil];
        }];
    }
    else
        [self doHangUp:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)hideCallBorad{//隐藏控制面板
    
    if (durationTimer) {
        [durationTimer invalidate];
        durationTimer=nil;
    }
    
    
    self.pushDrugView.hidden=YES;
    self.UploadView.hidden=YES;
    self.MuteButton.hidden=YES;
    self.VideoButton.hidden=YES;
    
    
}
- (IBAction)doMute:(id)sender {

    [self.MuteButton setSelected:!self.MuteButton.selected];
    [self.shareTalker setMute:self.MuteButton.selected];
    if (self.MuteButton.selected==YES) {
        [self showToastMessage:LOCALIZATION(@"Cmuted")];
    }
    else{
        [self showToastMessage:LOCALIZATION(@"Cunmute")];
    }
}

#pragma mark - 结束视屏响应按钮
- (IBAction)doHangUp:(id)sender {
    NSLog(@"hang up starting");
    [[ UIApplication sharedApplication] setIdleTimerDisabled:NO ] ;
    
    if (durationTimer) {
        [durationTimer invalidate];
        durationTimer = nil;
    }
    
    if (self.shareTalker.talkerStatus==TALKER_TYPE_VIDEO) {
        [self.shareTalker closeVideo];
    }

    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:CALLSTATUS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UploadImage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOT_SUPPORT_MIC_PERISS object:nil];
    
    //向咨询历史发送咨询成功的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:CONSULT_SUCCESS object:nil];
    
    [self.shareTalker logout];
    
    //如果咨询时间小于等于0
    if (self.shareTalker.talkingTime<=15) {

        [[Locator defaultLocator]stopLocation];
        [TalkEngine deallocTalker];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        if(self.medType == POINT_PHARMACEUTIST ||self.medType == RANDOM_PHARMACEUTIST){
            
#pragma mark - 推药流程
            if ([self.pushDrugs count]==0) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                DrugsOrderDetailViewController *drugsDC = [[DrugsOrderDetailViewController alloc] initWithNibName:@"DrugsOrderDetailViewController" bundle:nil];
                drugsDC.consultId = [self.shareTalker.busiId integerValue];
                drugsDC.isFromConsult = YES;
                drugsDC.drugs = [[NSArray alloc] initWithArray:self.pushDrugs];
                [self.navigationController pushViewController:drugsDC animated:YES];
            }
            //code
            return;
        }
        UIViewController *vc = self.navigationController.viewControllers.lastObject;
        
        self.isNeedJumpEva = YES;
        if(![vc isKindOfClass:[NewEvaController class]] && self.isViewLoaded && self.view.window){ //判断是否正在显示在决定是否跳转
            
            [self JumpNewEvaController];
        }

        
//        if (self.shareTalker.pushDrugs.count!=0) {
//            DrugsOrderDetailViewController *drugVC=[[DrugsOrderDetailViewController alloc]initWithNibName:@"DrugsOrderDetailViewController" bundle:nil];
//            drugVC.consultId= [self.shareTalker.busiId integerValue];
//            [self.navigationController pushViewController:drugVC animated:NO];
//        }
    }
    NSLog(@"hang up ending");
    
}

- (void)JumpNewEvaController
{
    NewEvaController *newEVa= [[NewEvaController alloc] initWithNibName:@"NewEvaController" bundle:nil];
    newEVa.doctorModel = self.doctorModel;
    newEVa.charge = self.providerCharge;
    newEVa.busiId = [TalkEngine shareTalkEngine].busiId;
    newEVa.talkTime = self.shareTalker.talkingTime;
    [self.navigationController pushViewController:newEVa animated:NO];
}

- (IBAction)changeVideoOrAudio:(id)sender {
    
    BOOL isVideo=self.VideoButton.isSelected;
    
    [self changeVideoOrNot:!isVideo];
    
}
-(void)changeVideoOrNot:(BOOL)isVideo{
    if (lastChangeVideoTime) {
        NSTimeInterval Duration=[[NSDate date]timeIntervalSinceDate:lastChangeVideoTime];
        if (fabs(Duration)<=2) {
            return;
        }
    }
    
    lastChangeVideoTime=[NSDate date];
    [self.VideoButton setSelected:isVideo];
    
    [self changeToVideo:isVideo];
    
    if (isVideo) {
        [self.shareTalker openVideoWithEncoderView:self.SelfPhotoView DecoderView:self.DoctorView];
    }
    else
        [self.shareTalker closeVideo];

    [self setConsultType:self.shareTalker.talkerStatus whichNetwork:[[BaseURLRequest shareNetRequest]isConnectNetWork]];
}
//保存咨询状态
-(void)setConsultType:(TALK_TYPE)type whichNetwork:(NetworkStatus)netStatus{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"hasConsulted"];
    if (netStatus==ReachableViaWiFi) {
        if (type==TALKER_TYPE_VIDEO) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"consultWithVideo_wifi"];
        }
        else{
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"consultWithVideo_wifi"];
        }
    }
    else if (netStatus==ReachableViaWWAN){
        if (type==TALKER_TYPE_VIDEO) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"consultWithVideo_3g"];
        }
        else{
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"consultWithVideo_3g"];
        }
    }
}
//获取初时的咨询状态
-(BOOL)getInitConsultType{
    BOOL startWithVideo=NO;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasConsulted"]) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"hasConsulted"];
        
        if ([[BaseURLRequest shareNetRequest]isConnectNetWork]==ReachableViaWiFi) {
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"consultWithVideo_wifi"];
            startWithVideo=NO;
        }else{
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"consultWithVideo_3g"];
            startWithVideo=NO;
        }
    }
    else{
        if ([[BaseURLRequest shareNetRequest]isConnectNetWork]==ReachableViaWiFi) {
            startWithVideo=[[NSUserDefaults standardUserDefaults] boolForKey:@"consultWithVideo_wifi"];
        }
        else{
            startWithVideo=[[NSUserDefaults standardUserDefaults] boolForKey:@"consultWithVideo_3g"];
        }
    }
    return startWithVideo;
}
#pragma mark -Tools
//字典转Json
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(void)dealloc{
    [TalkEngine deallocTalker];
}

@end
