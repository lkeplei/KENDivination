//
//  KENViewParePerson.m
//  KENDivination
//
//  Created by 刘坤 on 14-11-11.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewParePerson.h"
#import "KENConfig.h"

@implementation KENViewParePerson
@synthesize personNumber = _personNumber;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENViewTypeParePerson;
    }
    return self;
}

#pragma mark - others
-(UIImage*)setViewTitleImage{
    return [UIImage imageNamed:@"daakana_title.png"];
}

- (void)setPersonNumber:(int)personNumber {
    _personNumber = personNumber;
    
    NSString *person = [NSString stringWithFormat:@"pare_daakana_%d", _personNumber];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:(CGRect){15, KNotificationHeight + 10,
        self.contentView.frame.size.width - 25, self.contentView.frame.size.height - KNotificationHeight * 1.5}]; //初始化大小并自动释放
    textView.textColor = [UIColor whiteColor];//设置textview里面的字体颜色
    textView.font = [UIFont fontWithName:KLabelFontArial size:17.0];//设置字体名字和字体大小
    textView.backgroundColor = [UIColor clearColor];//设置它的背景颜色
    textView.text = MyLocal(person);//设置它显示的内容
    textView.scrollEnabled = YES;//是否可以拖动
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    textView.editable = NO;
    
    [self.contentView addSubview:textView];//加入到整个页面中
}
@end
