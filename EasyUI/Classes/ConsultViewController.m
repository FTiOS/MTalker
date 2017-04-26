//
//  ConsultViewController.m
//  EasyUI
//
//  Created by 何霞雨 on 2017/3/29.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "ConsultViewController.h"
#import "CameraViewController.h"
#import "AssetTableViewController.h"
#import "PreImageViewController.h"

#import <AssetsLibrary/ALAsset.h>

#import "Masonry.h"
#import "Reachability/Reachability.h"
#import "UIImageView+WebCache.h"

#import "FTAppService.h"
#import "FTWaterImageView.h"
#import "CirleProgressView.h"
#import "FTConsultButton.h"
#import "LXActionSheet.h"

#import "NSBundle+EasyUI.h"
#import "UIViewController+Toast.h"
#import "UIImage+FixOrientation.h"

#define kDefault_duration 5
#define kShowTenMinute 600
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

static BOOL startLoad=NO;

typedef NS_ENUM(NSInteger, Consult_status_type) {
    
    consult_do_no_opreation =  0,   //默认 正常状态  咨询中
    consult_net_connect_fail = 1,   //用户网络连接失败
    consult_user_connecting = 2,    //用户正在连接
    consult_termination = 3,        //访问被意外中止
    consult_doctor_busy = 4,        //医生正在业务中
    consult_doctor_offline = 5,     //医生离线
    consult_end = 6,                //结束咨询
    consult_technical_problem = 7,  //技术故障，线下创建用户失败
    consult_wating_doctor = 8,      //等待医生接受
    consult_doctor_refuse = 9,      //医生拒绝接受您的咨询
    consult_doctor_leave = 10, //工作站医生离开
};

@interface ConsultViewController ()<MTTalkerCommandDelegate,LXActionSheetDelegate,CameraViewControllerDelegate>{
    int _duration;
    NSString *displayPushDrugs;
    CGFloat _toolViewHeight;
    BOOL _isShowToolView;
    
    BOOL _isTalking; //咨询过
    BOOL _consultByVideo; //视频咨询
    BOOL _isShowDrugs;
    NSDate *lastChangeVideoTime;
    NSString *currentDrugStr;
    
    BOOL _isPresentVC;   //是否推出 图片选择视图 或者相机视图
    BOOL _sendingImage; //图片是否在上传中
    long inLineNumber; //排队列号数目
    
    NSInteger count; //已上传图片数目
    NSInteger totalCount; //图片总数
}

//提示view
@property (strong, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

//顶部视图
@property (strong, nonatomic) IBOutlet UIView *topStatuView;
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView; //顶部背景

//底部视图
@property (nonatomic) BOOL toolViewIsShow;
@property (strong, nonatomic) IBOutlet UIView *toolView;
@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) CirleProgressView *cirleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ajustPhoneViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *toolImageView; //底部背景

//推药详情视图
@property (nonatomic, strong) UIView *pushDrugDetailsView;
@property (nonatomic, strong) UILabel *pushDrugLabel;

//医生头像视图
@property (strong, nonatomic) IBOutlet UIView *doctorAvatarView;
@property (weak, nonatomic) IBOutlet FTWaterImageView *rippleView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;

@property (weak, nonatomic) IBOutlet UIButton *hangUpButton;

//视频咨询视图
@property (strong, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIView *doctorView;
@property (weak, nonatomic) IBOutlet UIView *mySelfView;

@property (nonatomic, strong) NSTimer *timingTimer; //计时器
@property (nonatomic, strong) dispatch_queue_t tipsQueue;//提示消息展示的消息队列

@property (nonatomic, weak)UINavigationController *photoNav;//相册vc
@property (nonatomic, weak)UIViewController *presentedCameraVC;//相机vc

@end


@implementation ConsultViewController

+(instancetype)instance{
    ConsultViewController *consultVC = [[ConsultViewController alloc]initWithNibName:@"ConsultViewController" bundle:[NSBundle my_easyUIBundle]];
    
    return consultVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubview];
    
    _duration = 0;
    _isTalking = NO;
    
    //排队号数
    inLineNumber = 0;
    totalCount = 0;
    
    [self setConsultStatus:consult_do_no_opreation];
    
    [self createShareTalker];
    [self displayDoctorView];
    [self getDoctorCardData];
    [self hideCallBorad];
    
    [self.view addSubview:self.tipView];
    self.tipView.alpha = 0.0f;
    
    [self handleBackgroundView];
}

- (void)handleBackgroundView
{
    self.statusLabel.text = @"连接中..";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self.rippleView startRippleEffec];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if(self.shareTalker.tkStatus == ST_Talking && self.shareTalker.isVideo == YES){
        _consultByVideo = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.shareTalker startVideoWithEncoderView:self.mySelfView DecoderView:self.doctorView];
        });
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    [self closeShareTalker];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

-(void)dealloc{
    NSLog(@"界面推出，dealloc");
    [self.shareTalker logout];
}

#pragma mark - DataSource
- (void)getDoctorCardData
{
    //获取新的医生资料
    __weak ConsultViewController *weakSelf = self;
    [[FTAppService instance]getDoctorInfo:self.loginInfo.doctor.doctorAccount FinshWithBlock:^(FTDoctor * _Nullable doctor, NSError * _Nullable error) {
        doctor.doctorAccount = [weakSelf.loginInfo.doctor.doctorAccount copy];
        weakSelf.loginInfo.doctor = doctor;
        [weakSelf displayDoctorView];
    }];

}

#pragma mark - init Subviews
- (void)initSubview
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideOrShowToolView)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    //添加头部视图
    NSNumber *topOrBottomViewHeight = @210;
    _toolViewHeight = 210;
    CGFloat avatarOrginY = 144;
    if([UIScreen mainScreen].bounds.size.width <= 320){
        topOrBottomViewHeight = @180;
        avatarOrginY = 114;
        self.ajustPhoneViewHeight.constant = 104;
        _toolViewHeight = 180;
    }
    //医生头像
    self.avatarView.layer.cornerRadius = 60.0f;
    self.avatarView.layer.masksToBounds = YES;
    
    [self.view addSubview:self.doctorAvatarView];
    [self.view addSubview:self.rippleView];
    [self.view addSubview:self.avatarView];
    NSNumber *avatarWidth = [NSNumber numberWithInteger:120];
    [self.doctorAvatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(avatarOrginY);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(avatarWidth);
        make.height.equalTo(avatarWidth);
    }];
    [self.rippleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(avatarOrginY);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(avatarWidth);
        make.height.equalTo(avatarWidth);
    }];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(avatarOrginY);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(avatarWidth);
        make.height.equalTo(avatarWidth);
    }];
    
    [self.view addSubview:self.videoView];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
    }];
    self.videoView.hidden = YES;
    // #434042
    self.mySelfView.layer.borderColor = [UIColor colorWithRed:(67/255.0f) green:(64/255.0f) blue:(66.0f/255.0f) alpha:1.0f].CGColor;
    self.mySelfView.layer.borderWidth = 2.0f;
    
    
    [self.view addSubview:self.topStatuView];
    [self.topStatuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.height.equalTo(topOrBottomViewHeight);
    }];
    
    //添加工具视图
    [self.view addSubview:self.toolView];
    self.toolView.backgroundColor = [UIColor clearColor];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.height.equalTo(topOrBottomViewHeight);
    }];
    
    [self.toolView addSubview:self.menuView];
    self.menuView.backgroundColor = [UIColor clearColor];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolView.mas_top).offset(30);
        make.centerX.equalTo(self.toolView.mas_centerX);
        make.width.equalTo(@300);
        make.height.equalTo(@46);
    }];
    
    [self createMenuView];
    self.toolViewIsShow = YES;
}


- (void)createMenuView
{
    NSArray *iconsSelected = @[@"EasyUI.bundle/consult_muteBtn_selected", @"EasyUI.bundle/consult_pictureBtn_selected", @"EasyUI.bundle/consult_pillBtn_selected", @"EasyUI.bundle/consult_videoBtn_selected"];
    NSArray *iconsNormal = @[@"EasyUI.bundle/consult_muteBtn_normal", @"EasyUI.bundle/consult_pictureBtn_normal", @"EasyUI.bundle/consult_pillBtn_normal", @"EasyUI.bundle/consult_videoBtn_normal"];
    NSArray *desText = @[@"静音", @"图片", @"药品", @"视频"];
    NSArray *seletedText = @[@"静音", @"图片", @"药品",@"视频"];
    
    if(self.needPushDrug){
        for(int i = 0; i < 4; i ++){
            
            UIView *view = (UIView *)[self.menuView viewWithTag:(i+100)];
            view.backgroundColor = [UIColor clearColor];
            
            FTConsultButton *ftConsultBtn = [[FTConsultButton alloc] initWithFrame:CGRectMake(0, 0, 50, 46)];
            ftConsultBtn.ft_selectedImage = [UIImage imageNamed:iconsSelected[i]];
            ftConsultBtn.ft_normalImage = [UIImage imageNamed:iconsNormal[i]];
            ftConsultBtn.descript = desText[i];
            ftConsultBtn.selectedTitle = seletedText[i];
            [ftConsultBtn addTarget:self action:@selector(consultBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [ftConsultBtn setUpSubview];
            ftConsultBtn.tag = (i+1000);
            [view addSubview:ftConsultBtn];
            
            [ftConsultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(view.mas_top);
                make.bottom.equalTo(view.mas_bottom);
                make.centerX.equalTo(view.mas_centerX);
                make.width.equalTo(@50);
            }];
            
            if(i == 2){
                //add NumberView
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
                label.textColor = [UIColor whiteColor];
                label.backgroundColor = [UIColor redColor];
                label.font = [UIFont systemFontOfSize:12.0f];
                label.layer.cornerRadius = 10;
                label.layer.masksToBounds = YES;
                label.textAlignment = NSTextAlignmentCenter;
                [view addSubview:label];
                
                self.numberLabel = label;
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(view.mas_trailing).offset(-10);
                    make.centerY.equalTo(view.mas_top).offset(0);
                    make.width.equalTo(@20);
                    make.height.equalTo(@20);
                }];
                
                [self setNumber:100];
            }
        }
    }else{
        UIView *previousView = nil;
        CGFloat menuViewWidth = 300.0f;
        CGFloat buttonWidth = 50;
        CGFloat leftMargin = 30.f;
        CGFloat marginX ;
        
        //去掉推药按钮
        if(self.needPushPicture){
            marginX = (menuViewWidth - buttonWidth*3 - leftMargin*2.0)*0.5;
        }else{
            marginX = (menuViewWidth - buttonWidth*2 - leftMargin*2.0);
        }
        
        for(int i = 0; i < 4; i ++){
            
            if(i == 2){
                //not pushDrug button
            }else{
                
                if(i == 1 && !self.needPushPicture){
                    //not SendImagebutton
                    continue;
                }
        
                FTConsultButton *ftConsultBtn = [[FTConsultButton alloc] initWithFrame:CGRectMake(0, 0, 50, 46)];
                ftConsultBtn.ft_selectedImage = [UIImage imageNamed:iconsSelected[i]];
                ftConsultBtn.ft_normalImage = [UIImage imageNamed:iconsNormal[i]];
                ftConsultBtn.descript = desText[i];
                ftConsultBtn.selectedTitle = seletedText[i];
                [ftConsultBtn addTarget:self action:@selector(consultBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [ftConsultBtn setUpSubview];
                ftConsultBtn.tag = (i+1000);
                [self.menuView addSubview:ftConsultBtn];
                
                CGFloat btnOrginX = leftMargin;
                if(!previousView){
                    btnOrginX = leftMargin;
                }else{
                    btnOrginX = CGRectGetMaxX(previousView.frame) + marginX;
                }
                
                [ftConsultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.equalTo(self.menuView.mas_top);
                    make.leading.equalTo(self.menuView.mas_leading).offset(btnOrginX);
                    make.bottom.equalTo(self.menuView.mas_bottom);
                    make.width.equalTo(@50);
                }];
                [self.menuView layoutIfNeeded];
                previousView = ftConsultBtn;
            }
        }
    }
    
    FTConsultButton *picBtn = [self.menuView viewWithTag:(1+1000)];
    if(picBtn){
        CirleProgressView *circle = [[CirleProgressView alloc] initWithFrame:CGRectMake(0, 0, picBtn.frame.size.width, picBtn.frame.size.height - 14)];
        [picBtn addSubview:circle];
        self.cirleView = circle;
        self.cirleView.hidden = YES;
    }
}

- (void)showPushDrug
{
    if(displayPushDrugs.length <= 0){
        return ;
    }
    [self.view setNeedsUpdateConstraints];
    [self.view layoutIfNeeded];
    if(!self.pushDrugDetailsView){
        UIView * pushDrugDetailsView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 120)];
        pushDrugDetailsView.backgroundColor=[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3];
        pushDrugDetailsView.layer.borderColor=[[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3]CGColor];
        pushDrugDetailsView.layer.borderWidth=1;
        pushDrugDetailsView.layer.cornerRadius=10;
        pushDrugDetailsView.layer.masksToBounds=YES;
        self.pushDrugDetailsView = pushDrugDetailsView;
    }
    self.pushDrugDetailsView.alpha = 0.0;
    [self.view addSubview:self.pushDrugDetailsView];
    [self.pushDrugDetailsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.toolView.mas_top);
        make.centerX.equalTo(self.toolView.mas_centerX);
        make.leading.equalTo(self.toolView.mas_leading).offset(8);
        make.trailing.equalTo(self.toolView.mas_trailing).offset(-8);
        make.height.equalTo(@120);
    }];
    [self.view setNeedsUpdateConstraints];
    [self.view layoutIfNeeded];
    self.pushDrugDetailsView.alpha = 1;
    if (!self.pushDrugLabel) {
        UILabel *pushDrugLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,20, ScreenWidth-16-16, 120-40)];
        pushDrugLabel.font=[UIFont systemFontOfSize:13];
        pushDrugLabel.textColor=[UIColor whiteColor];
        pushDrugLabel.numberOfLines=5;
        self.pushDrugLabel = pushDrugLabel;
    }
    [self.pushDrugDetailsView addSubview:self.pushDrugLabel];
    [self.pushDrugDetailsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pushDrugDetailsView.mas_top).offset(20);
        make.leading.equalTo(self.pushDrugDetailsView.mas_leading).offset(8);
        make.trailing.equalTo(self.pushDrugDetailsView.mas_trailing).offset(-8);
        make.bottom.equalTo(self.pushDrugDetailsView.mas_bottom).offset(-20);
    }];
    self.pushDrugLabel.text=displayPushDrugs;
    [self.view setNeedsUpdateConstraints];
    [self.view layoutIfNeeded];
    NSLog(@"收到推药信息 : %@", displayPushDrugs);
    _isShowDrugs = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.pushDrugDetailsView.alpha = 1.0f;
    }];
}

-(void)showOrHidePushDrugView:(BOOL)isShow{
    _isShowDrugs = isShow;
    if (isShow) {
        int time=0;
        if (_isShowToolView==NO) {
            [self showToolView];
            time=0.6;
        }
        if(self && [self respondsToSelector:@selector(showPushDrug)]){
            [self performSelector:@selector(showPushDrug) withObject:nil afterDelay:time];
        }
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            self.pushDrugDetailsView.alpha=0;
        } completion:^(BOOL finished) {
            [self.pushDrugDetailsView removeFromSuperview];
            self.pushDrugDetailsView=nil;
        }];
    }
}

#pragma mark - create Component
- (void)createShareTalker
{
    if(!self.shareTalker){
        self.shareTalker=[MTalkerClient shareTalker];
        self.shareTalker.delegate = self;
        
        [self.shareTalker loadSettings:[self settings] finishBlock:^(BOOL loadSuccess) {
            if (loadSuccess) {
                [self.shareTalker login:[self loginInfo]];
            }
        }];
    }
}

- (void)closeShareTalker
{
    if (self.shareTalker.tkStatus==ST_Talking&&self.shareTalker.isVideo == YES) {
        _consultByVideo=YES;
        [self.shareTalker stopVideo];
    }
}

#pragma mark - setting
//调度服务配置
-(MTTalkerSetting *)settings{
    
    MTTalkerSetting *settings = [[MTTalkerSetting alloc]init];
    settings.decodeView = self.doctorView;
    settings.encodeView = self.mySelfView;
    settings.api = [NSString stringWithFormat:@"%@:%d/%@/busi/getDispatchAddr",[FTAppService instance].ip,[FTAppService instance].port,[FTAppService instance].serviceName];
    settings.parmas = nil;
    settings.defaultVideo = YES;
    settings.keepTalkerType = YES;
    
    return settings;
}

#pragma mark - MTTalkerCommandDelegate
//command-命令，instance-传递的参数，info-参数的作用解释说明
-(void)receiveCommand:(CommandType)command withInstance:(NSString *)instance withInfo:(NSString*)info{
    dispatch_async(dispatch_get_main_queue(), ^{
        // Do UI stuff here
        switch (command) {
            case command_login:{
                [self setConsultStatus:consult_user_connecting]; //连接中
            }
                break;
            case command_waiting:{
                //排在第几位
                inLineNumber = [instance integerValue];
                [self setConsultStatus:consult_doctor_busy];
            }
                break;
            case command_match:{
                //等待医生接听
                [self setConsultStatus:consult_wating_doctor];
            }
                break;
            case command_talking:{
                
                [self.rippleView startRippleEffec];
                
                [self showViewWithCanTalkStatus];
                
                if ([self getInitConsultType]) { //根据网段切换视频咨询
                    [self changeVideoOrNot:YES];
                }
                _isTalking=YES;
                [self setConsultStatus:consult_do_no_opreation];
                
                if (self.timingTimer) {
                    [self.timingTimer invalidate];
                    self.timingTimer=nil;
                }
                self.timingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTiming) userInfo:nil repeats:YES];
            }
                break;
            case command_logout:{
                [self hideCallBorad];
                
                LogoutType logoutType = [instance integerValue];
                switch (logoutType) {
                    case logout_normal:{
                        [self setConsultStatus:consult_end];
                        //1.5s后关闭
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self setConsultStatus:consult_end];
                            if(self && [self respondsToSelector:@selector(delayToHangUp)]){
                                [self performSelector:@selector(delayToHangUp) withObject:nil afterDelay:0];
                            }
                        });
                    }
                        break;
                    case logout_disconnect:{
                        //5秒之前处理完其他显示
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self setConsultStatus:consult_net_connect_fail];
                            if(self && [self respondsToSelector:@selector(delayToHangUp)]){
                                [self performSelector:@selector(delayToHangUp) withObject:nil afterDelay:0];
                            }
                        });
                    }
                        break;
                    case logout_matchfail:{
                        [self setConsultStatus:consult_doctor_offline];
                    }
                        break;
                    default:
                        break;
                }
                
            }
                break;
                
            default:
                break;
        }
    }) ;
    
}
//drugs-药品数据，pharmacy-药店数据,postage-邮费
-(void)receiveDrugs:(NSArray<MTDrug *> *)drugs withPharmacy:(MTPharmacy *)pharmacy withPostage:(double)postage{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.pushDrugs = [NSMutableArray arrayWithArray:drugs];
        
        NSInteger allCount=self.pushDrugs.count;
        
        NSString *temp=[[NSString alloc]init];
        for (MTDrug *drug in self.pushDrugs) {
            temp=[temp stringByAppendingString:[NSString stringWithFormat:@"%@  (X%ld)\n",drug.drugName, (long)drug.drugNum]];
        }
        if ([temp length]>2) {
            displayPushDrugs=[temp substringToIndex:temp.length-1];
        }
        else
            displayPushDrugs=temp;
        
        [self setNumber:allCount];
        
        [self showOrHidePushDrugView:YES];
    });
    
}
#pragma mark - 上传多张图片
- (void)uploadSomeAssets:(NSNotification *)noti
{
    NSArray *assets = noti.object;
    self.asserts = assets;
    
    NSInteger assetsCount = [assets count];
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:9];
    for(int i = 0; i < assetsCount; ++i){
        [images addObject:[self getImageFromAsset:assets[i]]];
    }
    
    totalCount = images.count;
    [self showCircleViewWithIndex:0 totalCount:totalCount progress:0.0f];
    
    //相册选择 上传多张图片
    [self updatePic:images updateNumber:(int)assetsCount Progress:^(NSProgress *progress,int number) {
        
        NSLog(@"number = %d  progress = %@",number,progress);
        
    } success:^(NSString *path) {
        [self.shareTalker sendImage:path];
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark - UIResponder
//咨询相关按钮点击
- (void)consultBtnClicked:(UIButton *)sender
{
    
    NSInteger index = sender.tag - 1000;
    switch (index) {
        case 0:{ //mute button
            sender.selected = !sender.selected;
            [self.shareTalker setAvType:(sender.selected?AV_Mute:AV_Normal)];
            if (sender.selected==YES) {
                [self showToastMessage:@"已静音"];
            }else{
                [self showToastMessage:@"取消静音"];
            }
        }
            break;
        case 1:{ //picture button
            
            //上传处方 LOCALIZATION(@"LXUploadText")
            LXActionSheet *actionSheet = [[LXActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相册", @"照相机"]];
            [actionSheet showInView:self.view];
            
            startLoad = NO;
        }
            break;
        case 2:{ //pin button
            if (_pushDrugs.count==0||_pushDrugs==nil) {
                NSDictionary *topBarConfig = @{ftToastBackgroundColor:[UIColor colorWithRed:0.9 green:0 blue:0 alpha:0.9], ftToastTextColor : [UIColor whiteColor], ftToastTextFont : [UIFont boldSystemFontOfSize:15.0]};
                [self showToastMessage:@"没有推荐药品" toastConfig:topBarConfig dismissDelay:5.0 withTapBlock:nil];
                return;
            }
            [self showOrHidePushDrugView:!_isShowDrugs];
        }
            break;
        case 3:{ //video button
            
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if(status == AVAuthorizationStatusNotDetermined){
                // 许可对话没有出现，发起授权许可
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    
                    if (granted) {
                        //第一次用户接受
                    }else{
                        //用户拒绝
                    }
                }];
            }else{
                sender.selected = !sender.selected;
                [self flipAnimation];
                
                if(sender.selected){
                    [self.rippleView stopAnimating];
                    //                [self.rippleView stopRippleEffec];
                }
                [self changeToVideo:sender.selected];
            }
        }
            break;
            
        default:
            break;
    }
}

//挂断操作
- (IBAction)doHangUp:(id)sender {
    
    NSLog(@"hang up starting");
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO ] ;
    
    if(self.timingTimer){
        [self.timingTimer invalidate];
        self.timingTimer = nil;
    }
    [self.rippleView stopAnimating];
    
    if(self.shareTalker.isVideo == YES){
        [self.shareTalker stopVideo];
    }

    [self.shareTalker logout];
    
    //执行业务流程
    if ([self.delegate respondsToSelector:@selector(didHangUpCall:withCallTime:)]) {
        [self.delegate didHangUpCall:self withCallTime:self.shareTalker.talkTime];
    }

    
    NSLog(@"hang up ending");
}

//显示或者隐藏工具栏
- (void)hideOrShowToolView
{
    [self.view layoutIfNeeded];
    
    if(_isTalking){
        __block CGFloat offset = _toolViewHeight;
        self.toolViewIsShow = !self.toolViewIsShow;
        offset = self.toolViewIsShow ? 0 : _toolViewHeight;
        _isShowToolView = offset == 0 ? YES : NO;
        
        if(_isShowToolView){
            [self showOrHidePushDrugView:YES];
        }else{
            [self showOrHidePushDrugView:NO];
        }
        
        [UIView animateWithDuration:0.35 animations:^{
            
            [self.toolView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom).offset(offset);
            }];
            [self.view layoutIfNeeded];
        }];
    }
}
//显示工具栏目
- (void)showToolView
{
    _isShowToolView = YES;
    
    [UIView animateWithDuration:0.35 animations:^{
        
        [self.toolView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
        }];
        [self.view layoutIfNeeded];
    }];
}
//更新计时器
- (void)updateTiming
{
    _duration ++;
    int minute = (int)_duration/60;
    int second = _duration - (int)(minute*60);
    self.statusLabel.text = [NSString stringWithFormat:@"%02d:%02d", minute, second];
}

- (void)startTimingTimer
{
    [self.timingTimer setFireDate:[NSDate distantPast]];
}

- (void)endTimingTimer
{
    //关闭定时器
    [self.timingTimer invalidate];
    self.timingTimer = nil;
}

//翻转动画
- (void)flipAnimation
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:)];
    [UIView commitAnimations];
}

- (void)animationFinished:(id)sender
{
    NSLog(@"filp animation end");
}

//设置推药 数目标签
- (void)setNumber:(long)number
{
    if(number <= 0){
        self.numberLabel.hidden = YES;
    }else{
        self.numberLabel.hidden = NO;
    }
    NSString *str = [NSString stringWithFormat:@"%ld", number];
    if(number > 99){
        str = @"99+";
    }
    self.numberLabel.text = str;
    CGSize maximumLabelSize = CGSizeMake(50, 20);//labelsize的最大值
    self.numberLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize expectSize = [self.numberLabel sizeThatFits:maximumLabelSize];
    if(expectSize.width < 20){
        expectSize.width = 20;
    }else{
        expectSize.width += 10;
    }
    [self.numberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo([NSNumber numberWithInteger:expectSize.width]);
    }];
    [self.numberLabel layoutIfNeeded];
}

//传入消息 tip 为空不显示 提示信息
- (void)showTip:(NSString *)tip duration:(NSTimeInterval)duration
{
    if(!self.tipsQueue){
        self.tipsQueue = dispatch_queue_create("tipsShowQueue", DISPATCH_QUEUE_SERIAL);
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.tipsQueue, ^{
        if(!tip || tip.length <= 0){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(weakSelf.tipView){
                    weakSelf.tipView.alpha = 0.0f;
                }
            });
            
        }else{
            weakSelf.tipLabel.text = tip;
            
            CGSize size = [tip boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 108, MAXFLOAT)
                                            options:NSStringDrawingUsesLineFragmentOrigin|
                           NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                                            context:nil].size;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                weakSelf.tipView.alpha = 1.0f; // alpha 等于 1.0f出现
                
                NSNumber *width = [NSNumber numberWithFloat:([UIScreen mainScreen].bounds.size.width - 80)];
                NSNumber *height = [NSNumber numberWithFloat:(size.height + 35)];
                
                [weakSelf.tipView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(width);
                    make.height.equalTo(height);
                    make.top.equalTo(weakSelf.avatarView.mas_bottom).offset(60);
                    make.centerX.equalTo(weakSelf.avatarView.mas_centerX);
                }];
                [weakSelf.view bringSubviewToFront:weakSelf.tipView];
                
                [weakSelf.view setNeedsUpdateConstraints];
                [weakSelf.view layoutIfNeeded];
                
                //执行消失动画 等待的时间就是tipsView显示的时间
                [UIView animateWithDuration:0.35 delay:duration options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    
                    weakSelf.tipView.alpha = 0.0f;
                } completion:^(BOOL finished) {
                    weakSelf.tipView.alpha = 0.0f;
                }];
            });
        }
    });
}

#pragma mark - 根据状态 显示提示，状态
- (void)setConsultStatus:(Consult_status_type)type
{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (type) {
            case consult_do_no_opreation:{//默认 正常状态
                [self showTip:nil duration:0];
            }
                break;
            case consult_net_connect_fail:{//用户网络连接失败
                [self showTip:@"请检查网络连接" duration:kDefault_duration];
                self.statusLabel.text = @"连接失败";
            }
                break;
            case consult_user_connecting:{//用户正在连接
                [self showTip:nil duration:0];
                self.statusLabel.text =@"连接中...";
            }
                break;
            case consult_termination:{ //访问被意外中止
                [self showTip:@"访问被意外中止" duration:kDefault_duration];
                self.statusLabel.text = @"失去连接";
                [self endTimingTimer];
            }
                break;
            case consult_doctor_busy:{ //医生正在业务中
                [self showTip:@"医生忙碌，请稍后再拨" duration:10];
                self.statusLabel.text = [NSString stringWithFormat:@"在您拨号之前还有%d个用户。", (int)inLineNumber];
            }
                break;
            case consult_doctor_offline:{ //医生离线
                //DoctorOffline
                [self showTip:@"匹配医生失败，请稍后再试" duration:kShowTenMinute];
                self.statusLabel.text = @"访问被意外中止";
                [self endTimingTimer];
            }
                break;
            case consult_end:{//结束咨询
                [self showTip:nil duration:kDefault_duration];
                self.statusLabel.text = @"失去连接";
                [self endTimingTimer];
            }
                break;
            case consult_technical_problem:{//技术故障，线下创建用户失败
                [self showTip:@"线下业务故障，请稍后再试" duration:kShowTenMinute];
                self.statusLabel.text = @"连接失败";
            }
                break;
            case consult_wating_doctor:{//等待医生接受
                [self showTip:nil duration:kDefault_duration];
                self.statusLabel.text = @"等候";
            }
                break;
                
            case consult_doctor_refuse:{ //医生拒绝接受您的电话
                NSLog(@"医生拒绝接受您的电话");
                [self showTip:@"医生拒绝接受您的咨询" duration:5];
                self.statusLabel.text = @"失去连接";
            }
                
            case consult_doctor_leave:{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showTip:@"等待医生的回答，医生可能繁忙，请稍后再试" duration:kDefault_duration];
                    self.statusLabel.text = @"失去连接";
                });
            }
                
            default:
                break;
        }
        
    });
}

- (void)displayDoctorView
{
    self.doctorNameLabel.text = [self.loginInfo.doctor name];
    NSURL *url = [NSURL URLWithString:self.loginInfo.doctor.avatar];
    if (url) {
        [self.avatarView sd_setImageWithURL:url
                           placeholderImage:[UIImage imageNamed:@"doctorDefaultIcon"]
                                    options:SDWebImageRefreshCached];
        [self.view layoutIfNeeded];
    }
}

- (void)hideCallBorad
{
    if(self.timingTimer){
        [self.timingTimer invalidate];
        self.timingTimer = nil;
    }
    for(int i = 0; i < 4; i ++){
        FTConsultButton *button = (FTConsultButton *)[self.menuView viewWithTag:(i+1000)];
        if(button){
            button.hidden = YES;
        }
    }
    self.cirleView.hidden = YES;
    self.numberLabel.hidden = YES;
    self.pushDrugDetailsView.hidden = YES;
}

//显示咨询状态 可操作的视图
- (void)showViewWithCanTalkStatus
{
    for(int i = 0; i < 4; i ++){
        FTConsultButton *button = (FTConsultButton *)[self.menuView viewWithTag:(i+1000)];
        if(button){
            button.hidden = NO;
        }
    }
    
    if(self.pushDrugDetailsView){
        self.pushDrugDetailsView.hidden=NO;
    }
}

//获取初始的咨询状态
-(BOOL)getInitConsultType{
    BOOL startWithVideo=NO;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasConsulted"]) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"hasConsulted"];
        
        if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]==ReachableViaWiFi) {
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"consultWithVideo_wifi"];
            startWithVideo=NO;
        }else{
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"consultWithVideo_3g"];
            startWithVideo=NO;
        }
    }
    else{
        if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]==ReachableViaWiFi) {
            startWithVideo=[[NSUserDefaults standardUserDefaults] boolForKey:@"consultWithVideo_wifi"];
        }
        else{
            startWithVideo=[[NSUserDefaults standardUserDefaults] boolForKey:@"consultWithVideo_3g"];
        }
    }
    return startWithVideo;
}

- (void)changeVideoOrNot:(BOOL)isVideo
{
    if (lastChangeVideoTime) {
        NSTimeInterval Duration=[[NSDate date]timeIntervalSinceDate:lastChangeVideoTime];
        if (fabs(Duration)<=2) {
            return;
        }
    }
    
    lastChangeVideoTime=[NSDate date];
#pragma mark - 修复保存上一次咨询状态 音频或者视频失败问题
    [self changeToVideo:isVideo];
    
    //保存上一次咨询状态 音频或者视频
    [self setConsultType:self.shareTalker.isVideo
            whichNetwork:[[Reachability reachabilityForInternetConnection] currentReachabilityStatus]];
    
    
}
//保存咨询状态
-(void)setConsultType:(BOOL)isVideo whichNetwork:(NetworkStatus)netStatus{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"hasConsulted"];
    if (netStatus==ReachableViaWiFi) {
        if (isVideo) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"consultWithVideo_wifi"];
        }
        else{
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"consultWithVideo_wifi"];
        }
    }
    else if (netStatus==ReachableViaWWAN){
        if (isVideo) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"consultWithVideo_3g"];
        }
        else{
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"consultWithVideo_3g"];
        }
    }
}

-(void)changeToVideo:(BOOL)isVideo{
    
    FTConsultButton *button = (FTConsultButton *)[self.menuView viewWithTag:(3 + 1000)];
    if(button){
        [button setSelected:isVideo];
    }
    if (isVideo) {
        self.videoView.hidden=NO;
        [self.shareTalker startVideoWithEncoderView:self.mySelfView DecoderView:self.doctorView];
        //[self.shareTalker openVideo];
        [self showToastMessage:@"打开视频"];
    }
    else {
        self.videoView.hidden=YES;
        [self.shareTalker stopVideo];
        [self showToastMessage:@"关闭视频"];
    }
    //保存上一次咨询状态 音频或者视频
    [self setConsultType:self.shareTalker.isVideo
            whichNetwork:[[Reachability reachabilityForInternetConnection] currentReachabilityStatus]];
}

#pragma mark - <LXActionSheetDelegate> 图片选择弹窗
- (void)didClickOnButtonIndex:(NSInteger *)buttonIndex
{
    if (count == 9) {
        [self showCommonErrorMsg:@"一次最多只能上传9张图片" WithFinishBlock:nil];
        return;
    }
    NSLog(@"%d",(int)buttonIndex);
    if ((int)buttonIndex==0) {
        
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        
        if (author!=ALAuthorizationStatusAuthorized&&author!=ALAuthorizationStatusNotDetermined) {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"我们需要访问您的相册。\n请启用相册,设置/隐私/相册！" delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
            [alertView show];
            return;
        }
        
        AssetTableViewController *table=[[AssetTableViewController alloc]initWithNibName:@"AssetTableViewController" bundle:[NSBundle my_easyUIBundle]];
        table.title=@"相册";
        table.maxSelectCount = 9;
        UINavigationController *imagePickerNav=[[UINavigationController alloc]initWithRootViewController:table];
        self.photoNav=imagePickerNav;
        
        [self.navigationController presentViewController:imagePickerNav animated:NO completion:^{
            _isPresentVC = YES;
        }];
    }
    else if((int)buttonIndex==1){
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus!=AVAuthorizationStatusAuthorized&&authStatus!=AVAuthorizationStatusNotDetermined) {
            [[[UIAlertView alloc]initWithTitle:nil message:@"我们需要访问您的相机。\n请启用相机,设置/隐私/相机！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
            return;
        }
        CameraViewController *cameraVC = [[CameraViewController alloc]init];
        cameraVC.delegate=self;
        self.presentedCameraVC = cameraVC;
        
        [self presentViewController:cameraVC animated:YES completion:^{
            _isPresentVC = YES;
        }];
    }
    
}

#pragma mark - <CameraViewControllerDelegate>
- (void)cameraViewController:(CameraViewController *)cameraVC didCaptureImage:(UIImage *)image alasset:(ALAsset *)asset {
    
    PreImageViewController *pre = [[PreImageViewController alloc] initWithNibName:@"PreImageViewController" bundle:[NSBundle my_easyUIBundle]];
    pre.contentImage = [image fixOrientation];//做了一次镜像
    __weak typeof(self)weakSelf = self;
    __weak typeof(PreImageViewController *)preWeak = pre;
    pre.preImageViewControllerButtonClicked = ^ (UIImage *contentImage, BOOL isSend) {
        if (isSend) {
            totalCount = 1;
            [self showCircleViewWithIndex:0 totalCount:totalCount progress:0.0f];
            
            //相机拍照 单张上传
            [weakSelf updatePic:@[contentImage] updateNumber:1 Progress:^(NSProgress *progress, int number) {
            } success:^(NSString *path) {
                [weakSelf.shareTalker sendImage:path];
            } failed:^(NSError *error) {
            }];
            
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

#pragma mark - 上传图片网络请求 updatePic
- (void)updatePic:(NSArray <__kindof UIImage *> *)avatars updateNumber:(int)number Progress:(void (^)(NSProgress * progress, int number))progresscall success:(void(^)(NSString * path))successCall failed:(void(^)(NSError *error)) failedCall {
    if ([self.delegate respondsToSelector:@selector(updatePic:updateNumber:Progress:success:failed:)]) {
        [self.delegate updatePic:avatars updateNumber:number Progress:progresscall success:successCall failed:failedCall];
    }
}

- (void)resetCircleView
{
    self.cirleView.hidden = YES;
    [self.cirleView drawProgress:0.0];
    self.cirleView.totalCount = 0;
    self.cirleView.currentCount = 0;
    count = 0;
    //使得按钮可以再次点击
    FTConsultButton *picBtn = (FTConsultButton *)[self.menuView viewWithTag:(1+1000)];
    if(picBtn){
        picBtn.imageButton.hidden = NO;
        picBtn.userInteractionEnabled = YES;
        picBtn.selected = NO;
    }
}

- (void)showCircleViewWithIndex:(NSInteger)index totalCount:(NSInteger)total progress:(float)progress
{
    if(self.cirleView.hidden){
        self.cirleView.hidden = NO;
    }
    self.cirleView.totalCount = totalCount;
    self.cirleView.currentCount = index;
    [self.cirleView drawProgress:progress]; //0-1.0f
    [self.cirleView updateCurrentCount:index];
    [self.menuView bringSubviewToFront:self.cirleView];
    //使得按钮可以再次点击
    FTConsultButton *picBtn = (FTConsultButton *)[self.menuView viewWithTag:(1+1000)];
    if(picBtn){
        picBtn.imageButton.hidden = YES;
        picBtn.userInteractionEnabled = NO;
        picBtn.selected = YES;
    }
}

- (void)delayToHangUp
{
    if(_isPresentVC == YES && self.photoNav != nil){
        NSLog(@"need quit photonav firstly,then do hangup");
        [self.photoNav dismissViewControllerAnimated:NO completion:^{
            [self doHangUp:nil];
        }];
    }else if (_isPresentVC == YES && self.presentedCameraVC != nil){
        NSLog(@"need quit CamreViewController firstly,then do hangup");
        [self.presentedCameraVC dismissViewControllerAnimated:NO completion:^{
            [self doHangUp:nil];
        }];
    }else
        [self doHangUp:nil];
}

#pragma mark - getter
//获取image
-(UIImage *)getImageFromAsset:(ALAsset *)assert{
    CGImageRef ref= assert.defaultRepresentation.fullScreenImage;
    
    UIImage *image=[UIImage imageWithCGImage:ref];
    return image;
}
@end
