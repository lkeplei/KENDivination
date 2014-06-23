//
//  KENUiViewBase.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-18.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENUiViewBase.h"

@implementation KENUiViewBase

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _viewType = KENViewTypeBase;
    }
    return self;
}

-(void)dealWithAd{
    
}
@end
