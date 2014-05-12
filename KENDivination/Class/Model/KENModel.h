//
//  KENModel.h
//  KENDivination
//
//  Created by 刘坤 on 14-5-12.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KENModelDef.h"

@interface KENModel : NSObject

+(KENModel*)shareModel;

//视图切换
-(void)changeView:(UIView*)from to:(UIView*)to type:(KENType)type delegate:(UIViewController*)delegate;

@end
