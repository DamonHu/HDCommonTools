//
//  HDCommonTools+FileHandle.h
//  HDCommonTools
//
//  Created by Damon on 2018/2/15.
//  Copyright © 2018年 damon. All rights reserved.
//

#import "HDCommonTools.h"

@interface HDCommonTools (FileHandle)

#pragma mark -
#pragma mark - 文件处理管理类

///将Data内容写入本地保存，重新命名，返回保存过的路径
- (NSString*)savedPathWithData:(NSData*)data WithFileName:(NSString*)fileName;

///在Document创建子文件夹
-(NSString*)createFolder:(NSString*)folderName;

///检查文件夹下是否有指定文件名文件
-(BOOL)isExistFileWithName:(NSString*)fileName InFolder:(NSString*)folderName;

@end
