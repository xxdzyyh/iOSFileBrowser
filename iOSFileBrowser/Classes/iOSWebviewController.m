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
@property (strong, nonatomic) UITextView *textView;

@end

@implementation iOSWebviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.textView];
    
    if ([self.filePath hasSuffix:@".log"]) {
        NSString *string = [NSString stringWithContentsOfFile:self.filePath encoding:NSUTF8StringEncoding error:nil];
        
        self.textView.text = string;
        [self.view bringSubviewToFront:self.textView];
    } else {
        NSURL *url = [NSURL fileURLWithPath:self.filePath];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [self.webView loadRequest:request];
        
        [self.view bringSubviewToFront:self.webView];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.webView.frame = self.view.bounds;
    self.textView.frame = self.view.bounds;
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
    }
    return _textView;
}

@end
