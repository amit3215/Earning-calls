//
//  TranscriptListTableViewController.h
//  Earning calls
//
//  Created by Himanshu on 4/16/14.
//  Copyright (c) 2014 Thinksys Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TranscriptListTableViewController : UITableViewController
{
    NSMutableData *responseData;
    
    NSMutableArray *fileNameArray;
}

@property (strong, nonatomic) NSString *path;

@property (strong, nonatomic) NSString *dirName;

@end
