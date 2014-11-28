//
//  ViewController2.h
//  peekr
//
//  Created by Arnaud Crowther on 10/15/13.
//  Copyright (c) 2013 Arnaud Crowther. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

extern NSMutableArray *globalAccountsArray;
extern NSMutableArray *globalUserArray;
extern NSMutableArray *globalPasswArray;
extern NSMutableArray *globalBoolArray;
extern NSMutableArray *globalIconArray;
extern NSMutableArray *globalColorArray;

extern BOOL editFlag;
extern BOOL isFiltered;
extern NSInteger editIndex;

@interface ViewController2 : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSCoding, UISearchBarDelegate>
{
    //IBOutlet UISearchBar *searchBarOutlet;
    IBOutlet UITableView *tableView;
    IBOutlet UIBarButtonItem *addNew;
    NSArray *objects;///
    NSArray *searchedData;//displayed results
    NSMutableArray *srchAccounts;///
    NSMutableArray *srchUsername;///
    NSMutableArray *srchPassword;///
    //long *currentIndex;
}
@property (strong,nonatomic) NSMutableArray *accountsArray;
@property (strong,nonatomic) NSMutableArray *usernameArray;
@property (strong,nonatomic) NSMutableArray *passwordArray;
@property (strong,nonatomic) NSMutableArray *boolArray;
@property (strong,nonatomic) NSMutableArray *iconArray;
@property (strong,nonatomic) NSMutableArray *colorArray;
@property (strong,nonatomic) NSMutableArray *testArray;///

- (IBAction)editTable:(id)sender;
- (void)saveNSD;


@end
