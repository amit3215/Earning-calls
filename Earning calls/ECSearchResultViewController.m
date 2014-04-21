//
//  ECSearchResultViewController.m
//  Earning calls
//
//  Created by GajendraRawat on 16/04/14.
//  Copyright (c) 2014 Thinksys Inc. All rights reserved.
//

#import "ECSearchResultViewController.h"

@interface ECSearchResultViewController ()

@end

@implementation ECSearchResultViewController

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
    
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.hidesBackButton = YES;
    
    UIButton  *searchEarningcallButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [searchEarningcallButton setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [searchEarningcallButton addTarget:self action:@selector(yourMethod) forControlEvents:UIControlEventTouchUpInside];
    [searchEarningcallButton setFrame:CGRectMake(0, 0, 32, 32)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchEarningcallButton];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-5.0, 0.0, 320.0, 44.0)];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 44.0)];
    searchBarView.autoresizingMask = 0;
    searchBar.delegate = self;
    [searchBarView addSubview:searchBar];
    self.navigationItem.titleView = searchBarView;
    
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"Call", @"Company", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(15, 80, 300, 30);
    [segmentedControl addTarget:self action:@selector(MySegmentControlAction:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 1;
    [self.view addSubview:segmentedControl];
    
    
}

-(void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar1

{
    [searchBar1 resignFirstResponder];
}

-(void)MySegmentControlAction:(UISegmentedControl *)segment


{
    
    
    
    if(segment.selectedSegmentIndex == 0)
    {
        
        UITableView *latestEarningcalls = [[UITableView alloc]initWithFrame:CGRectMake(0, 120, 320,380 ) style:UITableViewStylePlain];
        
        [self.view addSubview:latestEarningcalls];
    }
    
    
    else
        if(segment.selectedSegmentIndex == 1)
        {
            
            NSLog(@" second tab");
        }
    
}


-(void)yourMethod

{
    
    NSLog(@"dissmissed");
    
    [self.navigationController popViewControllerAnimated:YES];}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
