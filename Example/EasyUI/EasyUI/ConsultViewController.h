//
//  ConsultViewController.h
//  GoodPharmacist
//
//  Created by hexiayu on 14/12/1.
//  Copyright (c) 2014年 成都富顿科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "DEInfiniteTileMarqueeView.h"
//#import "RMDownloadIndicator.h"

//#import "TPImageView.h"
#import "MTalkerClient.h"

#import "Doctor.h"
#import "CreditCard.h"

#import "DoctorDetailViewController.h"

@interface ConsultViewController : UIViewController

@property (nonatomic)BOOL isPoint;//是否为指定医生或药剂师

@property (nonatomic)STRATEGY_TYPE medType;
@property(nonatomic,weak)TalkEngine *shareTalker;
@property (nonatomic,strong)NSString *medAccount;
@property (nonatomic)Consulter_Type consultType;
@property (nonatomic)NSInteger orignId;

@property (nonatomic, strong) NSString *orderId;

@property(nonatomic,assign)ProviderCharge providerCharge;//医生对应的服务价格

@property (nonatomic,strong)NSString *others;//其它参数，传入给咨询调度

@property (nonatomic,strong)NSMutableArray *pushDrugs;
@property (nonatomic)BOOL fromThirdPart;
@property (nonatomic,strong)NSDictionary *thirdPartInfo;
@property (nonatomic,strong)Doctor *doctorModel;
@property (nonatomic,strong)CreditCard *card;//信用卡信息

@property(nonatomic,strong)NSArray *asserts;

@end
