//
//  UIView+KenView.m
//  achr
//
//  Created by Ken.Liu on 16/3/3.
//  Base on Tof Templates
//  Copyright © 2016年 Hangzhou Ai Cai Network Technology Co., Ltd. All rights reserved.
//

#import "UIView+KenView.h"

#pragma mark -
#pragma mark Category KenView for UIView 
#pragma mark -

static char kDTActionHandlerTapBlockKey;
static char kDTActionHandlerTapGestureKey;
static char kDTActionHandlerLongPressBlockKey;
static char kDTActionHandlerLongPressGestureKey;

@implementation UIView (KenView)
#pragma mark - frame相关属性
- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGSize)size {
    return self.frame.size;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (CGFloat)originX {
    return self.frame.origin.x;
}

- (CGFloat)originY {
    return self.frame.origin.y;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setOrigin:(CGPoint)point {
    [self setFrame:(CGRect){point, self.size}];
}

- (void)setOriginX:(CGFloat)x {
    [self setFrame:(CGRect){x, self.originY, self.size}];
}

- (void)setOriginY:(CGFloat)y {
    [self setFrame:(CGRect){self.originX, y, self.size}];
}

- (void)setSize:(CGSize)size {
    [self setFrame:(CGRect){self.origin, size}];
}

- (void)setWidth:(CGFloat)width {
    [self setFrame:(CGRect){self.origin, width, self.height}];
}

- (void)setHeight:(CGFloat)height {
    [self setFrame:(CGRect){self.origin, self.width, height}];
}

- (void)setCenterX:(CGFloat)x {
    self.center = CGPointMake(x, [self centerY]);
}

- (void)setCenterY:(CGFloat)y {
    self.center = CGPointMake([self centerX], y);
}

@end
