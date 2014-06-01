//
//  KENMemoryEntity.h
//  KENDivination
//
//  Created by 刘坤 on 14-6-1.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface KENMemoryEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * direction;
@property (nonatomic, retain) NSString * paimessage;
@property (nonatomic, retain) NSNumber * paizhen;
@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) NSString * uniquetime;

@end
