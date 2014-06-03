//
//  KENUiViewPaiDetailAlert.h
//  KENDivination
//
//  Created by apple on 14-5-27.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AlertDetailBlock)();

@interface KENUiViewPaiDetailAlert : UIView

-(id)initWithFrame:(CGRect)frame animate:(BOOL)animate;

-(void)setKaPaiMessage:(NSInteger)zhenWei;
-(void)animateKaPai:(NSInteger)zhenWei center:(CGPoint)center;

@property(nonatomic, copy) AlertDetailBlock alertBlock;

@end
