//
//  ViewController.m
//  URLConnection异步
//
//  Created by qingyun on 15/11/12.
//  Copyright (c) 2015年 qingyun. All rights reserved.
//

#import "ViewController.h"
#define baseUrl @"http://nj01ct01.baidupcs.com/file/eca447e3356a0166f403960f20dc63c5?bkt=p2-qd-906&fid=2924272195-250528-502953427281218&time=1447125589&sign=FDTAXGERLBH-DCb740ccc5511e5e8fedcff06b081203-1NhKOPUv%2BuyXjJfSm3eorMrFHRM%3D&to=njhb&fm=Nan,B,U,ny&sta_dx=4&sta_cs=0&sta_ft=mp3&sta_ct=7&fm2=Nanjing,B,U,ny&newver=1&newfm=1&secfm=1&flow_ver=3&pkey=1400eca447e3356a0166f403960f20dc63c5aac670600000003ec0d1&sl=81657935&expires=8h&rt=sh&r=390232927&mlogid=7270303167922281220&vuk=-&vbdid=2404003493&fin=True%20Color.mp3&slt=pm&uta=0&rtype=1&iv=0&isw=0&dp-logid=7270303167922281220&dp-callid=0.1.1"

#define kPath @"/Users/qingyun/Desktop"
@interface ViewController ()<NSURLConnectionDataDelegate>

@property(nonatomic,strong) NSString *filepath;

@end

@implementation ViewController
-(void)clickMe:(UIButton *)btn
{
    //1.创建url
    NSURL *url = [NSURL URLWithString:baseUrl];
    //创建request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.创建异步链接
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //执行请求，发起连接
    [connection start];
}

#pragma mark 下载协议
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //加载开始的时候调用一次
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (httpResponse.statusCode ==200) {
        //初始化  存储工作或者接受工作
          //创建一个文件对象
        _filepath = [NSString stringWithFormat:@"%@%@",kPath,httpResponse.suggestedFilename];
        if (![[NSFileManager defaultManager] createFileAtPath:_filepath contents:nil attributes:nil]) {
            NSLog(@"文件创建失败");
        }
        
    }
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //加载过程中反复调用
    NSLog(@"=======%ld",data.length);
    //1.打开文件
    NSFileHandle *dw = [NSFileHandle fileHandleForWritingAtPath:_filepath];
    if (dw==nil) {
        [connection cancel];
        return;
    }
    //2将文件偏移到最后
    [dw seekToEndOfFile];
    //3追加数据
    [dw writeData:data];
    //4.关闭文件
    [dw closeFile];
    
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //加载完成调用
    NSLog(@"=======下载完成");
    
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

-(void)addsubButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"clickMe" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickMe:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame=CGRectMake(100, 100, 100, 40);
    
    [self.view addSubview:btn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addsubButton];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
