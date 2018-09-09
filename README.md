![](./HDCommonTool.png)

# HDCommonTools

一句代码即可实现多种常用功能，根据数据处理、文件管理、多媒体管理、权限管理、系统信息、Appstore操作、加密解密、快捷宏定义等几种不同的类型封装不同的Category，同时可以通过调用不同的函数去使用。

A short code can achieve a variety of commonly used functions, according to the data processing, file management, multimedia management, rights management, information system, Appstore, encryption and decryption, quick macro definition type package several different Category.

## 一、导入项目 Import project

该工具可以使用cocoapods导入，也可以通过下载源文件导入。

The HDCommonTools can be imported with cocoapods or by downloading source files.

### 通过cocoapods导入 Importing through cocoapods

```
pod 'HDCommonTools'
```
### 通过文件导入 Importing through files

下载项目，将项目文件下的HDCommonTools文件夹里面的内容导入项目即可

Download the project, import the contents of the HDCommonTools folder into the project.

## 二、函数使用 Function use

两步即可调用所有函数功能。详细使用说明可以参考：[wiki](https://github.com/DamonHu/HDCommonTools/wiki)

All function functions can be called in the two step.[wiki](https://github.com/DamonHu/HDCommonTools/wiki)

### 1. 头文件导入

**为了避免用户对头文件感到困惑，所以2.x版本将引入头文件进行了修改**

**v1.x版本 - v1.x vsersion**

#### 导入头文件 Import header file

```
#import "HDCommonHeader.h"
```

**v2.x版本 - v2.x vsersion**

导入头文件 Import header file

```
#import "HDCommonTools.h"
```

****

### 2、通过单例调用即可 Can be called by a single case
```
///获取手机的语言设置
[[HDCommonTools sharedHDCommonTools] getIOSLanguageStr];
///申请gps权限
[[HDCommonTools sharedHDCommonTools] getGPSLibraryWithType:kHDGPSPermissionWhenInUse];
...
```
### 3、权限通知说明 Permission notice

在申请权限的过程，在返回结果的时候会触发通知。

In the process of applying for permissions, a notification is triggered when the result is returned.

**获取通知权限的变化状态比较特殊，因为能监测通知变化的相关接口是在iOS10.0之后添加的，所以在iOS10.0之前的版本在通知权限变化时是没有通知的，只能在申请权限之后，自己去检测是否授予权限**

**To obtain the change status notification authority is special, because the relevant interface monitoring notification change is added in the iOS10.0, so in previous versions of iOS10.0 there is no notice when the notification authority change, The solution is to check if the authority is granted after the application is applied.**

```
///系统权限授权变化通知
//System authority authorization change notification
FOUNDATION_EXPORT NSString * const HDPermissionStatusDidChangeNotification;

///系统变化通知中的userinfo的key，标记名字
//The key of the userinfo in the system change notification, marked name
FOUNDATION_EXPORT NSString * const HDPermissionNameItem;

///系统变化通知中的userinfo的key，标记状态
//The key of userinfo in the system change notification, marked state
FOUNDATION_EXPORT NSString * const HDPermissionStatusItem;
```

以申请gps权限为例

Take the application of GPS authority as an example

```
- (void)viewDidLoad {
    [super viewDidLoad];
    ///注册权限回调通知 egistration authority callback notice
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(permissionNotifacation:) name:HDPermissionStatusDidChangeNotification object:nil];
    ///申请gps权限 access to GPS
    [[HDCommonTools sharedHDCommonTools] requestGPSLibraryPermissionWithType:kHDGPSPermissionWhenInUse];
}

-(void)permissionNotifacation:(NSNotification*)notification{
    NSDictionary * userInfo = [notification userInfo];
    if ([[userInfo objectForKey:HDPermissionNameItem] integerValue] == kHDPermissionNameGPS) {
       if ([[userInfo objectForKey:HDPermissionStatusItem] integerValue] == kHDAuthorized) {
            NSLog(@"用户允许访问gps Users are allowed access to GPS");
        }else if ([[userInfo objectForKey:HDPermissionStatusItem] integerValue] == kHDAuthorRestricted){
            NSLog(@"用户被限制访问gps Users are restricted to access to GPS");
        }else if ([[userInfo objectForKey:HDPermissionStatusItem] integerValue] == kHDNotDetermined){
            NSLog(@"用户尚未选择是否允许访问gps User has not chosen to allow access to the GPS");
        }else{
            NSLog(@"用户不允许访问gps Users do not allow access to GPS");
        }
    }
}
```

为了更加清晰的使用，完善了demo，demo中每一类用法都加了使用方法。

For clearer use, demo is perfected, and every usage in demo is used.

![](./demo.png)

## 三、文件结构 file structure

|文件名 file name|文件作用 Document function|
|----|----|
|HDCommonHeader.h|包含所有头文件 Contain all the header files|
|HDCommonDefine.h|快捷处理的宏定义 Macro definition of shortcut processing|
|HDCommonToolsConfig|项目定义的枚举类型 Enumerated type of project definition|
|HDCommonTools|数据处理函数 Data processing function|
|HDCommonTools+FileHandle|文件处理函数 File processing function|
|HDCommonTools+Multimedia|多媒体文件处理函数 Multimedia file processing function|
|HDCommonTools+Permission|权限管理和申请函数 Authority management and application function|
|HDCommonTools+SystemInfo|手机系统信息及项目信息函数 system information and project information function|
|HDCommonTools+Appstore|appstore相关操作函数 Appstore related operating function|
|HDCommonTools+Encrypt|加密解密相关操作函数 Encryption and decryption related operating function|
|HDCommonTools+Date|时间相关操作函数 date related operating function|

## 四、功能概述 An overview of the function

已实现功能可以查看wiki中的功能介绍 :[wiki - 功能简介 Function summary](https://github.com/DamonHu/HDCommonTools/wiki/%E5%8A%9F%E8%83%BD%E7%AE%80%E4%BB%8B-Function-summary)

The functionality that has been implemented can look at the functional introduction in Wiki:[wiki - 功能简介 Function summary](https://github.com/DamonHu/HDCommonTools/wiki/%E5%8A%9F%E8%83%BD%E7%AE%80%E4%BB%8B-Function-summary)

## 五、其他 Other

欢迎交流，互相学习

Welcome to exchange and learn from each other

项目gitHub地址：[https://github.com/DamonHu/HDCommonTools](https://github.com/DamonHu/HDCommonTools)

gitHub Url：[https://github.com/DamonHu/HDCommonTools](https://github.com/DamonHu/HDCommonTools)

我的博客：[http://www.hudongdong.com/ios/796.html](http://www.hudongdong.com/ios/796.html)

My Blog：[http://www.hudongdong.com/ios/796.html](http://www.hudongdong.com/ios/796.html)

## 六、鸣谢 express gratitude

该项目参考使用了很多其他优秀项目，特别感谢以下开源项目

The project uses many other excellent projects, especially thanks to the following open source projects.

1. [SimulateIDFA](https://github.com/youmi/SimulateIDFA)
2. [Lunar-Solar-Calendar-Converter](https://github.com/isee15/Lunar-Solar-Calendar-Converter)

## 七、重要修改记录 Important revision record
### v2.0.0

1. 修改头文件引入模式 Modify header import mode

### v1.3.0

1. 调整优化代码 Optimization code
2. 增加农历公历转换 Increase the transformation of the lunar calendar
3. 完善日期操作 Perfect date operation

### v1.2.8
1. 修改日期比较功能，增加是否比较时间的选项。Modify the date comparison function，Increase the option that whether to ignore the time

### v1.2.6

1. 增加时间比较功能 Add the time comparison function
2. 增加通知权限的状态获取和申请 Add the status and application of notification permissions

### v1.2.0
1. 增加aes256加密解密模块 Add aes256 encryption and decryption module
2. 整理MD5加密解密功能 Sorting the encryption and decryption functions of MD5
3. 完善demo示例和说明 Perfect the demo examples and instructions

### v1.1.2
1. 增加常用宏定义 Adding commonly used macro definitions
2. 完善demo示例 Perfect the demo examples

### v1.1.1
1. 增加了appstore的预览页面和评分 Add the preview page and score of Appstore
