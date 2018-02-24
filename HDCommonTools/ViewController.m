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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(permissionNotifacation:) name:HDPermissionStatusDidChangeNotification object:nil];
    [self initData];
    [self createUI];
}

-(void)initData{
    _titleArray = [NSArray arrayWithObjects:@"系统信息示例",@"权限申请示例",@"多媒体操作",@"常用宏定义示例",@"加密解密", nil];
    _dataArray = [NSMutableArray array];
    NSArray *array = [NSArray arrayWithObjects:@"打印软件版本",@"打印系统语言",@"打印系统iOS版本", nil];
    NSArray *array2 = [NSArray arrayWithObjects:@"申请GPS权限",@"申请相册权限",@"打开系统设置", nil];
    NSArray *array3 = [NSArray arrayWithObjects:@"播放音乐",@"关闭音乐", nil];
    NSArray *array4 = [NSArray arrayWithObjects:@"测试输出",@"16进制颜色#f44336",@"rgb颜色3，169，244，半透明",@"界面输出",@"将log输出到文件", nil];
    NSArray *array5 = [NSArray arrayWithObjects:@"md5加密",@"aes256加密",@"aes256解密", nil];
    [_dataArray addObject:array];
    [_dataArray addObject:array2];
    [_dataArray addObject:array3];
    [_dataArray addObject:array4];
    [_dataArray addObject:array5];
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
            NSLog(@"用户允许访问gps");
        }else if ([[userInfo objectForKey:HDPermissionStatusItem] integerValue] == kHDAuthorRestricted){
            NSLog(@"用户被限制访问gps");
        }else if ([[userInfo objectForKey:HDPermissionStatusItem] integerValue] == kHDNotDetermined){
            NSLog(@"用户尚未选择是否允许访问gps");
        }else{
            NSLog(@"用户不允许访问gps");
        }
    }else if ([[userInfo objectForKey:HDPermissionNameItem] integerValue] == kHDPermissionNamePhotoLib){
        if ([[userInfo objectForKey:HDPermissionStatusItem] integerValue] == kHDAuthorized) {
            NSLog(@"用户允许访问相册");
        }else if ([[userInfo objectForKey:HDPermissionStatusItem] integerValue] == kHDAuthorRestricted){
            NSLog(@"用户被限制访问相册");
        }else if ([[userInfo objectForKey:HDPermissionStatusItem] integerValue] == kHDNotDetermined){
            NSLog(@"用户尚未选择是否允许访问相册");
        }else{
            NSLog(@"用户不允许访问相册");
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
                    ///申请gps权限
                    [[HDCommonTools sharedHDCommonTools] getGPSLibraryWithType:kHDGPSPermissionWhenInUse];
                    break;
                case 1:
                    ///申请相册权限
                    [[HDCommonTools sharedHDCommonTools] getPhotoLibrary];
                    break;
                case 2:
                    ///打开系统设置
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
                }
                    break;
                case 1:{
                    //颜色为#f44336
                    UIColor *color = HDColorFromRGB(0xf44336);
                    [tableView setBackgroundColor:color];
                }
                    break;
                case 2:{
                    //颜色为3，169，244，不透明
                    UIColor *color = HDColorWithRGBA(3, 169, 244, 0.5);
                    [tableView setBackgroundColor:color];
                }
                    break;
                case 3:{
                    NSLog(@"屏幕宽高:%f,%f",HDScreenWidth,HDScreenHeight);
                    NSLog(@"状态栏当前高度:%f",HD_Portrait_Status_Height);//打电话时或者定位会发生变化
                    NSLog(@"状态栏默认高度:%f",HD_Default_Portrait_Status_Height);
                    NSLog(@"导航栏默认高度:%f",HD_Default_Portrait_NAVIGATION_BAR_HEIGHT);
                    NSLog(@"tabbar默认高度:%f",HD_Default_Portrait_TAB_BAR_HEIGHT);
                }
                    break;
                case 4:{
                    ///调用该函数之后，控制台将不会输出打印信息
                    _debugFilePath = [HDCommonTools setHdDebugLogToFile];
                    ///下面的打印已经打印到文件中
                    NSLog(@"屏幕宽高:%f,%f",HDScreenWidth,HDScreenHeight);
                    NSLog(@"状态栏当前高度:%f",HD_Portrait_Status_Height);//打电话时或者定位会发生变化
                    NSLog(@"状态栏默认高度:%f",HD_Default_Portrait_Status_Height);
                    NSLog(@"导航栏默认高度:%f",HD_Default_Portrait_NAVIGATION_BAR_HEIGHT);
                    NSLog(@"tabbar默认高度:%f",HD_Default_Portrait_TAB_BAR_HEIGHT);
                    
                    ///可以操作该文件,比如系统分享调试，可以分享到备忘录、imessage、微博等
                    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(HDScreenWidth/2 - 60, 20, 120, 40)];
                    button.layer.masksToBounds = YES;
                    button.layer.cornerRadius = 10;
                    button.layer.borderColor = [UIColor whiteColor].CGColor;
                    button.layer.borderWidth = 1.0f;
                    [button setTitle:@"分享测试信息" forState:UIControlStateNormal];
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
                    NSLog(@"md5加密的大写字符串：%@",[[HDCommonTools sharedHDCommonTools] getMD5withStr:@"我是哈哈哈" lowercase:YES]);
                    NSLog(@"md5加密的小写字符串：%@",[[HDCommonTools sharedHDCommonTools] getMD5withStr:@"我是哈哈哈" lowercase:NO]);
                }
                    break;
                case 1:
                    NSLog(@"aes加密后的字符串：%@",[[HDCommonTools sharedHDCommonTools] AES256EncryptWithPlainText:@"我是哈哈哈" andKey:@"密码只有我知道"]);
                    break;
                case 2:{
                    ///aes加密后的字符串
                    NSString* str = [[HDCommonTools sharedHDCommonTools] AES256EncryptWithPlainText:@"我是哈哈哈" andKey:@"密码只有我知道"];
                    NSLog(@"aes加密后的字符串：%@",str);
                    NSLog(@"aes解密后的字符串：%@",[[HDCommonTools sharedHDCommonTools] AES256DecryptWithCiphertext:str andKey:@"密码只有我知道"]);
                    ///使用错误的key解密是空值
                    NSLog(@"aes解密后的字符串：%@",[[HDCommonTools sharedHDCommonTools] AES256DecryptWithCiphertext:str andKey:@"错误的key值"]);
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
    
    NSString *titleText = [NSString stringWithFormat:@"测试输出信息%@.txt",dateString];
    NSString *shareText = [NSString stringWithFormat:@"测试输出信息%@.txt",dateString];
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
