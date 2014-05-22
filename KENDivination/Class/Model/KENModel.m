//
//  KENModel.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-12.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENModel.h"
#import "KENConfig.h"
#import "KENDataManager.h"
#import "KENUtils.h"

#import <AudioToolbox/AudioToolbox.h>

@implementation KENModel

+(KENModel*)shareModel{
    static KENModel* sharedModel = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedModel = [[self alloc] init];
    });
    return sharedModel;
};

-(void)initData{
    _memoryData = [[KENMemory alloc] init];
    
    if ([KENDataManager getDataByKey:KUserDefaultSetOpenVoice] == nil) {
        [KENDataManager setDataByKey:[NSNumber numberWithBool:YES] forkey:KUserDefaultSetOpenVoice];
    }
    
    if ([KENDataManager getDataByKey:KUserDefaultJieMi] == nil) {
        [KENDataManager setDataByKey:[NSNumber numberWithBool:NO] forkey:KUserDefaultJieMi];
    }
}

-(void)playVoiceByType:(KENType)type{
    if (![[KENDataManager getDataByKey:KUserDefaultSetOpenVoice] boolValue]) {
        return;
    }
    
    static SystemSoundID shake_sound_male_id = 0;
    
    NSString* name;
    switch (type) {
        case KENVoiceAnJian:
            name = @"an_jian";
            break;
        case KENVoiceChouPai:
            name = @"chou_pai";
            break;
        case KENVoiceFanPai:
            name = @"fan_pai";
            break;
        case KENVoiceFanPaiHou:
            name = @"fan_pai_hou";
            break;
        case KENVoiceXiPai:
            name = @"xi_pai";
            break;
        case KENVoiceZhuanPanTing:
            name = @"zhuan_pan_ting";
            break;
        case KENVoiceZhuanPanZhuanDong:
            name = @"zhuan_pan_zhuan_dong";
            break;
        default:
            name = @"an_jian";
            break;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"mp3"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
        //        AudioServicesPlaySystemSound(shake_sound_male_id);
        //如果无法再下面播放，可以尝试在此播放
    }
    AudioServicesPlaySystemSound(shake_sound_male_id);
    //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}

-(NSArray*)getDirectionPaiZhen{
    NSMutableDictionary* resdic = LOADDIC(@"direction", @"plist");
    switch (_memoryData.memroyDirection) {
        case KENTypeDirectionLove:
            return [resdic objectForKey:@"direction_love"];
            break;
        case KENTypeDirectionWork:
            return [resdic objectForKey:@"direction_work"];
            break;
        case KENTypeDirectionMoney:
            return [resdic objectForKey:@"direction_money"];
            break;
        case KENTypeDirectionRelation:
            return [resdic objectForKey:@"direction_relation"];
            break;
        case KENTypeDirectionHealth:
            return [resdic objectForKey:@"direction_health"];
            break;
        default:{
            _memoryData.memroyDirection = KENTypeDirectionLove;
            return [resdic objectForKey:@"direction_love"];
        }
            break;
    }
    return nil;
}

-(UIImage*)getDirectionTitle{
    switch ([_memoryData memroyDirection]) {
        case KENTypeDirectionLove:
            return [UIImage imageNamed:@"direction_love_title.png"];
            break;
        case KENTypeDirectionWork:
            return [UIImage imageNamed:@"direction_work_title.png"];
            break;
        case KENTypeDirectionMoney:
            return [UIImage imageNamed:@"direction_money_title.png"];
            break;
        case KENTypeDirectionRelation:
            return [UIImage imageNamed:@"direction_relation_title.png"];
            break;
        case KENTypeDirectionHealth:
            return [UIImage imageNamed:@"direction_health_title.png"];
            break;
        default:{
            _memoryData.memroyDirection = KENTypeDirectionLove;
            return [UIImage imageNamed:@"direction_love_title.png"];
        }
            break;
    }
    return nil;
}

-(UIImage*)getPaiZhenTitle{
    return [UIImage imageNamed:[NSString stringWithFormat:@"pai_zhen_title_%02d.png", _memoryData.memoryPaiZhen]];;
}

-(NSInteger)getPaiZhenNumber{
    NSMutableDictionary* resdic = [LOADDIC(@"paizhen", @"plist") objectForKey:[KENUtils getStringByInt:_memoryData.memoryPaiZhen]];
    return [[resdic objectForKey:KDicKeyZhenNumber] intValue];
}

-(void)changeView:(UIView*)from to:(UIView*)to type:(KENType)type delegate:(UIViewController*)delegate{
    
}
@end









@implementation KENMemory

@end
