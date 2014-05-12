//
//  KENViewHome.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-12.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewHome.h"

@implementation KENViewHome

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

#pragma mark - others
-(UIImage*)setBackGroundImage{
    return [UIImage imageNamed:@"home_background_image.png"];
}
@end
