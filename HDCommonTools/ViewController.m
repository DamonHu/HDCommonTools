//
//  ViewController.m
//  HDCommonTools
//
//  Created by Damon on 2018/2/14.
//  Copyright © 2018年 damon. All rights reserved.
//

#import "ViewController.h"
#import "HDCommonHeader.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic)NSMutableArray * dataArray;
@property (strong,nonatomic)NSArray * titleArray;
@property (strong,nonatomic)NSString *debugFilePath;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ///注册权限回调通知
    //Registration authority callback notice
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(permissionNotifacation:) name:HDPermissionStatusDidChangeNotification object:nil];
    [self initData];
    [self createUI];
}

-(void)initData{
    _titleArray = [NSArray arrayWithObjects:@"系统信息示例 System information",@"权限申请示例 Permission application",@"多媒体操作 Multi-Media",@"常用宏定义示例 common define",@"加密解密 Crypto",@"Appstore", nil];
    _dataArray = [NSMutableArray array];
    NSArray *array = [NSArray arrayWithObjects:@"打印软件版本 Print software version",@"打印系统语言 Print system language",@"打印系统iOS版本 Print system iOS version", nil];
    NSArray *array2 = [NSArray arrayWithObjects:@"申请GPS权限 GPS permissions",@"申请相册权限 Photo album permissions",@"打开系统设置 Open the system settings", nil];
    NSArray *array3 = [NSArray arrayWithObjects:@"播放音乐 Play music",@"关闭音乐 Stop playing music", nil];
    NSArray *array4 = [NSArray arrayWithObjects:@"测试输出 Log output",@"16进制颜色 16 Decimal color #f44336",@"rgb color 3，169，244，translucent",@"Interface parameters",@"将log输出到文件 Output log to a file", nil];
    NSArray *array5 = [NSArray arrayWithObjects:@"md5加密 String MD5 encryption",@"aes256加密 String aes256 encryption",@"aes256解密 String aes256 Decrypted", nil];
    NSArray *array6 = [NSArray arrayWithObjects:@"应用内Appstore评分 Force the score pop-up window in app",@"跳转Appstore评分 Forced jump to appsStore to give score",@"应用内弹出appstore介绍 Force the score pop-up window in app",@"跳转到appstore看介绍 Jump to the appstore to see the introduction", nil];
    [_dataArray addObject:array];
    [_dataArray addObject:array2];
    [_dataArray addObject:array3];
    [_dataArray addObject:array4];
    [_dataArray addObject:array5];
    [_dataArray addObject:array6];
}
-(void)createUI{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, HDScreenWidth, HDScreenHeight) style:UITableViewStyleGrouped];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HDcommonToolcell"];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
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
    }else if ([[userInfo objectForKey:HDPermissionNameItem] integerValue] == kHDPermissionNamePhotoLib){
        if ([[userInfo objectForKey:HDPermissionStatusItem] integerValue] == kHDAuthorized) {
            NSLog(@"用户允许访问相册 Users are allowed access to Album");
        }else if ([[userInfo objectForKey:HDPermissionStatusItem] integerValue] == kHDAuthorRestricted){
            NSLog(@"用户被限制访问相册 Users are restricted to access to Album");
        }else if ([[userInfo objectForKey:HDPermissionStatusItem] integerValue] == kHDNotDetermined){
            NSLog(@"用户尚未选择是否允许访问相册 User has not chosen to allow access to the Album");
        }else{
            NSLog(@"用户不允许访问相册 Users do not allow access to Album");
        }
    }
}

#pragma mark -
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:
                    NSLog(@"%@",[[HDCommonTools sharedHDCommonTools] getAppVersion]);
                    break;
                case 1:
                    NSLog(@"%@",[[HDCommonTools sharedHDCommonTools] getIOSLanguage]);
                    break;
                case 2:
                    NSLog(@"%@",[[HDCommonTools sharedHDCommonTools] getIOSVersion]);
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:{
            switch (indexPath.row) {
                case 0:
                    ///申请gps权限 Apply for GPS permissions
                    [[HDCommonTools sharedHDCommonTools] getGPSLibraryWithType:kHDGPSPermissionWhenInUse];
                    break;
                case 1:
                    ///申请相册权限 Apply for Album permissions
                    [[HDCommonTools sharedHDCommonTools] getPhotoLibrary];
                    break;
                case 2:
                    ///打开系统设置 Open the system settings
                    [[HDCommonTools sharedHDCommonTools] openSetting];
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:{
            switch (indexPath.row) {
                case 0:{
                    NSString * musicFilePath = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"];
                    [[HDCommonTools sharedHDCommonTools] playMusic:musicFilePath];
                }
                    break;
                case 1:{
                    [[HDCommonTools sharedHDCommonTools] stopMusic];
                }
                default:
                    break;
            }
        }
            break;
        case 3:{
            switch (indexPath.row) {
                case 0:{
                    HDDebugLog(@"测试log输出，将HDCommonDefine中的HDDEBUG_MODE设置为false将不会打印");
                    HDDebugLog(@"Test log output, and set the HDDEBUG_MODE in HDCommonDefine to false will not be printed");
                }
                    break;
                case 1:{
                    //颜色为#f44336 The color is #f44336
                    UIColor *color = HDColorFromRGB(0xf44336);
                    [tableView setBackgroundColor:color];
                }
                    break;
                case 2:{
                    //颜色为3，169，244，透明度为50% The color is 3,169,244 and the transparency is 50%
                    UIColor *color = HDColorWithRGBA(3, 169, 244, 0.5);
                    [tableView setBackgroundColor:color];
                }
                    break;
                case 3:{
                    NSLog(@"ScreenWidth:%f,ScreenHeight:%f",HDScreenWidth,HDScreenHeight);
                    NSLog(@"状态栏当前高度 Status bar current height:%f",HD_Portrait_Status_Height);//打电话时或者定位会发生变化
                    NSLog(@"状态栏默认高度 Default height of State Bar:%f",HD_Default_Portrait_Status_Height);
                    NSLog(@"导航栏默认高度 Default height of the navigation bar:%f",HD_Default_Portrait_NAVIGATION_BAR_HEIGHT);
                    NSLog(@"tabbar默认高度 height of the tabBar:%f",HD_Default_Portrait_TAB_BAR_HEIGHT);
                }
                    break;
                case 4:{
                    ///After calling this function, the console will not output the print information
                    _debugFilePath = [[HDCommonTools sharedHDCommonTools] setHdDebugLogToFile];
                    ///The following print has been printed to the file
                    NSLog(@"ScreenWidth:%f,ScreenHeight:%f",HDScreenWidth,HDScreenHeight);
                    NSLog(@"状态栏当前高度 Status bar current height:%f",HD_Portrait_Status_Height);//打电话时或者定位会发生变化
                    NSLog(@"状态栏默认高度 Default height of State Bar:%f",HD_Default_Portrait_Status_Height);
                    NSLog(@"导航栏默认高度 Default height of the navigation bar:%f",HD_Default_Portrait_NAVIGATION_BAR_HEIGHT);
                    NSLog(@"tabbar默认高度 height of the tabBar:%f",HD_Default_Portrait_TAB_BAR_HEIGHT);
                    
                    ///可以操作该文件,比如系统分享调试，可以分享到备忘录、imessage、微博等
                    //The file can be manipulate, such as system sharing debugging, and can be shared with memos, IMessage, micro-blog, and so on
                    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(HDScreenWidth/2 - 60, 20, 120, 40)];
                    button.layer.masksToBounds = YES;
                    button.layer.cornerRadius = 10;
                    button.layer.borderColor = [UIColor whiteColor].CGColor;
                    button.layer.borderWidth = 1.0f;
                    [button setTitle:@"Share LogFile" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    [button setBackgroundColor:[UIColor clearColor]];
                    [button addTarget:self action:@selector(shareTest) forControlEvents:UIControlEventTouchUpInside];
                    [[[UIApplication sharedApplication] keyWindow] addSubview:button];
                }
                    break;
                default:
                    break;
            }
        }
        case 4:{
            switch (indexPath.row) {
                case 0:{
                    NSLog(@"md5加密的大写字符串 MD5 encrypted uppercase string：%@",[[HDCommonTools sharedHDCommonTools] getMD5withStr:@"my name is HDCommonTools" lowercase:YES]);
                    NSLog(@"md5加密的小写字符串 MD5 encrypted lowercase string：%@",[[HDCommonTools sharedHDCommonTools] getMD5withStr:@"我my name is HDCommonTools" lowercase:NO]);
                }
                    break;
                case 1:
                    NSLog(@"aes加密后的字符串 AES encrypted string：%@",[[HDCommonTools sharedHDCommonTools] AES256EncryptWithPlainText:@"my name is HDCommonTools" andKey:@"密码只有我知道"]);
                    break;
                case 2:{
                    ///aes加密后的字符串 AES encrypted string
                    NSString* str = [[HDCommonTools sharedHDCommonTools] AES256EncryptWithPlainText:@"my name is HDCommonTools" andKey:@"Password"];
                    NSLog(@"aes加密后的字符串 AES encrypted string：%@",str);
                    NSLog(@"aes解密后的字符串 AES decrypted string：%@",[[HDCommonTools sharedHDCommonTools] AES256DecryptWithCiphertext:str andKey:@"Password"]);
                    ///使用错误的key解密是空值 The use of the wrong key decryption is an empty value
                    NSLog(@"aes使用错误的key解密后的字符串 AES decrypted string with wrong Password：%@",[[HDCommonTools sharedHDCommonTools] AES256DecryptWithCiphertext:str andKey:@"WrongPassword"]);
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 5:{
            switch (indexPath.row) {
                case 0:{
                    //应用内Appstore评分 Force the score pop-up window in app"
                    [[HDCommonTools sharedHDCommonTools] giveScoreWithAppleID:@"1193575039" withType:kHDScoreTypeInApp];
                }
                    break;
                case 1:{
                    //跳转Appstore评分 Forced jump to appsStore to give score
                    [[HDCommonTools sharedHDCommonTools] giveScoreWithAppleID:@"1193575039" withType:kHDScoreTypeInAppStore];
                }
                    break;
                case 2:{
                    //应用内弹出appstore介绍 Force the score pop-up window in app
                    [[HDCommonTools sharedHDCommonTools] jumpStoreWithAppleID:@"1193575039" withType:kHDJumpStoreTypeInApp];
                }
                    break;
                case 3:{
                    //跳转到appstore看介绍 Jump to the appstore to see the introduction
                    [[HDCommonTools sharedHDCommonTools] jumpStoreWithAppleID:@"1193575039" withType:kHDJumpStoreTypeInAppStore];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

-(void)shareTest{
    NSDateFormatter *temp_formatter = [[NSDateFormatter alloc] init];
    [temp_formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString* dateString = [temp_formatter stringFromDate:[NSDate date]];
    
    NSString *titleText = [NSString stringWithFormat:@"测试输出信息Test output information%@.txt",dateString];
    NSString *shareText = [NSString stringWithFormat:@"测试输出信息Test output information%@.txt",dateString];
    NSURL *URL = [NSURL fileURLWithPath:_debugFilePath];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:titleText,shareText,URL, nil] applicationActivities:nil];
    if ([[HDCommonTools sharedHDCommonTools] isPad]) {
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityVC];
        [popup presentPopoverFromRect:CGRectMake(HDScreenWidth/2, HDScreenHeight/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else {
        [self presentViewController:activityVC animated:true completion:nil];
    }
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [_dataArray objectAtIndex:section];
    return array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = [_dataArray objectAtIndex:indexPath.section];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HDcommonToolcell"];
    [cell.textLabel setText:[array objectAtIndex:indexPath.row]];
    return cell;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_titleArray objectAtIndex:section];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
