//
//  KENDataManager.h
//  KENDivination
//
//  Created by 刘坤 on 14-5-13.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KENDataManager : NSObject

+(void)setDataByKey:(id)object forkey:(NSString*)key;
+(void)removeDataByKey:(NSString*)key;
+(id)getDataByKey:(NSString*)key;

@end
