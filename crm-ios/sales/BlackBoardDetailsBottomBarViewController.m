//
//  BlackBoardDetailsBottomBarViewController.m
//  sales
//
//  Created by user on 2017/2/14.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "BlackBoardDetailsBottomBarViewController.h"
#import "BlackBoardDetailsTableViewController.h"
#import "Circle.h"

@interface BlackBoardDetailsBottomBarViewController ()
@property (nonatomic, strong) BlackBoardDetailsTableViewController *blackBoardDetailsVC;
@property (nonatomic, strong) BlackBoard *blackBoard;
@property (nonatomic, assign) NSInteger commentid;
@property (nonatomic, assign) BOOL isReply;
@end

@implementation BlackBoardDetailsBottomBarViewController

- (instancetype)initWithBlackBoardID:(BlackBoard *)blackBoard
{
    self = [super initWithModeSwitchButton:NO];
    if (self) {
        _commentid = 0;
        self.hidesBottomBarWhenPushed = YES;
        _blackBoardDetailsVC = [[BlackBoardDetailsTableViewController alloc]init];
        _blackBoardDetailsVC.blackBoard = blackBoard;
        _blackBoard = blackBoard;
        [self addChildViewController:_blackBoardDetailsVC];
        
        [self setUpBlock];
    }
    
    return self;
}



- (void)setUpBlock
{
    __weak BlackBoardDetailsBottomBarViewController *weakSelf = self;
    
    _blackBoardDetailsVC.didBlackBoardCommentSelected = ^(Comment *comment) {
        NSString *authorString = [NSString stringWithFormat:@"回复：%@ ", comment.uname];
        if ([weakSelf.editingBar.editView.text rangeOfString:authorString].location == NSNotFound) {
            weakSelf.editingBar.editView.placeholder = authorString;
            _commentid = comment.id;
            [weakSelf.editingBar.editView becomeFirstResponder];
        }
    };
    
    _blackBoardDetailsVC.didScroll = ^ {
        [weakSelf.editingBar.editView resignFirstResponder];
        //        [weakSelf hideEmojiPageView];
    };
    
    _blackBoardDetailsVC.didActivatedInputBar = ^ {
        [weakSelf.editingBar.editView becomeFirstResponder];
    };
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"黑板详情";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setLayout
{
    [self.view addSubview:_blackBoardDetailsVC.view];
    
    for (UIView *view in self.view.subviews) {view.translatesAutoresizingMaskIntoConstraints = NO;}
    NSDictionary *views = @{@"tableView": _blackBoardDetailsVC.view, @"editingBar": self.editingBar};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[tableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView][editingBar]"
                                                                      options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight
                                                                      metrics:nil views:views]];
}

- (void)sendContent
{
    MBProgressHUD *HUD = [Utils createHUD];
    
    NSString *comStr = self.editingBar.editView.text;
    comStr = [comStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (comStr.length <= 0) {
        NSLog(@"----");
        HUD.label.text = @"评论不能为空";
        [HUD hideAnimated:YES afterDelay:2500];
        return;
    }
    HUD.label.text = @"评论发送中";
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_BLACKBOARD_COMMENT_POST];
    NSInteger postid = _blackBoard.id;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"postid":[NSString stringWithFormat:@"%ld",postid],@"commentid":[NSString stringWithFormat:@"%ld",_commentid],@"content":self.editingBar.editView.text}                                                                                   error:nil];//912
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    [request addValue:dbid forHTTPHeaderField:@"dbid"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.label.text = @"网络异常，评论发送失败";
            
            [HUD hideAnimated:YES afterDelay:1];
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    //                    NSArray* data = dictionary[@"data"];
                    //                    NSArray* modelArray = [Comment mj_objectArrayWithKeyValuesArray:data];
                    HUD.label.text = @"评论发表成功";
                    [_blackBoardDetailsVC.tableView setContentOffset:CGPointZero animated:NO];
                    [_blackBoardDetailsVC reloadCommentList];
                    self.editingBar.editView.text = @"";
                    _commentid = 0;
                    self.editingBar.editView.placeholder = @"说点什么";
                }else{
                    HUD.label.text = @"评论失败";
                }
                [HUD hideAnimated:YES afterDelay:1];
            }else{
            }
        }
    }];
    [dataTask resume];
}

@end
