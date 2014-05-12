//
//  KENUtils.m
//  KENDivination
//
//  Created by ken on 13-4-16.
//  Copyright (c) 2013年 ken. All rights reserved.
//

#import "KENUtils.h"
#import "KNEConfig.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#define KShowWeakBtnHeight          (40)
#define KShowWeakRemind             (1000)

@implementation KENUtils

static KENUtils* _shareUtils = nil;

+(KENUtils*)shareUtils{
	if (!_shareUtils) {
        _shareUtils = [[self alloc]init];
	}
    
	return _shareUtils;
};

#pragma mark - static
+(UIButton*)buttonWithImg:(NSString*)buttonText off:(int)off zoomIn:(BOOL)zoomIn image:(UIImage*)image
                 imagesec:(UIImage*)imagesec target:(id)target action:(SEL)action{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    button.titleLabel.textColor = [UIColor whiteColor];
//    button.titleLabel.shadowOffset = CGSizeMake(0,-1);
//    button.titleLabel.shadowColor = [UIColor darkGrayColor];
    
    if (buttonText != nil) {
        NSString* text = [NSString stringWithFormat:@"%@", buttonText];
        if (off > 0) {
            for (int i = 0; i < off; i++) {
                text = [NSString stringWithFormat:@" %@", text];
            }
        }
        [button setTitle:text forState:UIControlStateNormal];
        
        if (image == nil && imagesec == nil) {
            float width = [self getFontSize:buttonText font:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]].width;
            float height = [self getFontSize:buttonText font:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]].height;
            
            button.frame = CGRectMake(0.0, 0.0, width, height);
        }
    }
    
    if (zoomIn) {
        [button setImage:image forState:UIControlStateNormal];
        if (imagesec != nil) {
            [button setImage:imagesec forState:UIControlStateHighlighted];
            [button setImage:imagesec forState:UIControlStateSelected];
        }
    } else {
        [button setBackgroundImage:image forState:UIControlStateNormal];
        if (imagesec != nil) {
            [button setBackgroundImage:imagesec forState:UIControlStateHighlighted];
            [button setBackgroundImage:imagesec forState:UIControlStateSelected];
        }
    }

    button.adjustsImageWhenHighlighted = NO;
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+(UILabel*)labelWithTxt:(NSString *)buttonText frame:(CGRect)frame
                   font:(UIFont*)font color:(UIColor*)color{
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.text = buttonText;
    label.font = font;
    label.textAlignment = KTextAlignmentCenter;   //first deprecated in IOS 6.0
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}

+(UITextField*)textFieldInit:(CGRect)frame color:(UIColor*)color bgcolor:(UIColor*)bgcolor
                        secu:(BOOL)secu font:(UIFont*)font text:(NSString*)text{
    UITextField* textField = [[UITextField alloc] initWithFrame:frame];
    textField.textColor = color;
    textField.font = font;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.backgroundColor = bgcolor;
    textField.placeholder = text;
    [textField setSecureTextEntry:secu];
    textField.returnKeyType = UIReturnKeyDone;
    
    return textField;
}

+(void)showRemindMessage:(NSString *)message{
    [[[UIAlertView alloc] initWithTitle:MyLocal(@"more_user_management_title")
                                message:message
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:MyLocal(@"ok"), nil] show];
}

+(NSNumber*)getNumberByBool:(BOOL)value{
    return [NSNumber numberWithBool:value];
}

+(NSNumber*)getNumberByInt:(int)value{
    return [NSNumber numberWithInt:value];
}

+(NSString*)getStringByStdString:(const char*)string{
    if (string) {
        return [NSString stringWithCString:string encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
}

+(NSString*)getStringByInt:(int)number{
    return [NSString stringWithFormat:@"%d", number];
}

+(NSString*)getStringByFloat:(float)number decimal:(int)decimal{
    if (decimal == -1) {
        return [@"" stringByAppendingFormat:@"%f",number];
    }else {
        NSString *format=[@"%." stringByAppendingFormat:@"%df", decimal];
        return [@"" stringByAppendingFormat:format,number];
    }
}

+(NSString*)getAppVersion{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    return versionNum;
}

+(NSString*)getAppName{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* appName =[infoDict objectForKey:@"CFBundleDisplayName"];
    return appName;
}

+(NSString*)getTimeString:(double)time format:(NSString*)format second:(BOOL)second{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:format];
    
    NSDate* date = nil;
    if (second) {
        date = [NSDate dateWithTimeIntervalSince1970:time];
    } else {
        date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    }
    
    return [dateFormatter stringFromDate:date];
}

+(NSDate*)getDateFromString:(NSString*)time format:(NSString*)format{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter dateFromString:time];
}

+(NSString*)getStringFromDate:(NSDate*)date format:(NSString*)format{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter stringFromDate:date];
}

+(NSDateComponents*)getComponentsFromDate:(NSDate*)date{
    return [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit |
                                                    NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit
                                           fromDate:date];
}

+(NSDateComponents*)getSubFromTwoDate:(NSDate*)from to:(NSDate*)to{
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ;
    return [cal components:unitFlags fromDate:from toDate:to options:0];
}

+(NSString*)getFilePathInDocument:(NSString*)fileName{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                       , NSUserDomainMask
                                                       , YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
}

+ (CGSize)getFontSize:(NSString*)text font:(UIFont*)font{
#ifdef __IPHONE_7_0
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil, NSForegroundColorAttributeName, nil];
    return [text sizeWithAttributes:attributes];
#else
    return [text sizeWithFont:font];
#endif
}

+ (NSArray*)getArrayFromStrByCharactersInSet:(NSString*)strResource character:(NSString*)character{
    return [strResource componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:character]];
}

@end
