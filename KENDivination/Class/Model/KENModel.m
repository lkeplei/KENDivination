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
#import "KENMemoryEntity.h"
#import "KENCoreDataManager.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface KENModel ()

@property (strong, nonatomic) AVAudioPlayer *avPlay;

@end

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
    
    if (_avPlay && [_avPlay isPlaying]) {
        [_avPlay stop];
    }
    _avPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:@"mp3"]]
                                                    error:nil];
    [_avPlay play];
}

-(NSArray*)getDirectionPaiZhen{
    NSMutableDictionary* resdic = LOADDIC(@"direction", @"plist");
    switch (_memoryData.memoryDirection) {
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
            _memoryData.memoryDirection = KENTypeDirectionLove;
            return [resdic objectForKey:@"direction_love"];
        }
            break;
    }
    return nil;
}

-(UIImage*)getDirectionTitle{
    switch ([_memoryData memoryDirection]) {
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
            _memoryData.memoryDirection = KENTypeDirectionLove;
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

-(NSDictionary*)getPaiZhenPostions{
    NSMutableDictionary* resdic = [LOADDIC(@"paizhen", @"plist") objectForKey:[KENUtils getStringByInt:_memoryData.memoryPaiZhen]];
    return [resdic objectForKey:KDicKeyZhenPosition];
}

-(NSString*)getPaiZhenDaiBiao:(NSInteger)index{
    NSMutableDictionary* resdic = [LOADDIC(@"paizhen", @"plist") objectForKey:[KENUtils getStringByInt:_memoryData.memoryPaiZhen]];
    return [[resdic objectForKey:KDicKeyZhenPosSense] objectAtIndex:index];
}

-(BOOL)getPaiZhenAuto{
    NSMutableDictionary* resdic = [LOADDIC(@"paizhen", @"plist") objectForKey:[KENUtils getStringByInt:_memoryData.memoryPaiZhen]];
    return [[resdic objectForKey:KDicKeyZhenAuto] boolValue];
}

-(NSArray*)getPaiZHenAutoIndex{
    NSMutableDictionary* resdic = [LOADDIC(@"paizhen", @"plist") objectForKey:[KENUtils getStringByInt:_memoryData.memoryPaiZhen]];
    return [KENUtils getArrayFromStrByCharactersInSet:[resdic objectForKey:KDicKeyZhenAutoIndex] character:@","];
}

-(NSDictionary*)getKaPaiMessage:(NSInteger)index{
    return [LOADDIC(@"paiMessage", @"plist") objectForKey:[KENUtils getStringByInt:index]];
}

-(NSString*)getPaiJieYu:(NSInteger)index{
    NSDictionary* paiAndPaiwei = [_memoryData getPaiAndPaiWei:index];
    NSDictionary* paiMessage = [self getKaPaiMessage:[[paiAndPaiwei objectForKey:KDicPaiIndex] intValue]];
    
    NSDictionary* resdic = nil;
    if ([[paiAndPaiwei objectForKey:KDicPaiWei] boolValue]) {
        resdic = [[paiMessage objectForKey:KDicKeyPaiMeaning] objectForKey:KDicKeyPaiWeiForword];
    } else {
        resdic = [[paiMessage objectForKey:KDicKeyPaiMeaning] objectForKey:KDicKeyPaiWeiReverse];
    }
    
    return [resdic objectForKey:[KENUtils getStringByInt:[_memoryData memoryDirection]]];
}

-(void)setData:(KENMemoryEntity*)memory{
    _memoryData = [[KENMemory alloc] init];
    _memoryData.memoryDirection = [[memory direction] intValue];
    _memoryData.memoryPaiZhen = [[memory paizhen] intValue];
    _memoryData.memoryQuestion = [memory question];
    [_memoryData setPaiMessage:[memory paimessage]];
}

-(void)saveData{
    KENMemoryEntity* entity = (KENMemoryEntity*)[[KENCoreDataManager sharedCoreDataManager] getNewManagedObject:KCoreMemoryEntity];
    [entity setDirection:[NSNumber numberWithInt:_memoryData.memoryDirection]];
    [entity setPaizhen:[NSNumber numberWithInt:_memoryData.memoryPaiZhen]];
    [entity setQuestion:_memoryData.memoryQuestion];
    [entity setPaimessage:_memoryData.getPaiMessageString];
    [entity setUniquetime:[KENUtils getStringFromDate:[NSDate date] format:KUniqueTimeFormat]];

    [[KENCoreDataManager sharedCoreDataManager] saveEntry];
    
    [self clearData];
}

-(void)clearData{
    _memoryData = [[KENMemory alloc] init];
}

-(void)changeView:(UIView*)from to:(UIView*)to type:(KENType)type delegate:(UIViewController*)delegate{
    
}
@end









@implementation KENMemory
-(NSDictionary*)getPaiAndPaiWei:(NSInteger)index{
    if (_memoryPaiMessage == nil) {
        [self getPaiMessage];
    }
    if ([_memoryPaiMessage count] > 0) {
        NSArray* array = [KENUtils getArrayFromStrByCharactersInSet:[_memoryPaiMessage objectAtIndex:index] character:@"-"];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[array objectAtIndex:0] forKey:KDicPaiIndex];
        [dic setObject:[array objectAtIndex:1] forKey:KDicPaiWei];
        return dic;
    } else {
        return nil;
    }
}

-(NSString*)getPaiMessageString{
    NSString* resStr = @"";
    if (_memoryPaiMessage) {
        for (NSString* message in _memoryPaiMessage) {
            if ([resStr length] <= 0) {
                resStr = [resStr stringByAppendingString:message];
            } else {
                resStr = [resStr stringByAppendingFormat:@";%@", message];
            }
        }
    }
    return resStr;
}

-(void)setPaiMessage:(NSString*)string{
    NSArray* array = [KENUtils getArrayFromStrByCharactersInSet:string character:@";"];
    _memoryPaiMessage = [NSMutableArray arrayWithArray:array];
}

-(NSArray*)getPaiMessage{
    if (_memoryPaiMessage == nil) {
        _memoryPaiMessage = [[NSMutableArray alloc] init];
        
        NSMutableArray* array = [[NSMutableArray alloc] init];
        for (int i = 0; i < [[KENModel shareModel] getPaiZhenNumber]; i++) {
            BOOL random = YES;
            while (random) {
                int pai = [KENUtils getRandomNumber:0 to:21];
                int index = -1;
                for (int j = 0; j < [array count]; j++) {
                    if (pai == [[array objectAtIndex:j] intValue]) {
                        index = j;
                        break;
                    }
                }
                if (index == -1) {
                    random = NO;
                    [array addObject:[NSNumber numberWithInt:pai]];
                    [_memoryPaiMessage addObject:[NSString stringWithFormat:@"%d-%d", pai, [KENUtils getRandomNumber:0 to:1]]];
                }
            }
        }
        
        DebugLog(@"_memoryPai = %@", _memoryPaiMessage);
    }
    
    return _memoryPaiMessage;
}
@end
