//
//  HDCommonTools+UI.h
//  lanzhuBook
//
//  Created by Damon on 2018/3/9.
//  Copyright © 2018年 damon. All rights reserved.
//

#import "HDCommonTools.h"
#import <UIKit/UIKit.h>

//渐变方向
typedef NS_ENUM(NSInteger, HDGradientDirection) {
    kHDLinearGradientDirectionLeftToRight,                 //AC - BD
    kHDLinearGradientDirectionTopToBottom,              //AB - CD
    kHDLinearGradientDirectionLeftTopToRightBottom,    //A - D
    kHDLinearGradientDirectionLeftBottomToRightTop,      //C - B
};
//      A         B
//       _________
//      |         |
//      |         |
//       ---------
//      C         D

@interface HDCommonTools (UI)

///获取当前的normalwindow
- (UIWindow *)getCurrentNormalWindow;

///获取当前显示的VC，如果是navigation，就是top
- (UIViewController *)getCurrentVC;

/// 通过字符串获取颜色
/// @param hexColor 16进制颜色FFFFFF， 0XFFFFFF，或者 #FFFFFF都可以
- (UIColor *)getColorWithHexString:(NSString *)hexColor;

//通过颜色生成渐变图片，参考的whbalzac的WHGradientHelper
//线性渐变
- (UIImage *)getLinearGradientImage:(NSArray <UIColor *> *)colors directionType:(HDGradientDirection)directionType size:(CGSize)size;
//角度渐变
- (UIImage *)getRadialGradientImage:(NSArray <UIColor *> *)colors raduis:(CGFloat)raduis option:(CGSize)size;
///通过颜色生成图片
- (UIImage *)getImageWithColor:(UIColor *)color;
@end
