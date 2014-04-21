//
//  ECViewController.h
//  Earning calls
//
//  Created by GajendraRawat on 16/04/14.
//  Copyright (c) 2014 Thinksys Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSearchResultViewController.h"
#import "DisplayPDFFileViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ECViewController : UIViewController <UISearchBarDelegate, NSURLConnectionDelegate, UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate>

{
    UISearchBar *searchBar;
    UIView *searchBarView;
    UIButton *searchEarningcallButton;
    NSXMLParser *xmlParser;
    
    NSURLRequest *urlrequest;
    NSURLConnection *urlConnection;
    NSMutableData *recieveddata;
    UITableView *latestEarningcallstable;
    UITableView *dowjonestableview;
    NSMutableArray *earningcallsArray;
    
    
    NSMutableData *responseData;
    NSMutableArray *companyNameArray;
    NSMutableArray *companySymbolArray;
    UIActivityIndicatorView *loadingIndicator;
    
    
    // BY me
    NSArray *myWords ;
    dispatch_queue_t threadfortable;
    
    int seg;
    AVAudioPlayer *audioPlayer;
  
    
}
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end
