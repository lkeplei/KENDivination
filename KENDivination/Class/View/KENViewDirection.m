//
//  KENViewDirection.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-14.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewDirection.h"
#import "KENModel.h"

@implementation KENViewDirection

@synthesize viewDirection = _viewDirection;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENViewTypeDirection;
    }
    return self;
}

#pragma mark - others
-(UIImage*)setViewTitleImage{
    switch (_viewDirection) {
        case KENTypeDirectionLove:
            return [UIImage imageNamed:@"direction_love_title.png"];
            break;
        case KENTypeDirectionWork:
            return [UIImage imageNamed:@"direction_work_title.png"];
            break;
        case KENTypeDirectionMoney:
            return [UIImage imageNamed:@"direction_money_title.png"];
            break;
        case KENTypeDirectionRelation:
            return [UIImage imageNamed:@"direction_relation_title.png"];
            break;
        case KENTypeDirectionHealth:
            return [UIImage imageNamed:@"direction_health_title.png"];
            break;
        default:
            break;
    }
    return nil;
}

-(void)showView{
    
}

@end
