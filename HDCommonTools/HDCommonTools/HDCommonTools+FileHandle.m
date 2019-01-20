//
//  HDCommonTools+FileHandle.m
//  HDCommonTools
//
//  Created by Damon on 2018/2/15.
//  Copyright © 2018年 damon. All rights reserved.
//

#import "HDCommonTools+FileHandle.h"

@implementation HDCommonTools (FileHandle)
#pragma mark -
#pragma mark - 文件处理管理类

///将Data内容写入本地保存，重新命名，返回保存过的路径
// Write the Data content to local save, rename, and return the saved path
- (NSString *)saveData:(NSData *)data withFileName:(NSString* )fileName {
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString *savedImagePath=[documentsDirectory stringByAppendingPathComponent:fileName];
    [data writeToFile:savedImagePath atomically:YES];
    return savedImagePath;
}

///在Document创建子文件夹并返回创建后的路径
//Create a subfolder in Document And return to the created path
- (NSString *)createDocumentSubFolderWithName:(NSString *)folderName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *folderPath = [path stringByAppendingPathComponent:folderName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    
    if(!(isDirExist && isDir))
        {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"Failure to create a folder");
            return @"";
        }
        return folderPath;
        }
    return folderPath;
}

///获取在Document文件夹里的或者子文件夹里面对应文件名的路径
//Get the path to the file name in the Document folder or in the subfolder
- (NSString *)getFilePathByfileName:(NSString *)fileName andSubfolderName:(NSString *)folderName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    if (folderName && folderName.length > 0) {
        path = [path stringByAppendingPathComponent:folderName];
    }
    if (fileName && fileName.length > 0) {
        path = [path stringByAppendingPathComponent:fileName];
    }
    return path;
}

///检查文件夹下是否有指定文件名文件
//Check if there is a specified file name file under the folder
-(BOOL)isExistFileWithfileName:(NSString*)fileName andSubfolderName:(NSString*)folderName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath;
    if (folderName.length >0) {
        filePath = [[path stringByAppendingPathComponent:folderName] stringByAppendingPathComponent:fileName];
    } else {
        filePath = [path stringByAppendingPathComponent:fileName];
    }
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

///指定路径的文件大小，单位b
///get the file size at path,the Unit is b
- (long long)fileSizeAtPath:(NSString *)filePath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

///指定路径的文件夹总大小，单位b
///get the folder size at path,the Unit is b
- (float)folderSizeAtPath:(NSString *)folderPath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil)
    {
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}
@end
