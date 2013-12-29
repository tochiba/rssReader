//
//  WebViewController.h
//  fashionMatome
//
//  Created by 千葉 俊輝 on 2013/12/29.
//  Copyright (c) 2013年 Toshiki Chiba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>
@property (nonatomic) NSString* stringUrl;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
