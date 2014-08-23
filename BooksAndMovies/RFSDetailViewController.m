//
//  RFSDetailViewController.m
//  BooksAndMovies
//
//  Created by Josh Brown on 8/22/14.
//  Copyright (c) 2014 Roadfire Software. All rights reserved.
//

#import "RFSDetailViewController.h"

@interface RFSDetailViewController ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *genreLabel;
@property (strong, nonatomic) IBOutlet UILabel *summaryLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation RFSDetailViewController

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
    
    self.titleLabel.text = [self.entry valueForKeyPath:@"im:name.label"];
    self.nameLabel.text = [self.entry valueForKeyPath:@"im:artist.label"];
    self.genreLabel.text = [self.entry valueForKeyPath:@"category.attributes.label"];
    self.summaryLabel.text = [self.entry valueForKeyPath:@"summary.label"];
    
    [self loadImageView];
}

- (void)loadImageView
{
    NSArray *images = self.entry[@"im:image"];
    NSDictionary *imageDict = images.lastObject;
    NSString *urlString = imageDict[@"label"];
    [self loadFromURLString:urlString];
}

- (void)loadFromURLString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:data];
            self.imageView.image = image;
        });
    }];
    
    [task resume];
}

@end
