//
//  iOSWebviewController.m
//  iOSFileBrowser_Example
//
//  Created by yunmai on 2018/1/17.
//  Copyright © 2018年 Pavel Krasnov. All rights reserved.
//

#import "iOSWebviewController.h"

@interface iOSWebviewController ()

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation iOSWebviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.webView];
    

    NSURL *url = [NSURL fileURLWithPath:self.filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.webView.frame = self.view.bounds;
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

@end
