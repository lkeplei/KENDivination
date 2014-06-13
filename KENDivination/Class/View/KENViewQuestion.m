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
@property (nonatomic, strong) UIButton* okButton;

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
    return [[KENModel shareModel] getDirectionTitle];
}

-(void)showView{
    //setting btn
    _okButton = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                         image:[UIImage imageNamed:@"app_btn_ok.png"]
                                      imagesec:[UIImage imageNamed:@"app_btn_ok_sec.png"]
                                        target:self
                                        action:@selector(okBtnClicked:)];
    _okButton.center = CGPointMake(285, KNotificationHeight / 2);
    [_okButton setEnabled:NO];
    [self.contentView addSubview:_okButton];
    
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
    _questionTextView.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:_questionTextView];
}

#pragma mark - text field
- (BOOL)textFieldShouldReturn:(UITextField*)textField{
    [_questionTextView resignFirstResponder];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    [_okButton setEnabled:[[textView text] length] > 0];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self okBtnClicked:nil];
        return NO;
    }
    
    if (range.location >= 256){
        return  NO;
    } else {
        return YES;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![_questionTextView isExclusiveTouch]) {
        [_questionTextView resignFirstResponder];
    }
}

#pragma mark - setting btn
-(void)okBtnClicked:(UIButton*)button{
    if ([_questionTextView.text length] > 0) {
        [[KENModel shareModel].memoryData setMemoryQuestion:_questionTextView.text];
        [_questionTextView resignFirstResponder];
        
        [self pushView:[SysDelegate.viewController getView:KENViewTypeDirection] animatedType:KENTypeNull];
    }
}
@end
