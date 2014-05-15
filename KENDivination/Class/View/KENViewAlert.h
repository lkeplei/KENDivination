//
//  KENViewAlert.h
//  KENDivination
//
//  Created by 刘坤 on 14-5-15.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AlertViewBlock)(int);

@interface KENViewAlert : UIView

-(void)show;
-(id)initWithMessage:(UIImage*)img btnArray:(NSArray*)array;

@property(nonatomic, copy) AlertViewBlock alertBlock;

@end
