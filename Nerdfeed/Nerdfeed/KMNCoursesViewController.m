//
//  KMNCoursesViewController.m
//  Nerdfeed
//
//  Created by Michael Nwani on 9/13/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "KMNCoursesViewController.h"

@interface KMNCoursesViewController () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) NSArray *courses; //always copy collection objects.

@end

@implementation KMNCoursesViewController

#pragma mark - Initializers First
-(instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {   //navigationItem is used to represent a view controller in its parents navigation bar;
        //CoursesViewController is inside a NavigationController, therefore this represents itself in the navigation controller. Quite simple
        self.navigationItem.title = @"BNR Courses";
        
        //provides a set of properties that control various policies on a sessionwide basis.
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        
        [self fetchFeed];
    }
    
    return self;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.courses count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    NSDictionary *course = self.courses[indexPath.row];
    cell.textLabel.text = course[@"title"]; //all cell's have a textLabel property
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *course = self.courses[indexPath.row];
    NSURL *URL = [NSURL URLWithString:course[@"url"]];
    
    self.webViewController.title = course[@"title"];
    self.webViewController.URL = URL;
    //navigationController is a UIViewController property that will get the nearest NavigationController object in the parent hierarchy
    [self.navigationController pushViewController:self.webViewController animated:YES];
}

-(void)fetchFeed
{
//    NSString *requestString = @"http://bookapi.bignerdranch.com/courses.json";
    NSString *requestString = @"https://bookapi.bignerdranch.com/private/courses.json";
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    //This creates an HTTP request for the specified URL request object. It's already finished running, and the results
    //can be accessed through completionHandler's block
    NSURLSessionDataTask *dataTask =
    [self.session dataTaskWithRequest:req
                    completionHandler:
     ^(NSData *data, NSURLResponse *response, NSError *error)
    {
        //initWithData converts data into Unicode characters
//        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", json);
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        self.courses = jsonObject[@"courses"];
        NSLog(@"%@", self.courses);
        
        //this code is inside the completionHandler block, that's running on a background thread. dispatch_get_main_queue sends it to the main thread, sorta. That's the idea. Can only update UI objects on the main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
     ];
    
    [dataTask resume];
}

//just for the authentication (https, username and password credentials) session. Can delete this function and go back to the http version
-(void)URLSession:(NSURLSession *)session
             task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    NSURLCredential *cred = [NSURLCredential credentialWithUser:@"BigNerdRanch" password:@"AchieveNerdvana" persistence:NSURLCredentialPersistenceForSession];
    completionHandler(NSURLSessionAuthChallengeUseCredential, cred); //a block by the name of completionHandler
}

@end
