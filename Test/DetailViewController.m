//
//  DetailViewController.m
//  Test
//
//  Created by  on 19.12.13.
//  Copyright (c) 2013 Nubaslon. All rights reserved.
//

#import "DetailViewController.h"
#import "Note.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(Note *)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [NSString stringWithFormat:@"Title (%@) - %@", _detailItem.ID, _detailItem.title];
        self.textView.text = _detailItem.text;
        self.textView.layer.borderWidth = 2.0f;
        self.textView.layer.borderColor = [[UIColor grayColor] CGColor];
        self.navigationItem.title = _detailItem.title;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
