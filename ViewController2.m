//
//  ViewController2.m
//  peekr
//
//  Created by Arnaud Crowther on 10/15/13.
//  Copyright (c) 2013 Arnaud Crowther. All rights reserved.
//

#import "ViewController2.h"
#import "ViewController.h"
#import "AddNewTableController.h"

@interface ViewController2 ()

/**
 - Lots of extra variables in the header? CLEAN ME
 - Pressing back while in search unloads table?!
 - Debug isFiltered flag
 - "I bet somewhere in the code, the flag isnt being reset FIND IT"
 - - (this may be wrong)
 -
 -
**/

@end

@implementation ViewController2

NSMutableArray *globalAccountsArray;
NSMutableArray *globalUserArray;
NSMutableArray *globalPasswArray;
NSMutableArray *globalBoolArray;
NSMutableArray *globalIconArray;
NSMutableArray *globalColorArray;

BOOL editFlag = FALSE;
NSInteger editIndex = 0;
BOOL isFiltered = FALSE;

@synthesize accountsArray;
@synthesize usernameArray;
@synthesize passwordArray;
@synthesize boolArray;
@synthesize iconArray;
@synthesize colorArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(enterBGmode)
                                                 name: UIApplicationDidEnterBackgroundNotification
                                               object: nil];
    
//    CGRect newBounds = tableView.bounds;
//    newBounds.origin.y = newBounds.origin.y + searchBarOutlet.bounds.size.height;
//    tableView.bounds = newBounds;
    //searchBarOutlet = [[UISearchBar alloc]init];//WHY IS THIS HERE???????
    
    
    tableView.opaque = NO;
    ///tableView.backgroundColor = [UIColor clearColor];///use this to complete the multi color theme...
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableBG.png"]];
    [tempImageView setFrame:tableView.frame];
    ///tableView.backgroundView = tempImageView;
    
    [tableView setEditing: NO animated: YES];//disable table editing
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //change this to an independant key with a 1 or 0
    if ([defaults valueForKey:@"PeekrNSDA"]) {//if accounts key exists is nsdefaults, call extract
        [self extractNSD];
    }
    else {//key doest exist, initialize empty arrays
        globalAccountsArray = [[NSMutableArray alloc] init];//initialize globals
        globalUserArray = [[NSMutableArray alloc] init];
        globalPasswArray = [[NSMutableArray alloc] init];
        globalBoolArray = [[NSMutableArray alloc] init];
        globalIconArray = [[NSMutableArray alloc] init];
        globalColorArray = [[NSMutableArray alloc] init];
    }
}

- (void)enterBGmode
{
    [self saveNSD];
    [self logout];
}

- (void)logout
{
    [self.navigationController popToRootViewControllerAnimated: NO];
}

- (void)refresh
{
}

- (void)setTitleNumber
{
    if (accountsArray.count > 0) {
        [self.navigationItem setTitle:[NSString stringWithFormat:@"Peekr (%lu)",(unsigned long)accountsArray.count]];
    }
    else
        [self.navigationItem setTitle:[NSString stringWithFormat:@"Peekr"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    //pass globals into table source
    self.accountsArray = globalAccountsArray;
    self.usernameArray = globalUserArray;
    self.passwordArray = globalPasswArray;
    self.boolArray = globalBoolArray;
    self.iconArray = globalIconArray;
    self.colorArray = globalColorArray;
    
    [tableView reloadData];
    [self setTitleNumber];
    [self saveNSD];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //give arrays into globals and save to NSData
    globalAccountsArray = self.accountsArray;
    globalUserArray = self.usernameArray;
    globalPasswArray = self.passwordArray;
    globalBoolArray = self.boolArray;
    globalIconArray = self.iconArray;
    globalColorArray = self.colorArray;
    
    [self saveNSD];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self saveNSD];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (IBAction)editTable:(id)sender
{   //edit button functionality
    UIBarButtonItem * button = ((UIBarButtonItem*)sender);
    if (!tableView.editing)
    {
        [tableView setEditing:YES animated:YES];
        [button setTitle:@"Done"];
    }
    else
    {
        [tableView setEditing:NO animated:YES];
        [button setTitle:@"Edit"];
    }
}

- (void)saveNSD
{   //save to NSData
    NSData *PeekrdataAc = [NSKeyedArchiver archivedDataWithRootObject:accountsArray];
    [[NSUserDefaults standardUserDefaults] setObject:PeekrdataAc forKey:@"PeekrNSDA"];
    NSData *PeekrdataUn = [NSKeyedArchiver archivedDataWithRootObject:usernameArray];
    [[NSUserDefaults standardUserDefaults] setObject:PeekrdataUn forKey:@"PeekrNSDU"];
    NSData *PeekrdataPw = [NSKeyedArchiver archivedDataWithRootObject:passwordArray];
    [[NSUserDefaults standardUserDefaults] setObject:PeekrdataPw forKey:@"PeekrNSDP"];
    NSData *PeekrdataBo = [NSKeyedArchiver archivedDataWithRootObject:boolArray];
    [[NSUserDefaults standardUserDefaults] setObject:PeekrdataBo forKey:@"PeekrNSDB"];
    NSData *PeekrdataIc = [NSKeyedArchiver archivedDataWithRootObject:iconArray];
    [[NSUserDefaults standardUserDefaults] setObject:PeekrdataIc forKey:@"PeekrNSDI"];
    NSData *PeekrdataCo = [NSKeyedArchiver archivedDataWithRootObject:colorArray];
    [[NSUserDefaults standardUserDefaults] setObject:PeekrdataCo forKey:@"PeekrNSDC"];
}

- (void)extractNSD
{   //load saved data
    NSData *PeekrdataAc = [[NSUserDefaults standardUserDefaults] objectForKey:@"PeekrNSDA"];
    globalAccountsArray = [NSKeyedUnarchiver unarchiveObjectWithData:PeekrdataAc];
    NSData *PeekrdataUn = [[NSUserDefaults standardUserDefaults] objectForKey:@"PeekrNSDU"];
    globalUserArray = [NSKeyedUnarchiver unarchiveObjectWithData:PeekrdataUn];
    NSData *PeekrdataPw = [[NSUserDefaults standardUserDefaults] objectForKey:@"PeekrNSDP"];
    globalPasswArray = [NSKeyedUnarchiver unarchiveObjectWithData:PeekrdataPw];
    NSData *PeekrdataBo = [[NSUserDefaults standardUserDefaults] objectForKey:@"PeekrNSDB"];
    globalBoolArray = [NSKeyedUnarchiver unarchiveObjectWithData:PeekrdataBo];
    NSData *PeekrdataIc = [[NSUserDefaults standardUserDefaults] objectForKey:@"PeekrNSDI"];
    globalIconArray = [NSKeyedUnarchiver unarchiveObjectWithData:PeekrdataIc];
    NSData *PeekrdataCo = [[NSUserDefaults standardUserDefaults] objectForKey:@"PeekrNSDC"];
    globalColorArray = [NSKeyedUnarchiver unarchiveObjectWithData:PeekrdataCo];
    
    [tableView reloadData];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableViewa numberOfRowsInSection:(NSInteger)section
{
    return isFiltered ? searchedData.count : [self.accountsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //NSString *tmpIndex = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    //idArray[indexPath.row] = tmpIndex;
    
    //NSLog(@"%@",idArray);
    
    //each time the table draws cells, it records each row position and saves it in IDARRAY
    ///why is that usefull??????????????????????????
    //when (isFiltered) use the ID to determin which pw to pull

    
    //account object gets new array = IDARRAY
    //id array is used to determine placement in list order
    //when view disap the idarray must be updated with current list order
    
    static NSString *CellIdentifer = @"CellIdentifier";
    UITableViewCell *cell = [tableView2 dequeueReusableCellWithIdentifier:CellIdentifer];
    NSUInteger row = [indexPath row];//get row
    int colorVal = [[globalColorArray objectAtIndex: row] intValue];//color value from array

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifer];
    }
    if (isFiltered) {
        cell.textLabel.text = searchedData[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;//accessory
        cell.detailTextLabel.text = @"";//hidden
        cell.imageView.image = nil;
    }
    else if (!isFiltered) {
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.textLabel.text = [accountsArray objectAtIndex:row];//main label
        
        
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //background image and color
        ///cell.backgroundView =  [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"cellbg.png" ]];
        ///cell.selectedBackgroundView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBGdown.png"] ];
        ///cell.backgroundColor = [UIColor clearColor];
        //main text label size and font
        ///cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:34];
        ///cell.textLabel.backgroundColor = [UIColor whiteColor];
        //detail text label size and font
        ///cell.detailTextLabel.backgroundColor = [UIColor whiteColor];
        ///cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        //if hidden or not detail label text
        if ([[boolArray objectAtIndex:row] isEqualToString:@"1"]) {
            cell.detailTextLabel.text = @"hidden";//hidden
            cell.detailTextLabel.textColor = [UIColor grayColor];//gray
        }
        else {
            cell.detailTextLabel.text = [usernameArray objectAtIndex:row];//username
            cell.detailTextLabel.textColor = [UIColor blackColor];//blak
        }
        //color icon choice
        if ([[iconArray objectAtIndex:row] isEqualToString:@"1"]) {//load icon if '1'
            switch (colorVal) {
                case 0: cell.imageView.image =  [UIImage imageNamed:@"iconBlank.png"];break;
                case 1: cell.imageView.image =  [UIImage imageNamed:@"iconRed.png"];break;
                case 2: cell.imageView.image =  [UIImage imageNamed:@"iconOrange.png"];break;
                case 3: cell.imageView.image =  [UIImage imageNamed:@"iconYellow.png"];break;
                case 4: cell.imageView.image =  [UIImage imageNamed:@"iconGreen.png"];break;
                case 5: cell.imageView.image =  [UIImage imageNamed:@"iconBlue.png"];break;
                case 6: cell.imageView.image =  [UIImage imageNamed:@"iconPurple.png"];break;
                case 7: cell.imageView.image =  [UIImage imageNamed:@"iconGray.png"];break;
            }
        }
        else if ([[iconArray objectAtIndex:row] isEqualToString:@"0"]) {//no icon if '0'
            cell.imageView.image = nil;
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing == UITableViewCellEditingStyleDelete) {
    
        [tableView beginUpdates];
        [accountsArray removeObjectAtIndex:indexPath.row];
        [usernameArray removeObjectAtIndex:indexPath.row];
        [passwordArray removeObjectAtIndex:indexPath.row];
        [boolArray removeObjectAtIndex:indexPath.row];
        [iconArray removeObjectAtIndex:indexPath.row];
        [colorArray removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];

        [tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
        
        [self setTitleNumber];
    }
}

- (void)tableView:(UITableView *)tableViewx accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{   //account preview icon tap
    
    if (isFiltered) {
//        NSString *tempAC = srchAccounts[[indexPath row]];
//        NSString *tempUN = srchUsername[[indexPath row]];
//        NSString *tempPW = srchPassword[[indexPath row]];
//        NSString *tempCombo = [NSString stringWithFormat:@"%@\n%@",tempUN,tempPW];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:tempAC message:@"" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
//        
//        [alert show];
//        NSLog(@"%@",srchAccounts);
//        NSLog(@"%@",srchUsername);
//        NSLog(@"%@",srchPassword);
    }
    
    else if (!isFiltered) {
    NSString *tempUN = globalUserArray[[indexPath row]];
    NSString *tempPW = globalPasswArray[[indexPath row]];
    NSString *tempCombo = [NSString stringWithFormat:@"%@",tempPW];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:tempUN message:tempCombo delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
    
    [alert show];
    }

}

- (void)tableView:(UITableView *)tableView3 didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   //row selected
    if (isFiltered) {
        NSLog(@"row selected, is filtered");
        //[self killSearch];
        //[tableView reloadData];
        //searchBarOutlet.text = @"";
        //isFiltered = FALSE;//this closes search results I guess :/
    }
    else if (!isFiltered) {

    [self performSegueWithIdentifier:@"edit" sender:self];//send to edit page
    editFlag = TRUE;
    editIndex = [indexPath row];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableViewz moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
toIndexPath:(NSIndexPath *)toIndexPath
{   //move rows
    [self moveObjectAtIndex:fromIndexPath.row toIndex:toIndexPath.row object:accountsArray];
    [self moveObjectAtIndex:fromIndexPath.row toIndex:toIndexPath.row object:usernameArray];
    [self moveObjectAtIndex:fromIndexPath.row toIndex:toIndexPath.row object:passwordArray];
    [self moveObjectAtIndex:fromIndexPath.row toIndex:toIndexPath.row object:boolArray];
    [self moveObjectAtIndex:fromIndexPath.row toIndex:toIndexPath.row object:iconArray];
    [self moveObjectAtIndex:fromIndexPath.row toIndex:toIndexPath.row object:colorArray];
}

- (void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex object:(NSMutableArray*)array
{   //move row category
    id object = [array objectAtIndex:fromIndex];
    [array removeObjectAtIndex:fromIndex];
    [array insertObject:object atIndex:toIndex];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UISearchBar
-(void)searchBar:(UISearchBar *)searchBarx textDidChange:(NSString *)searchText
{
    if (searchText.length == 0)
        isFiltered = NO;
    else
        isFiltered = YES;
    
    NSMutableArray *tmpSearched = [[NSMutableArray alloc] init];//org
    //NSMutableArray *tmpAccounts = [[NSMutableArray alloc] init];
    //NSMutableArray *tmpUsername = [[NSMutableArray alloc] init];
    //NSMutableArray *tmpPassword = [[NSMutableArray alloc] init];
    int x = 0;
    for (NSString *string in accountsArray) {
        NSRange range = [string rangeOfString:searchText
                                      options:NSCaseInsensitiveSearch];
        x = x+1;
        if (range.location != NSNotFound) {
            [tmpSearched addObject:string];
            //[tmpAccounts addObject:usernameArray[currentIndex.row]];
            //if string = "accounts[x]"; tmp index = acounts[x
        }
    }
//    for (NSString *string in usernameArray) {
//        NSRange range = [string rangeOfString:searchText
//                                      options:NSCaseInsensitiveSearch];
//        if (range.location != NSNotFound) {
//            //[tmpUsername addObject:string];
//        }
//    }
//    for (NSString *string in passwordArray) {
//        NSRange range = [string rangeOfString:searchText
//                                      options:NSCaseInsensitiveSearch];
//        if (range.location != NSNotFound) {
//            //[tmpPassword addObject:string];
//        }
//    }
    searchedData = tmpSearched.copy;
    //srchAccounts = tmpAccounts.copy;
    //srchUsername = tmpUsername.copy;
    //srchPassword = tmpPassword.copy;
    
//    NSLog(@"%@",tmpUsername);
//    NSLog(@"%@",tmpPassword);
    //NSLog(@"x: %d",x);
    
    [tableView reloadData];
}

- (void)killSearch
{
    [self.searchDisplayController setActive:NO];
    [self.view endEditing:YES];
    //[searchBarOutlet setText:@""];
    isFiltered = FALSE;
    //[searchBarOutlet setShowsCancelButton:NO animated:YES];

    [tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self killSearch];
    [tableView setContentOffset:CGPointMake(0,-20) animated:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //[searchBarOutlet setShowsCancelButton:YES animated:YES];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    isFiltered = FALSE;
    [tableView reloadData];
}

@end
