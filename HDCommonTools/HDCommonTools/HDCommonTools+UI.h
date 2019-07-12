//
//  HDCommonTools+UI.h
//  lanzhuBook
//
//  Created by Damon on 2018/3/9.
//  Copyright © 2018年 damon. All rights reserved.
//

#import "HDCommonTools.h"
#import <UIKit/UIKit.h>

@interface HDCommonTools (UI)
///获取当前的normalwindow
- (UIWindow *)getCurrentNormalWindow;

///获取当前显示的VC，如果是navigation，就是top
- (UIViewController *)getCurrentVC;

///该VC是否有tabbar
- (BOOL)hasTabbarVC;

///获取当前显示VC的View
- (UIView *)getCurrentView;
@end
