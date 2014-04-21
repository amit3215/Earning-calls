//
//  TranscriptListTableViewController.m
//  Earning calls
//
//  Created by Himanshu on 4/16/14.
//  Copyright (c) 2014 Thinksys Inc. All rights reserved.
//

#import "TranscriptListTableViewController.h"

#import "DisplayPDFFileViewController.h"

@interface TranscriptListTableViewController ()

@end

@implementation TranscriptListTableViewController

@synthesize path;
@synthesize dirName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    fileNameArray = [[NSMutableArray alloc] init];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:path] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0f];
    
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
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
    NSLog(@"Did Fail %@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    
    NSLog(@"List of files : %@",dictionary);
    
    for (NSInteger x = 2; x <= dictionary.count+1; x++) {
        
        NSString *intToString = [NSString stringWithFormat:@"%d", x];
        
        NSString *fileName = [dictionary objectForKey:intToString];
        fileName = [fileName stringByDeletingPathExtension];
        
        
        [fileNameArray addObject:fileName];
        
        
    }
    
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [fileNameArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [fileNameArray objectAtIndex:indexPath.row];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *fileName = cell.textLabel.text;
    
    fileName = [fileName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *filePath = [NSString stringWithFormat:@"http://localhost/EarningCall/%@/%@.pdf", dirName, fileName];
    
    NSLog(@"Helloooo%@", filePath);
    
    DisplayPDFFileViewController *displayPDFFileViewController = [[DisplayPDFFileViewController alloc] initWithNibName:@"DisplayPDFFileViewController" bundle:nil];
    
    [displayPDFFileViewController setPath:filePath];
    
    [self.navigationController pushViewController:displayPDFFileViewController animated:YES];

}


@end
