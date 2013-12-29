//
//  WebViewController.m
//  fashionMatome
//
//  Created by 千葉 俊輝 on 2013/12/29.
//  Copyright (c) 2013年 Toshiki Chiba. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.toolbarHidden = NO;
    self.webView.delegate = self;
    // hasgTagをセットしてWebView表示
    NSURL *url = [NSURL URLWithString:self.stringUrl];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:req];

}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewAction
- (IBAction)goBackButton:(id)sender {
    [self.webView goBack];
}
- (IBAction)goForwardButton:(id)sender {
    [self.webView goForward];
}
- (IBAction)reloadButton:(id)sender {
    [self.webView reload];
}
- (IBAction)stopButton:(id)sender {
    [self.webView stopLoading];
}


#pragma mark - UIWebViewDelegate
// ページ読込開始時にインジケータをくるくるさせる
-(void)webViewDidStartLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

// ページ読込完了時にインジケータを非表示にする
-(void)webViewDidFinishLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
