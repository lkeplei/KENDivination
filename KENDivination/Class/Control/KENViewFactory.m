//
//  KENViewFactory.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-12.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewFactory.h"
#import "KENViewHome.h"

@interface KENViewFactory ()

@property (nonatomic, strong) KENViewHome* homeView;

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
        default:
            break;
    }
}
@end
