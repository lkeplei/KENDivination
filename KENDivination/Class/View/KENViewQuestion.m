//
//  KENViewQuestion.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-16.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewQuestion.h"
#import "KENModel.h"
#import "KENUtils.h"
#import "KENConfig.h"

@interface KENViewQuestion ()

@property (nonatomic, strong) UITextView* questionTextView;

@end

@implementation KENViewQuestion

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENViewTypeQuestion;
    }
    return self;
}

#pragma mark - others
-(UIImage*)setViewTitleImage{
    switch ([[KENModel shareModel].memoryData memroyDirection]) {
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
        default:{
            [KENModel shareModel].memoryData.memroyDirection = KENTypeDirectionLove;
            return [UIImage imageNamed:@"direction_love_title.png"];
        }
            break;
    }
    return nil;
}

-(void)showView{
    //setting btn
    UIButton* setBtn = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                         image:[UIImage imageNamed:@"app_btn_ok.png"]
                                      imagesec:[UIImage imageNamed:@"app_btn_ok_sec.png"]
                                        target:self
                                        action:@selector(okBtnClicked:)];
    setBtn.center = CGPointMake(285, KNotificationHeight / 2);
    [self.contentView addSubview:setBtn];
    
    UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"question_write_down.png"]];
    imgView.center = CGPointMake(160, 79);
    [self.contentView addSubview:imgView];
    
    //textView
    _questionTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 95, 300, 180)];
    _questionTextView.scrollEnabled = YES;
    _questionTextView.textColor = [UIColor whiteColor];
    [_questionTextView setBackgroundColor:[UIColor clearColor]];
    _questionTextView.font = [UIFont fontWithName:KLabelFontArial size:21];
    _questionTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _questionTextView.delegate = self;
    [_questionTextView becomeFirstResponder];           //激活键盘
    [self.contentView addSubview:_questionTextView];
}

#pragma mark - text field
- (BOOL)textFieldShouldReturn:(UITextField*)textField{
    [_questionTextView resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![_questionTextView isExclusiveTouch]) {
        [_questionTextView resignFirstResponder];
    }
}

#pragma mark - setting btn
-(void)okBtnClicked:(UIButton*)button{
    [[KENModel shareModel].memoryData setMemoryQuestion:_questionTextView.text];
    [_questionTextView resignFirstResponder];
    
    [self pushView:[SysDelegate.viewController getView:KENViewTypeDirection] animatedType:KENTypeNull];
}
@end
