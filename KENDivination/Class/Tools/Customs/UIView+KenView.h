//
//  UIView+KenView.h
//  achr
//
//  Created by Ken.Liu on 16/3/3.
//  Base on Tof Templates
//  Copyright © 2016年 Hangzhou Ai Cai Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -
#pragma mark Category KenView for UIView 
#pragma mark -

@interface UIView (KenView)
#pragma mark - frame相关属性
- (CGFloat)height;
- (CGFloat)width;
- (CGSize)size;
- (CGPoint)origin;
- (CGFloat)originX;
- (CGFloat)originY;
- (CGFloat)centerX;
- (CGFloat)centerY;
- (void)setOrigin:(CGPoint)point;
- (void)setOriginX:(CGFloat)x;
- (void)setOriginY:(CGFloat)y;
- (void)setSize:(CGSize)size;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setCenterX:(CGFloat)x;
- (void)setCenterY:(CGFloat)y;

@end
