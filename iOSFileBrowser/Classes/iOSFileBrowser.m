//
//  iOSFileBrowser.m
//  iOSFileBrowser
//
//  Created by Pavel Krasnov on 1/14/17.
//  Copyright © 2017 Pavel Krasnov. All rights reserved.
//

#import "iOSFileBrowser.h"
#import "iOSWebviewController.h"

@interface iOSFileBrowser () {
    NSUInteger _directory;
    NSString* _pwd;
    NSInteger _pathlen;
    NSArray* _files;
    NSMutableArray* _upDirectories;
    NSMutableArray* _dirIndexes;
}

@end

@implementation iOSFileBrowser

- (id) initWithLocation:(NSUInteger)location {
    self = [super init];
    if (self) {
        switch (location) {
            case NSCachesDirectory:
                self.navigationItem.title = @"Cashes";
                break;
            case NSDocumentDirectory:
                self.navigationItem.title = @"Documents";
                break;
            case NSLibraryDirectory:
                self.navigationItem.title = @"Library";
                break;
            default:
                break;
        }
        _directory = location;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"cancel" style:UIBarButtonItemStylePlain target:self action:@selector(hide)];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(_directory, NSUserDomainMask, YES);
    _pwd = [paths objectAtIndex:0];
    _pathlen = [_pwd length];
    _files = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:_pwd error:nil];
    _upDirectories = [NSMutableArray array];
    _dirIndexes = [NSMutableArray array];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_pwd substringFromIndex:_pathlen];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _files.count + 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* identifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (! cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: identifier];
    }
    if (0 == indexPath.row) {
        cell.textLabel.text = @"..";
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.imageView.image = nil;
    }
    else {
        cell.textLabel.text = _files[indexPath.row - 1];
        NSString* itemPath = [_pwd stringByAppendingPathComponent:_files[indexPath.row - 1]];
        NSDictionary* attr = [[NSFileManager defaultManager]attributesOfItemAtPath:itemPath error:nil];
        NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
        NSURL *bundleURL = [[bundle resourceURL] URLByAppendingPathComponent:@"iOSFileBrowser.bundle"];
        if ([attr objectForKey:NSFileType] == NSFileTypeDirectory) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //cell.imageView.image = [UIImage imageNamed:@"folder"];
            NSBundle *resourceBundle = [NSBundle bundleWithURL:bundleURL];
            cell.imageView.image = [UIImage imageNamed:@"folder" inBundle:resourceBundle compatibleWithTraitCollection:nil];
            [_dirIndexes addObject:[NSNumber numberWithLong:indexPath.row]];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            //cell.imageView.image = [UIImage imageNamed:@"file"];
            NSBundle *resourceBundle = [NSBundle bundleWithURL:bundleURL];
            cell.imageView.image = [UIImage imageNamed:@"file" inBundle:resourceBundle compatibleWithTraitCollection:nil];
        }
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (0 == indexPath.row) {
        if (_upDirectories.count < 1) {
            return;
        }
        _pwd = _upDirectories.lastObject;
        [_upDirectories removeLastObject];
        _files = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:_pwd error:nil];
        [self.tableView reloadData];
    }
    else {
        if ([_dirIndexes containsObject:[NSNumber numberWithLong:indexPath.row]]) {
            //go to the subdirectory
            [_upDirectories addObject:_pwd];
            _pwd = [_pwd stringByAppendingPathComponent:_files[indexPath.row - 1]];
            _files = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:_pwd error:nil];
            [_dirIndexes removeAllObjects];
            [self.tableView reloadData];
        }
        else {
            //regular file
            //this just log file's name to console
            //you can implement something more usefull here
            NSLog(@"%@", _files[indexPath.row - 1]);
            
            iOSWebviewController *vc = [[iOSWebviewController alloc] init];
            
            vc.title = _files[indexPath.row - 1];
            
            [vc setFilePath:[_pwd stringByAppendingPathComponent:_files[indexPath.row - 1]]];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(void)hide{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
