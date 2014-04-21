//
//  DisplayPDFFileViewController.h
//  Earning calls
//
//  Created by Himanshu on 4/16/14.
//  Copyright (c) 2014 Thinksys Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisplayPDFFileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property(strong, nonatomic) NSString *path;

@end
