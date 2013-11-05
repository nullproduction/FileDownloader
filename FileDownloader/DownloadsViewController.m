//
//  DownloadsViewController.m
//

#import "DownloadsViewController.h"

@implementation DownloadsViewController

- (id)init
{
    [self printDocumentsPath];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"downloads"];
    
    manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSArray *downloadTasks = [manager downloadTasks];
    
    if (downloadTasks.count)
    {
        NSLog(@"downloadTasks: %@", downloadTasks);
        // resume all
        for (NSURLSessionDownloadTask *downloadTask in downloadTasks)
        {
            [downloadTask resume];
        }
    }
    
    return [super init];
}

- (void)addDownloadTask:(id)sender
{
    NSURL *URL = [NSURL URLWithString:@"http://www.rarlab.com/rar/wrar500.exe"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
    progress:nil
    destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
       NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
        return [documentsDirectoryPath URLByAppendingPathComponent:[targetPath lastPathComponent]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
         NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
    
    NSLog(@"%d", downloadTask.taskIdentifier);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"addDownloadTask" style:UIBarButtonItemStyleBordered target:self action:@selector(addDownloadTask:)];
}

- (void)printDocumentsPath
{
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"%@", documentsDirectoryPath);
}



@end
