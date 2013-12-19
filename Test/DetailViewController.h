//
//  DetailViewController.h
//  Test
//
//  Created by  on 19.12.13.
//  Copyright (c) 2013 Nubaslon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
@interface DetailViewController : UIViewController

@property (strong, nonatomic) Note *detailItem;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
