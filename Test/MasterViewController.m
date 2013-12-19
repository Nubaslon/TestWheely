//
//  MasterViewController.m
//  Test
//
//  Created by  on 19.12.13.
//  Copyright (c) 2013 Nubaslon. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "Note.h"

@interface MasterViewController () {
    NSArray *jsonArray;
    NSMutableArray *notes;
    NSMutableArray *notesNew;
    BOOL notesID;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    notes = [[NSMutableArray alloc] init];
    notesNew = [[NSMutableArray alloc] init];
    
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    [self requestNotes];
    
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(requestNotes) userInfo:nil repeats:YES];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

-(void)requestNotes
{
    NSLog(@"Ушел запрос...");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://crazy-dev.wheely.com"]];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedData:(NSData *)responseData
{
    NSError* error;
    jsonArray = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                           error:&error];
    NSLog(@"Количество полученных Notes: %d", [jsonArray count]);
    for (int i=0; i < [jsonArray count]; i++) {
        NSLog(@"ID - %@ (%@)", [Note noteWithData:[jsonArray objectAtIndex:i]].ID, [Note noteWithData:[jsonArray objectAtIndex:i]].title);
    }
    
    [notesNew removeAllObjects];
    for (int i=0; i<[jsonArray count]; i++) {
        Note *note = [Note noteWithData:[jsonArray objectAtIndex:i]];
        [notesNew addObject:note];
    }
    if ([notes count] == 0) {
        for (Note *note in notesNew) {
            [notes addObject:note];
        }
    }else
    {
        NSArray *tempArray = [NSArray arrayWithArray:notes];
        for (Note *note in tempArray) {
            notesID = FALSE;
            for (int i=0; i < [notesNew count]; i++) {
                Note *noteNew = [notesNew objectAtIndex:i];
               // NSLog(@"ID1 %@ = %@", noteNew.ID, note.ID);
                if ([note.ID isEqual:noteNew.ID]) {
                    notesID = TRUE;
                }
            }
           // NSLog(@"Check - %hhd", notesID);
            if (!notesID) {
                [notes removeObject:note];
            }
        }
        
        for (Note *noteNew in notesNew) {
            notesID = FALSE;
            for (int i=0; i < [notes count]; i++) {
                Note *note = [notes objectAtIndex:i];
                if ([note.ID isEqual:noteNew.ID] && ![note.text isEqual:noteNew.text]) {
                    NSLog(@"id %@ = %@, (%@ != %@)", note.ID, noteNew.ID, note.text, noteNew.text);
                    [notes replaceObjectAtIndex:i withObject:noteNew];
                }
               // NSLog(@"ID2 %@ = %@", noteNew.ID, note.ID);
                if ([noteNew.ID isEqual:note.ID]) {
                    notesID = TRUE;
                }
            }
            if (!notesID) {
                [notes addObject:noteNew];
            }
        }
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
//    if (!_objects) {
//        _objects = [[NSMutableArray alloc] init];
//    }
//    [_objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self requestNotes];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return _objects.count;
    return [notes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    //NSDate *object = _objects[indexPath.row];
    Note *note = [notes objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"(%@) %@", note.ID, note.title];
    cell.detailTextLabel.text = note.text;
    return cell;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
       // NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:[notes objectAtIndex:indexPath.row]];
    }
}

@end
