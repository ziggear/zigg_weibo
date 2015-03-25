//
//  OAuthViewController.m
//  WB
//
//  Created by ziggear on 15-1-19.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import "OAuthViewController.h"
#import "URLParser.h"
#import "WBAuth.h"

@implementation NSString (NSString_Extended)

- (NSString *)urlencode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

@end

@interface OAuthViewController () <UIWebViewDelegate>
@property IBOutlet UIWebView *oauthWebView;
@end

@implementation OAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Login";
    self.oauthWebView.delegate = self;
    
    NSString *formatString = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@&scope=all&display=mobile&forcelogin=false", @"1206738583", [@"http://weeno.ziggear.us/redirect" urlencode]];
    NSURL *url = [NSURL URLWithString:formatString];
    [self.oauthWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if([request.URL.host isEqualToString:@"weeno.ziggear.us"]) {
        URLParser *parser = [[URLParser alloc] initWithURLString:request.URL.absoluteString];
        if([parser valueForVariable:@"code"].length > 0) {
            [self requestForAccessTokenByOAuthCode:[parser valueForVariable:@"code"]];
            [self.delegate oauthSuccess];
            return NO;
        } else {
            [self.delegate oauthFail];
            return YES;
        }
    } else {
        return YES;
    }
}

- (void)requestForAccessTokenByOAuthCode:(NSString *)code {
    NSString *formatString = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/access_token?client_id=%@&client_secret=%@&grant_type=authorization_code&code=%@&redirect_uri=%@", @"1206738583", @"74264f25486bb93030e98611853cb517", code, [@"http://weeno.ziggear.us/redirect" urlencode]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:formatString]];
    [req setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *d = [NSString stringWithUTF8String:[data bytes]];
        NSLog(@"%@", d);
        NSError *error;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(!error && [responseDict objectForKey:@"access_token"]) {
            //success
            [[WBAuth sharedAuth] setOauthCode:code];
            [[WBAuth sharedAuth] setAccessToken:[responseDict objectForKey:@"access_token"]];
            [[WBAuth sharedAuth] setUid:[responseDict objectForKey:@"uid"]];
            [[WBAuth sharedAuth] save];
            [self.delegate getAccessToken];
        } else {
            //fail
            [self.delegate getAccessTokenFail];
        }
    }];
}

@end
