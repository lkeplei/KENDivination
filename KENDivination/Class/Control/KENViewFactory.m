//
//  KENViewFactory.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-12.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewFactory.h"
#import "KENViewHome.h"
#import "KENViewSetting.h"
#import "KENViewMemory.h"
#import "KENViewDirection.h"
#import "KENViewAboutUs.h"
#import "KENViewQuestion.h"
#import "KENViewPaiZhen.h"
#import "KENViewPare.h"
#import "KENViewPareDaziran.h"
#import "KENViewPareTaluo.h"
#import "KENViewPareDaakana.h"
#import "KENViewParePerson.h"
#import "KENViewSubjectSetting.h"

@interface KENViewFactory ()

@property (nonatomic, strong) KENViewHome* homeView;
@property (nonatomic, strong) KENViewSetting* settingView;
@property (nonatomic, strong) KENViewMemory* memoryView;
@property (nonatomic, strong) KENViewDirection* directionView;
@property (nonatomic, strong) KENViewAboutUs* aboutUsView;
@property (nonatomic, strong) KENViewQuestion* questionView;
@property (nonatomic, strong) KENViewPaiZhen* paiZhenView;
@property (nonatomic, strong) KENViewPare *pareView;
@property (nonatomic, strong) KENViewPareTaluo *pareTaluoView;
@property (nonatomic, strong) KENViewPareDaakana *pareDaakanaView;
@property (nonatomic, strong) KENViewPareDaziran *pareDaziranView;
@property (nonatomic, strong) KENViewParePerson *parePersonView;
@property (nonatomic, strong) KENViewSubjectSetting *subjectSettingView;

@end


@implementation KENViewFactory

-(KENViewBase*)getView:(KENViewType)type frame:(CGRect)frame{
    KENViewBase* view = nil;
    switch (type) {
        case KENViewTypeHome:{
            if (_homeView == nil) {
                _homeView = [[KENViewHome alloc] initWithFrame:frame];
            }
            view = _homeView;
        }
            break;
        case KENViewTypeSetting:{
            if (_settingView == nil) {
                _settingView = [[KENViewSetting alloc] initWithFrame:frame];
            }
            view = _settingView;
        }
            break;
        case KENViewTypeSubjectSetting:{
            if (_subjectSettingView == nil) {
                _subjectSettingView = [[KENViewSubjectSetting alloc] initWithFrame:frame];
            }
            view = _subjectSettingView;
        }
            break;
        case KENViewTypeMemory:{
            if (_memoryView == nil) {
                _memoryView = [[KENViewMemory alloc] initWithFrame:frame];
            }
            view = _memoryView;
        }
            break;
        case KENViewTypeQuestion:{
            if (_questionView == nil) {
                _questionView = [[KENViewQuestion alloc] initWithFrame:frame];
            }
            view = _questionView;
        }
            break;
        case KENViewTypeDirection:{
            if (_directionView == nil) {
                _directionView = [[KENViewDirection alloc] initWithFrame:frame];
            }
            view = _directionView;
        }
            break;
        case KENViewTypeAboutUs:{
            if (_aboutUsView == nil) {
                _aboutUsView = [[KENViewAboutUs alloc] initWithFrame:frame];
            }
            view = _aboutUsView;
        }
            break;
        case KENViewTypePaiZhen:{
            if (_paiZhenView == nil) {
                _paiZhenView = [[KENViewPaiZhen alloc] initWithFrame:frame];
            }
            view = _paiZhenView;
        }
            break;
        case KENViewTypePare: {
            if (_pareView == nil) {
                _pareView = [[KENViewPare alloc] initWithFrame:frame];
            }
            view = _pareView;
        }
            break;
        case KENViewTypePareDaziran: {
            if (_pareDaziranView == nil) {
                _pareDaziranView = [[KENViewPareDaziran alloc] initWithFrame:frame];
            }
            view = _pareDaziranView;
        }
            break;
        case KENViewTypePareDaakana: {
            if (_pareDaakanaView == nil) {
                _pareDaakanaView = [[KENViewPareDaakana alloc] initWithFrame:frame];
            }
            view = _pareDaakanaView;
        }
            break;
        case KENViewTypePareTaluo: {
            if (_pareTaluoView == nil) {
                _pareTaluoView = [[KENViewPareTaluo alloc] initWithFrame:frame];
            }
            view = _pareTaluoView;
        }
            break;
        case KENViewTypeParePerson: {
            if (_parePersonView == nil) {
                _parePersonView = [[KENViewParePerson alloc] initWithFrame:frame];
            }
            view = _parePersonView;
        }
            break;
        default:
            break;
    }
    
    return view;
}

-(void)removeView:(KENViewType)type{
    switch (type) {
        case KENViewTypeHome:{
            if (_homeView) {
                [_homeView removeFromSuperview];
                _homeView = nil;
            }
        }
            break;
        case KENViewTypeSetting:{
            if (_settingView) {
                [_settingView removeFromSuperview];
                _settingView = nil;
            }
        }
            break;
        case KENViewTypeSubjectSetting: {
            if (_subjectSettingView) {
                [_subjectSettingView removeFromSuperview];
                _subjectSettingView = nil;
            }
        }
            break;
        case KENViewTypeMemory:{
            if (_memoryView) {
                [_memoryView removeFromSuperview];
                _memoryView = nil;
            }
        }
            break;
        case KENViewTypeQuestion:{
            if (_questionView) {
                [_questionView removeFromSuperview];
                _questionView = nil;
            }
        }
            break;
        case KENViewTypeDirection:{
            if (_directionView) {
                [_directionView removeFromSuperview];
                _directionView = nil;
            }
        }
            break;
        case KENViewTypeAboutUs:{
            if (_aboutUsView) {
                [_aboutUsView removeFromSuperview];
                _aboutUsView = nil;
            }
        }
            break;
        case KENViewTypePaiZhen:{
            if (_paiZhenView) {
                [_paiZhenView removeFromSuperview];
                _paiZhenView = nil;
            }
        }
            break;
        case KENViewTypePare: {
            if (_pareView) {
                [_pareView removeFromSuperview];
                _pareView = nil;
            }
        }
            break;
        case KENViewTypePareDaakana: {
            if (_pareDaakanaView) {
                [_pareDaakanaView removeFromSuperview];
                _pareDaakanaView = nil;
            }
        }
            break;
        case KENViewTypePareDaziran: {
            if (_pareDaziranView) {
                [_pareDaziranView removeFromSuperview];
                _pareDaziranView = nil;
            }
        }
            break;
        case KENViewTypePareTaluo: {
            if (_pareTaluoView) {
                [_pareTaluoView removeFromSuperview];
                _pareTaluoView = nil;
            }
        }
            break;
        case KENViewTypeParePerson: {
            if (_parePersonView) {
                [_parePersonView removeFromSuperview];
                _parePersonView = nil;
            }
        }
            break;
        default:
            break;
    }
}
@end
