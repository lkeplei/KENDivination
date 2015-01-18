//
//  KENViewFactory.h
//  KENDivination
//
//  Created by 刘坤 on 14-5-12.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KENModelDef.h"
#import "KENViewBase.h"

@interface KENViewFactory : NSObject

-(KENViewBase*)getView:(KENViewType)type frame:(CGRect)frame;
-(void)removeView:(KENViewType)type;

- (void)setAppBg;

@end
