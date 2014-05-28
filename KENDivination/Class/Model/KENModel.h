//
//  KENModel.h
//  KENDivination
//
//  Created by 刘坤 on 14-5-12.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KENModelDef.h"

@class KENMemory;

@interface KENModel : NSObject

+(KENModel*)shareModel;

//初始数据
-(void)initData;
//播放声音
-(void)playVoiceByType:(KENType)type;
//视图切换
-(void)changeView:(UIView*)from to:(UIView*)to type:(KENType)type delegate:(UIViewController*)delegate;
//获取方向牌阵配置
-(NSArray*)getDirectionPaiZhen;
//获取方向抬头图像
-(UIImage*)getDirectionTitle;
//获取牌阵抬头图像
-(UIImage*)getPaiZhenTitle;
-(NSInteger)getPaiZhenNumber;
-(BOOL)getPaiZhenAuto;
-(NSArray*)getPaiZHenAutoIndex;
-(NSDictionary*)getPaiZhenPostions;
-(NSString*)getPaiZhenDaiBiao:(NSInteger)index;

-(NSDictionary*)getKaPaiMessage:(NSInteger)index;
-(NSString*)getPaiJieYu:(NSInteger)index;

-(void)saveData;
-(void)clearData;

@property (nonatomic, strong) KENMemory* memoryData;

@end




@interface KENMemory : NSObject

-(NSDictionary*)getPaiAndPaiWei:(NSInteger)index;

@property (assign) KENType memroyDirection;
@property (assign) NSInteger memoryPaiZhen;
@property (nonatomic, strong) NSString* memoryQuestion;
@property (nonatomic, strong, getter=getPaiMessage) NSMutableArray* memoryPaiMessage;

@end
