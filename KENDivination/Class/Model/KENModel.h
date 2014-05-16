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


@property (nonatomic, strong) KENMemory* memoryData;

@end




@interface KENMemory : NSObject

@property (assign) KENType memroyDirection;
@property (nonatomic, strong) NSString* memoryQuestion;

@end
