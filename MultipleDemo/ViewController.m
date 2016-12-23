//
//  ViewController.m
//  MultipleDemo
//
//  Created by Cybraum on 12/22/16.
//  Copyright © 2016 Cybraum. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CreateDbDataTo];
    
    nameArray=[[NSMutableArray alloc]init];
    placeArray=[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)SaveAction:(id)sender
{
    
       [self insertData];
  
}
-(void)CreateDbDataTo
{
    
    NSString *databaseName = @"lijin.sqlite";
    
    // Get the path to the documents directory and append the databaseName
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
    
    
    // Check if the SQL database has already been saved to the users phone, if not then copy it over
    BOOL success;
    
    // Create a FileManager object, we will use this to check the status
    // of the database and to copy it over if required
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Check if the database has already been created in the users filesystem
    success = [fileManager fileExistsAtPath:databasePath];
    
    // If the database already exists then return without doing anything
    if(success) return;
    
    // If not then proceed to copy the database from the application to the users filesystem
    
    // Get the path to the database in the application package
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    
    // Copy the database from the package to the users filesystem
    
    [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)insertData
{
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir= [dirPaths objectAtIndex:0];
    NSString*  filepath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"lijin.sqlite"]];
    NSLog(@"%@",filepath);
    const char *dbpath = [filepath UTF8String];
    
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO LIJINTABLE (NAME,PLACE) VALUES (?,?)"];
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
        if(sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            sqlite3_bind_text(statement, 1, [_company.text UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [_name.text UTF8String],-1,SQLITE_TRANSIENT);

        }
        if(sqlite3_step(statement) != SQLITE_DONE )
        {
            NSLog( @"Error: %s", sqlite3_errmsg(database) );
        } else
        {
            NSLog( @"Insert into row id = %lld", (sqlite3_last_insert_rowid(database)));
            [self detail];
     }
       // sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    NSLog( @"Error: %s", sqlite3_errmsg(database) );

}

-(void)detail
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* songDetailDataPath=[documentsDirectory stringByAppendingPathComponent:@"lijin.sqlite"];
    const char *dbpath = [songDetailDataPath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM LIJINTABLE"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1,&statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                
                
                char *a=(char*) sqlite3_column_text(statement,0);
                char *b=(char*) sqlite3_column_text(statement,1);
                if (b)
                {
                    [nameArray addObject:[NSString stringWithUTF8String:a]];
                    [placeArray addObject:[NSString stringWithUTF8String:b]];
                }
                
                else
                {
                    // handle case when object is NULL, for example set result to empty string:
                }
            }
            sqlite3_finalize(statement);
        }
        
        NSLog(@"%@",nameArray);
        NSLog(@"%@",placeArray);

    }
    
}

@end
