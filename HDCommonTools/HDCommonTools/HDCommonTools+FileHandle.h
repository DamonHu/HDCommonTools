//
//  HDCommonTools+FileHandle.h
//  HDCommonTools
//
//  Created by Damon on 2018/2/15.
//  Copyright © 2018年 damon. All rights reserved.
//

#import "HDBaseCommonTools.h"

@interface HDCommonTools (FileHandle)

#pragma mark -
#pragma mark - 文件处理管理类

///将Data内容写入本地保存，重新命名，返回保存过的路径
// Write the Data content to local save, rename, and return the saved path
- (NSString *)saveData:(NSData *)data withFileName:(NSString *)fileName;

///在Document创建子文件夹并返回创建后的路径
//Create a subfolder in Document And return to the created path
- (NSString *)createDocumentSubFolderWithName:(NSString *)folderName;

///获取在Document文件夹里的或者子文件夹里面对应文件名的路径
//Get the path to the file name in the Document folder or in the subfolder
- (NSString *)getFilePathByfileName:(NSString *)fileName andSubfolderName:(NSString *)folderName;

///检查文件夹下是否有指定文件名文件
//Check if there is a specified file name file under the folder
- (BOOL)isExistFileWithfileName:(NSString *)fileName andSubfolderName:(NSString *)folderName;

@end
