//
//  KENModelDef.h
//  KENDivination
//
//  Created by 刘坤 on 14-5-12.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#ifndef KENDivination_KENModelDef_h
#define KENDivination_KENModelDef_h

typedef enum {
    KENTypeNull = 0,
    
    KENTypeDirectionLove = 10,
    KENTypeDirectionWork,
    KENTypeDirectionMoney,
    KENTypeDirectionRelation,
    KENTypeDirectionHealth,
    KENTypeDirectionMemory,
    
    KENVoiceNull = 100,
    KENVoiceAnJian,
    KENVoiceChouPai,
    KENVoiceFanPai,
    KENVoiceFanPaiHou,
    KENVoiceXiPai,
    KENVoiceZhuanPanTing,
    KENVoiceZhuanPanZhuanDong,
} KENType;

typedef enum {
    KENViewTypeBase = 0,
    KENViewTypeHome,
    KENViewTypeSetting,
    KENViewTypeMemory,
    KENViewTypeQuestion,
    KENViewTypeDirection,
    KENViewTypeAboutUs,
    KENViewTypePaiZhen,
    KENViewTypePare,
    KENViewTypePareTaluo,
    KENViewTypePareDaziran,
    KENViewTypePareDaakana,
    KENViewTypeParePerson,
    KENViewTypeSubjectSetting,
    
    KENUiViewTypeStartXiPai = 100,
    KENUiViewTypeEndXiPai,
    KENUiViewTypeStartQiePai,
    KENUiViewTypeEndQiePai,
    KENUiViewTypeStartChouPai,
    KENUiViewTypeQiePai,
    KENUiViewTypeChouPai,
    KENUiViewTypeStartFanPai,
    KENUiViewTypeFanPai,
    KENUiViewTypePaiZhenDetail,
} KENViewType;

typedef NS_ENUM(NSUInteger, KENSubjectType) {
    KENSubjectTypeAppbg1 = 0,
    KENSubjectTypeAppbg2,
    KENSubjectTypeAppbg3,
    KENSubjectTypeAppbg4,
    KENSubjectTypeAppbg5,
    KENSubjectTypeAppbg6,
    KENSubjectTypeAppbg7,
    
    KENSubjectTypePaibg1,
    KENSubjectTypePaibg2,
    KENSubjectTypePaibg3,
    KENSubjectTypePaibg4,
    KENSubjectTypePaibg5,
    KENSubjectTypePaibg6,
    KENSubjectTypePaibg7,
};
#endif
