//
//  ECViewController.m
//  Earning calls
//
//  Created by GajendraRawat on 16/04/14.
//  Copyright (c) 2014 Thinksys Inc. All rights reserved.
//

#import "ECViewController.h"

#import "TranscriptListTableViewController.h"

@interface ECViewController ()

@end

@implementation ECViewController
@synthesize audioPlayer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    earningcallsArray  = [[NSMutableArray alloc]initWithObjects:@"Apple",@"Google",@"Facebook",@"HP",@"Motorola" ,nil];
 
    searchEarningcallButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [searchEarningcallButton setImage:[UIImage imageNamed:@"images.png"] forState:UIControlStateNormal];
    [searchEarningcallButton addTarget:self action:@selector(yourMethod) forControlEvents:UIControlEventTouchUpInside];
    [searchEarningcallButton setFrame:CGRectMake(0, 0, 32, 32)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchEarningcallButton];
    

    NSArray *itemArray = [NSArray arrayWithObjects: @"Top Twenty", @"Dow Jones", @"Favourite", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(15, 80, 300, 30);
    [segmentedControl addTarget:self action:@selector(MySegmentControlAction:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 1;
    [self.view addSubview:segmentedControl];
    
    
    
    companyNameArray = [[NSMutableArray alloc] init];
    companySymbolArray = [[NSMutableArray alloc] init];
    
    
    NSLog(@"error");
}



- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    NSLog(@"Did Fail");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    
    NSArray *companiesArray = [dictionary objectForKey:@"companies"];
    
    for (NSDictionary *dict in companiesArray)
    {
        NSLog(@"%@", [dict objectForKey:@"name"]);
        
        [companyNameArray addObject:[dict objectForKey:@"name"]];
        [companySymbolArray addObject:[dict objectForKey:@"symbol"]];
    }
    
    [loadingIndicator stopAnimating];
    
    [latestEarningcallstable reloadData];
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    NSLog(@"checking table delegate method");
    
    if (seg == 0) {
        static NSString *identifier = @"cell";
        
        UITableViewCell *cell = [latestEarningcallstable dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        
        // Buttons on row
        
        UIButton *buttonToPlayMp3 = [[UIButton alloc] initWithFrame:CGRectMake(230, 10, 30, 30.0) ];
        buttonToPlayMp3.layer.cornerRadius = 10;
        [buttonToPlayMp3 setTag:indexPath.row];
        [buttonToPlayMp3 setImage:[UIImage imageNamed:@"Play.png"] forState:UIControlStateNormal];
        
        [buttonToPlayMp3 setShowsTouchWhenHighlighted:YES];
 
        [buttonToPlayMp3 addTarget:self action:@selector(playMp3:) forControlEvents:UIControlEventTouchUpInside];
        
        // custom views should be added as subviews of the cell's contentView:
        [cell.contentView addSubview:buttonToPlayMp3];
        
        
        
        UIButton *buttonToReadPdf = [[UIButton alloc] initWithFrame:CGRectMake(270, 10, 30, 30.0) ];
        buttonToReadPdf.layer.cornerRadius = 10;
        buttonToReadPdf.tag = indexPath.row;
        [buttonToReadPdf setImage:[UIImage imageNamed:@"pdf.png"] forState:UIControlStateNormal];
        [buttonToReadPdf setShowsTouchWhenHighlighted:YES];
        
        [buttonToReadPdf addTarget:self action:@selector(readPdf:) forControlEvents:UIControlEventTouchUpInside];
        // custom views should be added as subviews of the cell's contentView:
        [cell.contentView addSubview:buttonToReadPdf];
        
        cell.textLabel.text = [companyNameArray objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [companySymbolArray objectAtIndex:indexPath.row];
        
        return cell;
    } else {
        
         static NSString *CellIdentifier = @"Cell";
         UITableViewCell *cell = [dowjonestableview dequeueReusableCellWithIdentifier:CellIdentifier];
         if (cell == nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
         }
         cell.textLabel.text = [myWords objectAtIndex:indexPath.row];
         return cell;
         
        
    }
 
 
}

-(NSString*)getUrlFormp3AndPdf:(int)row  extension:(NSString*)ext  {
    
    NSString *selectedCompnay = [companyNameArray objectAtIndex:row];
    
    NSString *ipAddress = @"http://localhost";
    NSString *middlefolder = @"EarningCall";
    NSString *extension = ext;
    
    NSString *finalUrl =  [NSString stringWithFormat:@"%@/%@/%@/%@.%@", ipAddress,middlefolder, selectedCompnay,selectedCompnay,extension];
    
    NSString *finalStringWothoutSpace = [finalUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSLog(@"The final url is  : %@",finalUrl);
    
    return finalStringWothoutSpace;
}



-(void)playMp3:(id)sender{
    
    int rowNum = [(UIButton*)sender tag];
    NSLog(@"button clicked %i",rowNum);

    NSString *finalUrl = [self getUrlFormp3AndPdf:rowNum  extension:@"mp3"];

    NSURL *url = [NSURL URLWithString:finalUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;

    audioPlayer = [[AVAudioPlayer alloc] initWithData:data  error:&error];
    if (audioPlayer)
    {
        [audioPlayer prepareToPlay];
        [audioPlayer play];
    }
    else
    {
        NSLog(@"Error: %@", [error description]);
    }
}
-(void)readPdf:(id)sender{
    
    int rowNum = [(UIButton*)sender tag];
    NSString *finalUrl = [self getUrlFormp3AndPdf:rowNum  extension:@"pdf"];
    
    [self loadRemotePdf:finalUrl];

    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (seg == 0) {

        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *companyName = cell.textLabel.text;
        
        companyName = [companyName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSString *path = [NSString stringWithFormat:@"http://localhost/EarningCall/ScanDir.php?dirName=%@", companyName];
        TranscriptListTableViewController *transcriptListTableViewController = [[TranscriptListTableViewController alloc] initWithNibName:@"TranscriptListTableViewController" bundle:nil];
        [transcriptListTableViewController setPath:path];
        [transcriptListTableViewController setDirName:companyName];
        [self.navigationController pushViewController:transcriptListTableViewController animated:YES];
        
    } else {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *stringVariable = cell.textLabel.text;
        
        NSLog(@"The String Variable is  : %@",[[stringVariable stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""]);
        
        [self loadRemotePdf:[[stringVariable stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""]];
    }
}
- (void) loadRemotePdf:(NSString*)filename
{
    DisplayPDFFileViewController *displayPDFFileViewController = [[DisplayPDFFileViewController alloc] initWithNibName:@"DisplayPDFFileViewController" bundle:nil];

    [displayPDFFileViewController setPath:filename];
    [self.navigationController pushViewController:displayPDFFileViewController animated:YES];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (seg == 0) {
         return  [companyNameArray count];
    } else {
        
          return  [myWords count];
    }
  
}



-(void)yourMethod
{

    ECSearchResultViewController *openSearchViewController = [[ECSearchResultViewController alloc]initWithNibName:@"ECSearchResultViewController" bundle:nil];
    
    [self.navigationController pushViewController:openSearchViewController animated:YES];

}

-(void)MySegmentControlAction:(UISegmentedControl *)segment
{

    if(segment.selectedSegmentIndex == 0)
    {
        seg = 0;
        latestEarningcallstable = [[UITableView alloc]initWithFrame:CGRectMake(0, 120, 320,380 ) style:UITableViewStylePlain];
        latestEarningcallstable.delegate = self;
        latestEarningcallstable.dataSource = self;
        [self.view addSubview:latestEarningcallstable];
        
        
        
        loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingIndicator setFrame:[self.view frame]];
        [loadingIndicator setCenter:CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame))];
        [self.view addSubview:loadingIndicator];
        
        [loadingIndicator startAnimating];
        
        urlrequest = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://localhost/EarningCall/fetch_nyse_companies.php"] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0f];
        
        urlConnection = [[NSURLConnection alloc] initWithRequest:urlrequest delegate:self];
        

    }
   
    else
    if(segment.selectedSegmentIndex == 1)
    {
       
        NSLog(@" second tab");
        seg = 1;
        [latestEarningcallstable removeFromSuperview];
        
        threadfortable = dispatch_queue_create("com.thinksys.thread", NULL);
        
        
        dispatch_async(threadfortable, ^(void) {
        NSURL *myurl = [NSURL URLWithString:@"http://localhost/DowJones.txt"];
        NSString *mystring = [NSString stringWithContentsOfURL:myurl encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"%@",mystring);
        myWords = [mystring componentsSeparatedByString:@","];
        NSLog(@"%@",myWords);
            
            dispatch_sync(dispatch_get_main_queue(),^{
                
                dowjonestableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 120, 320,380 ) style:UITableViewStylePlain];
                dowjonestableview.delegate = self;
                dowjonestableview.dataSource = self;
                [self.view addSubview:dowjonestableview];
            });
        
       });
        
    }
    if(segment.selectedSegmentIndex == 2)
    {
         NSLog(@" thirld tab");
        
        
   /*     NSURL *url = [NSURL URLWithString:@"http://edge.media-server.com/m/p/rvqx6nyk/lan/en/st/retail"];
        NSData *soundData = [NSData dataWithContentsOfURL:url];
        NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [documents stringByAppendingPathComponent:@"sound.mov"];
        
        NSLog(@"The sound path is  : %@",filePath);
        
        [soundData writeToFile:filePath atomically:YES];*/
      
        
      /*  seg = 2;
        [latestEarningcallstable removeFromSuperview];
        
        
       
        threadfortable = dispatch_queue_create("com.thinksys.thirdqueuq", NULL);
        
        dispatch_async(threadfortable, ^(void) {
            
            NSURL *myurl = [NSURL URLWithString:@"http://localhost/hello.php"];
            NSString *mystring = [NSString stringWithContentsOfURL:myurl encoding:NSUTF8StringEncoding error:nil];
            NSLog(@"My string is  %@",mystring);

            dispatch_async(dispatch_get_main_queue(), ^{
                
                dowjonestableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 120, 320,380 ) style:UITableViewStylePlain];
                dowjonestableview.delegate = self;
                dowjonestableview.dataSource = self;
                [self.view addSubview:dowjonestableview];

                
            });
            
        });*/
        
        
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
