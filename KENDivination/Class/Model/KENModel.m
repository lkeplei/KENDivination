//
//  KENModel.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-12.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENModel.h"

@implementation KENModel

+(KENModel*)shareModel{
    static KENModel* sharedModel = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedModel = [[self alloc] init];
    });
    return sharedModel;
};

-(void)changeView:(UIView*)from to:(UIView*)to type:(KENType)type delegate:(UIViewController*)delegate{
    
}
@end
