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

@interface KENViewFactory ()

@property (nonatomic, strong) KENViewHome* homeView;
@property (nonatomic, strong) KENViewSetting* settingView;

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
        default:
            break;
    }
}
@end
