//
//  HDCommonTools+UI.m
//  lanzhuBook
//
//  Created by Damon on 2018/3/9.
//  Copyright © 2018年 damon. All rights reserved.
//

#import "HDCommonTools+UI.h"

@implementation HDCommonTools (UI)

///获取当前的normalwindow
- (UIWindow *)getCurrentNormalWindow {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (!window || window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    return window;
}

///获取当前显示的VC
- (UIViewController *)getCurrentVC {
    UIWindow * window = [self getCurrentNormalWindow];
    UIViewController *result = nil;
    if ([window subviews].count>0) {
        UIView *frontView = [[window subviews] objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
            result = nextResponder;
        else
            result = window.rootViewController;
    } else {
        result = window.rootViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [((UITabBarController*)result) selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [((UINavigationController*)result) visibleViewController];
    }
    return result;
}

/// 通过字符串获取颜色
/// @param hexColor 16进制颜色FFFFFF
- (UIColor *)getColorWithHexString:(NSString *)hexColor {
    if ([hexColor hasPrefix:@"#"]) {
        hexColor = [hexColor substringFromIndex:1];
    }
    else if ([hexColor hasPrefix:@"0x"]||[hexColor hasPrefix:@"0X"]){
        hexColor = [hexColor substringFromIndex:2];
    }
    if (hexColor.length != 6) {
        NSAssert(NO, @"颜色色值错误");
        return [UIColor clearColor];
    }
    unsigned int red=0,green=0,blue=0;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}

//线性渐变
- (UIImage *)getLinearGradientImage:(NSArray <UIColor *> * )colors directionType:(HDGradientDirection)directionType size:(CGSize)size {
    if (!colors || colors.count == 0) {
        return [[UIImage alloc] init];
    } else if (colors.count == 1) {
        return [self getImageWithColor:colors.firstObject];
    }
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    NSMutableArray *cgColors = [NSMutableArray array];
    NSMutableArray *locations = [NSMutableArray array];
    for (int i = 0; i < colors.count; i++) {
        UIColor *color = [colors objectAtIndex:i];
        [cgColors addObject:(__bridge id)color.CGColor];
        CGFloat location = (float)i/(float)(colors.count - 1);
        [locations addObject:@(location)];
    }
    
    gradientLayer.colors = [NSArray arrayWithArray:cgColors];
    gradientLayer.locations = [NSArray arrayWithArray:locations];
    
    if (directionType == HDLinearGradientDirectionLevel) {
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
    }else if (directionType == HDLinearGradientDirectionVertical){
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
    }else if (directionType == HDLinearGradientDirectionUpwardDiagonalLine){
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 1);
    }else if (directionType == HDLinearGradientDirectionDownDiagonalLine){
        gradientLayer.startPoint = CGPointMake(0, 1);
        gradientLayer.endPoint = CGPointMake(1, 0);
    }
    
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(gradientLayer.frame.size, NO, 0);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return gradientImage;
}
//角度渐变
- (UIImage *)getRadialGradientImage:(NSArray <UIColor *> *)colors raduis:(CGFloat)raduis option:(CGSize)size {
    if (!colors || colors.count == 0) {
        return [[UIImage alloc] init];
    } else if (colors.count == 1) {
        return [self getImageWithColor:colors.firstObject];
    }
    UIGraphicsBeginImageContext(size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, size.width / 2, size.height / 2, raduis, 0, 2 * M_PI, NO);
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
//    CGFloat locations[] = { 0.0, 1.0 };
    CGFloat locations[colors.count];
    
    NSMutableArray *cgColors = [NSMutableArray array];
    
    
    for (int i = 0; i < colors.count; i++) {
        UIColor *color = [colors objectAtIndex:i];
        [cgColors addObject:(__bridge id)color.CGColor];
        CGFloat location = (float)i/(float)(colors.count - 1);
        locations[i] = location;
    }
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) cgColors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    CGPoint center = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect));
    
    CGContextSaveGState(gc);
    CGContextAddPath(gc, path);
    CGContextEOClip(gc);
    
    CGContextDrawRadialGradient(gc, gradient, center, 0, center, raduis, 0);
    
    CGContextRestoreGState(gc);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    CGPathRelease(path);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
///通过颜色生成图片
- (UIImage *)getImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
