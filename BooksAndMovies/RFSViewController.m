//
//  RFSViewController.m
//  BooksAndMovies
//
//  Created by Josh Brown on 8/22/14.
//  Copyright (c) 2014 Roadfire Software. All rights reserved.
//

#import "RFSViewController.h"
#import "RFSDetailViewController.h"

@interface RFSViewController ()

@property NSArray *entries;

@end

@implementation RFSViewController

- (IBAction)didChange:(id)sender
{
    UISegmentedControl *control = (UISegmentedControl *)sender;
    
    NSString *title = [control titleForSegmentAtIndex:control.selectedSegmentIndex];
    self.navigationItem.title = title;
    
    if (control.selectedSegmentIndex == 0)
    {
        [self loadBooks];
    }
    else
    {
        [self loadMovies];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Books";
    [self loadBooks];
}

- (void)loadBooks
{
    [self loadFromURLString:@"https://itunes.apple.com/us/rss/toppaidebooks/limit=25/json"];
}

- (void)loadMovies
{
    [self loadFromURLString:@"https://itunes.apple.com/us/rss/topmovies/limit=25/json"];
}

- (void)loadFromURLString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"response: %@", response);
        
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (!jsonError) {
            self.entries = [json valueForKeyPath:@"feed.entry"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            NSLog(@"error parsing json: %@", [jsonError localizedDescription]);
        }
    }];
    
    [task resume];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.entries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *entry = self.entries[indexPath.row];
    NSString *text = [entry valueForKeyPath:@"im:name.label"];
    cell.textLabel.text = text;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RFSDetailViewController *vc = segue.destinationViewController;
    
    UITableViewCell *cell = (UITableViewCell *)sender;
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    NSDictionary *entry = self.entries[path.row];
    vc.entry = entry;
}

@end
