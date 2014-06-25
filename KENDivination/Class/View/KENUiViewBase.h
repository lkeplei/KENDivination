//
//  KENUiViewBase.h
//  KENDivination
//
//  Created by 刘坤 on 14-5-18.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KENViewPaiZhen.h"

@interface KENUiViewBase : UIView

-(void)dealWithAd;
-(void)viewDealWithAd;
-(void)startBaseAnimation;

@property (assign) int animationStep;
@property (assign) KENViewType viewType;
@property (assign) KENViewPaiZhen* delegate;

@end
