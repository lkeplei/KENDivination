//
//  KENUtils.h
//  KENDivination
//
//  Created by ken on 13-4-16.
//  Copyright (c) 2013年 ken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <string.h>

@interface KENUtils : NSObject

+(KENUtils*)shareUtils;

+(UIButton*)buttonWithImg:(NSString*)buttonText off:(int)off zoomIn:(BOOL)zoomIn image:(UIImage*)image
                 imagesec:(UIImage*)imagesec target:(id)target action:(SEL)action;

+(UILabel*)labelWithTxt:(NSString *)buttonText frame:(CGRect)frame
                   font:(UIFont*)font color:(UIColor*)color;

+(UITextField*)textFieldInit:(CGRect)frame color:(UIColor*)color bgcolor:(UIColor*)bgcolor
                        secu:(BOOL)secu font:(UIFont*)font text:(NSString*)text;

+(void)showRemindMessage:(NSString*)message;

+(NSNumber*)getNumberByBool:(BOOL)value;
+(NSNumber*)getNumberByInt:(int)value;

+(NSString*)getStringByStdString:(const char*)string;
+(NSString*)getStringByInt:(int)number;
+(NSString*)getStringByFloat:(float)number decimal:(int)decimal;

+(NSString*)getAppVersion;
+(NSString*)getAppName;

+(CGSize)getFontSize:(NSString*)text font:(UIFont*)font;
+(NSArray*)getArrayFromStrByCharactersInSet:(NSString*)strResource character:(NSString*)character;

+(NSString*)getTimeString:(double)time format:(NSString*)format second:(BOOL)second;
+(NSDate*)getDateFromString:(NSString*)time format:(NSString*)format;
+(NSString*)getStringFromDate:(NSDate*)date format:(NSString*)format;
+(NSDateComponents*)getComponentsFromDate:(NSDate*)date;
+(NSDateComponents*)getSubFromTwoDate:(NSDate*)from to:(NSDate*)to;

+(NSString*)getFilePathInDocument:(NSString*)fileName;

+(void)openUrl:(NSString*)url;

+(int)getRandomNumber:(int)from to:(int)to;
@end
