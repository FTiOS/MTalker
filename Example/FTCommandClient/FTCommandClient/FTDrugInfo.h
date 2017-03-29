//
//  FTDrugInfo.h
//  Talkback
//
//  Created by xiachao on 15/6/25.
//
//

#import <Foundation/Foundation.h>
#import "FTJsonSerializable.h"
@interface FTDrugInfo : NSObject <FTJsonSerializable>

@property (nonatomic,strong)NSString *company;//公司
@property (nonatomic,assign)NSInteger consultId;
@property (nonatomic,strong)NSString *dosage;//使用方法
@property (nonatomic,strong)NSString *drugName;//名字
@property (nonatomic,assign)NSInteger drugNum;//数量
@property (nonatomic,assign)NSInteger onsellId;//在售id
@property (nonatomic,strong)NSString *pic;//图片
@property (nonatomic,assign)double price;//价格

@property (nonatomic,strong)NSString *packing;//规格
@property (nonatomic,assign)NSInteger type;//药品类型

@property (nonatomic,assign) NSInteger isTax; //设置药品是否收税 0 否 1 收税

@end
