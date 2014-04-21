//
//  DisplayPDFFileViewController.m
//  Earning calls
//
//  Created by Himanshu on 4/16/14.
//  Copyright (c) 2014 Thinksys Inc. All rights reserved.
//

#import "DisplayPDFFileViewController.h"

@interface DisplayPDFFileViewController ()

@end

@implementation DisplayPDFFileViewController

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
    
    dispatch_queue_t threadToloadPdf =  dispatch_queue_create("com.thinksys.loadpdf", NULL);
    
    dispatch_async(threadToloadPdf, ^(void){
        
        
        NSURLRequest *myRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.path]];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            
             [self.webView loadRequest:myRequest];
            
        });
    
    });
    
    
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
