//
//  KENViewMemory.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-14.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewMemory.h"
#import "KENModel.h"
#import "KENUtils.h"
#import "KENConfig.h"

@interface KENViewMemory ()
@property (nonatomic, strong) UIButton* topRightBtn;
@end

@implementation KENViewMemory

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENViewTypeMemory;
    }
    return self;
}

#pragma mark - others
-(UIImage*)setViewTitleImage{
    return [UIImage imageNamed:@"memory_title.png"];
}

-(void)showView{
    _topRightBtn = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                     image:[UIImage imageNamed:@"memory_btn_ok.png"]
                                  imagesec:[UIImage imageNamed:@"memory_btn_ok_sec.png"]
                                    target:self
                                    action:@selector(topRightBtnClicked:)];
    _topRightBtn.center = CGPointMake(285, KNotificationHeight / 2);
    [self.contentView addSubview:_topRightBtn];
}

#pragma mark - setting btn
-(void)topRightBtnClicked:(UIButton*)button{
    
}

@end
