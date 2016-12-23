//
//  ViewController.h
//  MultipleDemo
//
//  Created by Cybraum on 12/22/16.
//  Copyright © 2016 Cybraum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@interface ViewController : UIViewController
{
    sqlite3_stmt *statement;
    sqlite3 *database;
    NSMutableArray *nameArray;
    NSMutableArray *placeArray;
}
@property (strong, nonatomic) IBOutlet UITextField *company;
@property (strong, nonatomic) IBOutlet UITextField *name;

@end

