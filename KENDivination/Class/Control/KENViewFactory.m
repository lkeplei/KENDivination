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

@interface KENViewFactory ()

@property (nonatomic, strong) KENViewHome* homeView;
@property (nonatomic, strong) KENViewSetting* settingView;
@property (nonatomic, strong) KENViewMemory* memoryView;
@property (nonatomic, strong) KENViewDirection* directionView;

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
        case KENViewTypeMemory:{
            if (_memoryView == nil) {
                _memoryView = [[KENViewMemory alloc] initWithFrame:frame];
            }
            view = _memoryView;
        }
            break;
        case KENViewTypeDirection:{
            if (_directionView == nil) {
                _directionView = [[KENViewDirection alloc] initWithFrame:frame];
            }
            view = _directionView;
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
        case KENViewTypeMemory:{
            if (_memoryView) {
                [_memoryView removeFromSuperview];
                _memoryView = nil;
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
        default:
            break;
    }
}
@end
