//
//  KENViewDirection.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-14.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewDirection.h"
#import "KENModel.h"
#import "KENConfig.h"
#import "KENUtils.h"
#import "KENDataManager.h"

#define KDirectionBtnTagBase        (400)

@interface KENViewDirection ()

@property (nonatomic, strong) NSArray* resourceArray;

@end

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
    return [[KENModel shareModel] getDirectionTitle];
}

-(void)showView{
    _resourceArray = [[KENModel shareModel] getDirectionPaiZhen];
    
    for (int i = 0; i < [_resourceArray count]; i++) {
        NSDictionary* res = [_resourceArray objectAtIndex:i];
        UIImage* img = nil;
        UIImage* imgSec = nil;
        
        if (![[KENDataManager getDataByKey:KUserDefaultJieMi] boolValue] && [[res objectForKey:KDicKeyJiaMi] boolValue] && 0) {
            img = [UIImage imageNamed:@"direction_paizhen_jiami.png"];
            imgSec = [UIImage imageNamed:@"direction_paizhen_jiami.png"];
        } else {
            img = [UIImage imageNamed:[res objectForKey:KDicKeyImg]];
            imgSec = [UIImage imageNamed:[res objectForKey:KDicKeyImgSec]];
        }
        
        UIButton* pingBtn = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                              image:img
                                           imagesec:imgSec
                                             target:self
                                             action:@selector(btnArrayClicked:)];
        pingBtn.center = CGPointMake(60 + 100 * (i % 3), 131 + 110 * (i / 3));
        pingBtn.tag = KDirectionBtnTagBase + i;
        [self.contentView addSubview:pingBtn];
    }
}

#pragma mark - btn clicked
-(void)btnArrayClicked:(UIButton*)button{
    NSInteger paizhen = [[[_resourceArray objectAtIndex:button.tag - KDirectionBtnTagBase] objectForKey:KDicKeyPaiZhen] intValue];
    [[[KENModel shareModel] memoryData] setMemoryPaiZhen:paizhen];
    [self pushView:[SysDelegate.viewController getView:KENViewTypePaiZhen] animatedType:KENTypeNull];
}
@end
