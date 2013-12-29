//
//  TableViewController.m
//  fashionMatome
//
//  Created by 千葉 俊輝 on 2013/12/29.
//  Copyright (c) 2013年 Toshiki Chiba. All rights reserved.
//

#import "TableViewController.h"

#import "WebViewController.h"

@interface TableViewController ()
- (IBAction)p_refresh:(id)sender;
@property(nonatomic) NSArray *itemList;
@property(nonatomic) NSString *selectLink;
@property(nonatomic) UIRefreshControl *refreshControl;
@end

static NSString *stringUrl = @"https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://apasoku.doorblog.jp/index.rdf&num=100";

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //self.navigationController.toolbar.tintColor = [UIColor colorWithRed:132.0f/255.0f green:203.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
    [self p_request];
    //[self p_setRefreshCotrol];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willAnimateRotationToInterfaceOrientation:
(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    NSLog(@"willAnimateRotationToInterfaceOrientation:duration:");
    [self.view setNeedsLayout];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.itemList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = self.itemList[indexPath.row][@"title"];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

// Cellのタップしたあとの処理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // タップされたCellのリンクを変数にいれておく
    self.selectLink = self.itemList[indexPath.row][@"link"];
    
    // segueを使って遷移させる
    [self performSegueWithIdentifier:@"PushToWebViewSegue" sender:self];
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // Segueの特定
    if ( [[segue identifier] isEqualToString:@"PushToWebViewSegue"] ) {
        WebViewController *nextViewController = [segue destinationViewController];
        // ここで遷移先ビューの変数にlinkUrlを渡す
        nextViewController.stringUrl = self.selectLink;
    }

}

#pragma mark - Private Methods
- (void)p_request {
    // Create the url-request.
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // Set the method(HTTP-GET)
    [request setHTTPMethod:@"GET"];
    
    // Send the url-request.
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (data) {
                                   NSError *error = nil;
                                   
                                   // JSONの型によって、NSDictionaryとNSArrayを使い分ける
                                   NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                   
                                   if(error || !jsonObject){
                                       return ;
                                   }
                                   
                                   NSMutableArray *items = [NSMutableArray array];
                                   
                                   for(NSDictionary *dic in jsonObject[@"responseData"][@"feed"][@"entries"]){
                                       
                                       NSDictionary *item = @{@"title":dic[@"title"],
                                                                @"link":dic[@"link"],
                                                                @"date":dic[@"publishedDate"]};
                                       
                                       [items addObject:item];
                                   }
                                   
                                   self.itemList = items;
                                   
                                   [self.tableView reloadData];
                                   [self p_refreshFinished];
                               }
                           }];
    
}

- (void)p_setRefreshCotrol
{
    /*UIRefreshControlの生成と実装*/
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.hidden = YES;
    [self.refreshControl addTarget:self action:@selector(p_refreshStart) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    //タイトルの設定
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:[UIColor clearColor] forKey:NSBackgroundColorAttributeName];  //タイトルの背景色
    [attributes setObject:[UIColor colorWithRed:132.0f/255.0f green:203.0f/255.0f blue:238.0f/255.0f alpha:1.0f] forKey:NSForegroundColorAttributeName];  //タイトルの文字色
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Refresh" attributes:attributes] ;
    self.refreshControl.attributedTitle = title;  //タイトルの挿入
    self.refreshControl.tintColor = [UIColor colorWithRed:132.0f/255.0f green:203.0f/255.0f blue:238.0f/255.0f alpha:1.0f]; //色の設定
}

#pragma mark - UIRefresh Methods
-(void)p_refreshStart
{
    NSLog(@"Refresh start!!");
    self.refreshControl.hidden = NO;
    /*このメソッドでくるくる開始*/
    [self.refreshControl beginRefreshing];   //インスタンスメソッド
    [self p_request];
}

-(void)p_refreshFinished
{
    NSLog(@"Refresh finish!!");
    self.refreshControl.hidden = YES;
    /*このメソッドでくるくる停止*/
    [self.refreshControl endRefreshing];  //インスタンスメソッド
}

- (IBAction)p_refresh:(id)sender {
    [self p_request];
}
@end
