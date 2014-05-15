//
//  KENViewAboutUs.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-15.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewAboutUs.h"
#import "KENUtils.h"
#import "KENViewAlert.h"
#import "KENConfig.h"

@implementation KENViewAboutUs

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENViewTypeAboutUs;
    }
    return self;
}

#pragma mark - others
-(UIImage*)setViewTitleImage{
    return [UIImage imageNamed:@"setting_title.png"];
}

-(void)showView{
    UIButton* aboutBtn = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                          image:[UIImage imageNamed:@"about_us_bg.png"]
                                       imagesec:[UIImage imageNamed:@"about_us_bg.png"]
                                         target:self
                                         action:@selector(aboutBtnClicked:)];
    aboutBtn.center = CGPointMake(160, 240);
    [self.contentView addSubview:aboutBtn];
}

#pragma mark - setting btn
-(void)aboutBtnClicked:(UIButton*)button{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[UIImage imageNamed:@"button_close.png"] forKey:KDicKeyImg];
    [dic setObject:[UIImage imageNamed:@"button_close_sec.png"] forKey:KDicKeyImgSec];
    
    KENViewAlert* alert = [[KENViewAlert alloc] initWithMessage:[UIImage imageNamed:@"about_us_alert.png"]
                                                       btnArray:[[NSArray alloc] initWithObjects:dic, nil]];
    [alert show];
    
    alert.alertBlock = ^(int index){
        
    };
    
    
    
//    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:[UIImage imageNamed:@"button_cancel.png"] forKey:KDicKeyImg];
//    [dic setObject:[UIImage imageNamed:@"button_cancel_sec.png"] forKey:KDicKeyImgSec];
//    
//    NSMutableDictionary* dic1 = [[NSMutableDictionary alloc] init];
//    [dic1 setObject:[UIImage imageNamed:@"button_confirm.png"] forKey:KDicKeyImg];
//    [dic1 setObject:[UIImage imageNamed:@"button_confirm_sec.png"] forKey:KDicKeyImgSec];
//    
//    KENViewAlert* alert = [[KENViewAlert alloc] initWithMessage:[UIImage imageNamed:@"about_us_alert.png"]
//                                                       btnArray:[[NSArray alloc] initWithObjects:dic, dic1, nil]];
//    [alert show];
//    
//    alert.alertBlock = ^(int index){
//        DebugLog(@"index = %d", index);
//    };
}
@end
