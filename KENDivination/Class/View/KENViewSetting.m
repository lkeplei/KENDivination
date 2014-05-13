//
//  KENViewSetting.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-13.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewSetting.h"

@implementation KENViewSetting

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENViewTypeSetting;
    }
    return self;
}

#pragma mark - others
-(UIImage*)setViewTitleImage{
    return [UIImage imageNamed:@"setting_title.png"];
}

-(void)showView{

}

@end
