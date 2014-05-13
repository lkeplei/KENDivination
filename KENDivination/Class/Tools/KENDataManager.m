//
//  KENDataManager.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-13.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENDataManager.h"

@implementation KENDataManager
static KENDataManager* _shareDataManager = nil;

+(KENDataManager*)shareDataManager{
	if (!_shareDataManager) {
        _shareDataManager = [[self alloc]init];
	}
    
	return _shareDataManager;
};

#pragma mark - user default
+(void)setDataByKey:(id)object forkey:(NSString *)key{
    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:key];
}

+(void)removeDataByKey:(NSString*)key{
    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
}

+(id)getDataByKey:(NSString*)key{
    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}
@end
