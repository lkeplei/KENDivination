//
//  KENViewPareTaluo.m
//  KENDivination
//
//  Created by 刘坤 on 14-11-10.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewPareTaluo.h"

@implementation KENViewPareTaluo

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENViewTypePareTaluo;
    }
    return self;
}

#pragma mark - others
-(UIImage*)setViewTitleImage{
    return [UIImage imageNamed:@"taluo_title.png"];
}

-(void)showView{

}

@end
