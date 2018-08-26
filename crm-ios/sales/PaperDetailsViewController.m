//
//  PaperDetailsViewController.m
//  sales
//
//  Created by user on 2017/1/19.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "PaperDetailsViewController.h"

@interface PaperDetailsViewController ()<UIWebViewDelegate>
@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, weak) UIBarButtonItem *backItem;
@property (nonatomic, weak) UIBarButtonItem *forwardItem;
@property (nonatomic, weak) UIBarButtonItem *refreshItem;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation PaperDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [SVProgressHUD show];
    self.navigationController.toolbarHidden = NO;
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [SVProgressHUD dismiss];
    self.navigationController.toolbarHidden = YES;
}
- (void)setUrl:(NSString *)url{
    _url = url;
    _hud = [Utils createHUD];
    _hud.label.text = @"正在加载";
    [self setupWebView];
    [self setupToolBars];
}

#pragma mark --private Method--初始化webView
- (void)setupWebView {
    UIWebView *webView = [[UIWebView alloc] init];
    self.webView = webView;
    webView.frame = self.view.frame;
    webView.delegate = self;
    [self.view addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
}
#pragma mark --private Method--初始化toolBar
- (void)setupToolBars{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"toolbar_back_icon"] imageWithRenderingMode:UIImageRenderingModeAutomatic] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    backItem.enabled = NO;
    self.backItem = backItem;
    
    UIBarButtonItem *forwardItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"toolbar_forward_icon"] imageWithRenderingMode:UIImageRenderingModeAutomatic]  style:UIBarButtonItemStylePlain target:self action:@selector(goForward)];
    forwardItem.enabled = NO;
    self.forwardItem = forwardItem;
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    self.refreshItem = refreshItem;
    
    self.toolbarItems = @[backItem,forwardItem,flexibleItem,refreshItem];
//    backItem.dk_tintColorPicker = DKColorPickerWithKey(TINT);
//    forwardItem.dk_tintColorPicker = DKColorPickerWithKey(TINT);
//    refreshItem.dk_tintColorPicker = DKColorPickerWithKey(TINT);
//    self.navigationController.toolbar.dk_tintColorPicker =  DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
}
#pragma mark -UIWebViewDelegate-将要加载Webview
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

#pragma mark -UIWebViewDelegate-已经开始加载Webview
- (void)webViewDidStartLoad:(UIWebView *)webView {
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //执行事件
//        [SVProgressHUD dismiss];
        [_hud hideAnimated:YES afterDelay:1];
    });
}

#pragma mark -UIWebViewDelegate-已经加载Webview完毕
- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    [SVProgressHUD dismiss];
    [_hud hideAnimated:YES afterDelay:1];
    self.backItem.enabled = webView.canGoBack;
    self.forwardItem.enabled = webView.canGoForward;
}

#pragma mark -UIWebViewDelegate-加载Webview失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    [SVProgressHUD dismiss];
    _hud.label.text = @"加载失败";
    [_hud hideAnimated:YES afterDelay:1];
}


#pragma mark --private Method--返回上一个页面
-(void)goBack {
    [self.webView goBack];
}

#pragma mark --private Method--前进到下一个页面
-(void)goForward {
    [self.webView goForward];
}

#pragma mark --private Method--刷新当前页面
-(void)refresh {
    [self.webView reload];
}

@end
