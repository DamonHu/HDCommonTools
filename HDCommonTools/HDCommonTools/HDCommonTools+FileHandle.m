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
- (NSString*)savedPathWithData:(NSData*)data WithFileName:(NSString*)fileName{
    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString *savedImagePath=[documentsDirectory stringByAppendingPathComponent:fileName];
    [data writeToFile:savedImagePath atomically:YES];
    return savedImagePath;
}

///在Document创建子文件夹
//Create a subfolder in Document
-(NSString*)createFolder:(NSString*)folderName{
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

///检查文件夹下是否有指定文件名文件
//Check if there is a specified file name file under the folder
-(BOOL)isExistFileWithName:(NSString*)fileName InFolder:(NSString*)folderName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath;
    if (folderName.length >0) {
        filePath = [[path stringByAppendingPathComponent:folderName] stringByAppendingPathComponent:fileName];
    }else{
        filePath = [path stringByAppendingPathComponent:fileName];
    }
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

@end
