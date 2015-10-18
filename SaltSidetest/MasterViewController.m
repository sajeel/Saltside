//
//  MasterViewController.m
//  SaltSidetest
//
//  Created by Sajjeel Khilji on 10/16/15.
//  Copyright (c) 2015 Saltside. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "JSONWebServiceRequest.h"
#import "Constants.h"
#import "CustomDisplayCell.h"



@interface MasterViewController ()
@property  NSArray *jsonResponse;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"CustomDisplayCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"CustomDisplayCell"];

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [self fetchDataFromGit];
}

-(void)fetchDataFromGit{
    
    NSURL *url = [NSURL URLWithString:kRequestURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
  
    typeof (self) __weak weakSelf = self;
    
    JSONWebServiceRequest *jsonRequestOperation = [JSONWebServiceRequest JSONWebServiceRequestWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        dispatch_async(dispatch_get_main_queue() , ^(void) {
            typeof (weakSelf) __strong strongSelf = weakSelf;
            
            if (!strongSelf) {
                return ;
            }
            [strongSelf loadDataIntoView:responseObject];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        dispatch_async(dispatch_get_main_queue(),^(void){
           //show some error
            typeof (weakSelf) __strong strongSelf = weakSelf;
            
            if (!strongSelf) {
                return ;
            }
            //[strongSelf showError];
        });
    }];
    
    [jsonRequestOperation start];
}


-(void)loadDataIntoView:(id)response{
    
    //self.jsonResponse = response;
    [self.tableView setDataSource:self];
    
    self.indexPathController.items = response;
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *object = [self.indexPathController.dataModel itemAtIndexPath:indexPath];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(7_0)
//{
//    return 70;
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.indexPathController.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomDisplayCell *cell =  (CustomDisplayCell*)[tableView dequeueReusableCellWithIdentifier:@"CustomDisplayCell" forIndexPath:indexPath];
    
    
    //NSDictionary *object = self.jsonResponse[indexPath.row];
    NSDictionary *object  = [self.indexPathController.dataModel itemAtIndexPath:indexPath];
    [cell setValues:object];

    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.jsonResponse removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
}

@end
