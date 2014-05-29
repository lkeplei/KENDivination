//
//  KENUiViewPaiDetailAlert.h
//  KENDivination
//
//  Created by apple on 14-5-27.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KENUiViewPaiDetailAlert : UIView

-(id)initWithFrame:(CGRect)frame animate:(BOOL)animate;

-(void)setKaPaiMessage:(NSInteger)zhenWei;
-(void)animateKaPai:(NSInteger)zhenWei;

@end
