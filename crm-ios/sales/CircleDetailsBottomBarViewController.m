//
//  CircleDetailsBottomBarViewController.m
//  sales
//
//  Created by user on 2016/11/22.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "CircleDetailsBottomBarViewController.h"
#import "CircleDetailsTableViewController.h"
#import "Circle.h"

@interface CircleDetailsBottomBarViewController ()
@property (nonatomic, strong) CircleDetailsTableViewController *circleDetailsVC;
@property (nonatomic, strong) Circle *circle;
@property (nonatomic, assign) NSInteger commentid;
@property (nonatomic, assign) BOOL isReply;
@end

@implementation CircleDetailsBottomBarViewController

- (instancetype)initWithCircleID:(Circle *)circle
{
    self = [super initWithModeSwitchButton:NO];
    if (self) {
        _commentid = 0;
        self.hidesBottomBarWhenPushed = YES;
        _circleDetailsVC = [[CircleDetailsTableViewController alloc]init];
        _circleDetailsVC.circle = circle;
        _circle = circle;
        [self addChildViewController:_circleDetailsVC];
        
        [self setUpBlock];
    }
    
    return self;
}



- (void)setUpBlock
{
    __weak CircleDetailsBottomBarViewController *weakSelf = self;
    
    _circleDetailsVC.didCircleCommentSelected = ^(Comment *comment) {
        NSString *authorString = [NSString stringWithFormat:@"回复：%@ ", comment.uname];
        if ([weakSelf.editingBar.editView.text rangeOfString:authorString].location == NSNotFound) {
            weakSelf.editingBar.editView.placeholder = authorString;
            _commentid = comment.id;
            [weakSelf.editingBar.editView becomeFirstResponder];
        }
    };
    
    _circleDetailsVC.didScroll = ^ {
        [weakSelf.editingBar.editView resignFirstResponder];
//        [weakSelf hideEmojiPageView];
    };
    
    _circleDetailsVC.didActivatedInputBar = ^ {
        [weakSelf.editingBar.editView becomeFirstResponder];
    };
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"圈子详情";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setLayout
{
    [self.view addSubview:_circleDetailsVC.view];
    
    for (UIView *view in self.view.subviews) {view.translatesAutoresizingMaskIntoConstraints = NO;}
    NSDictionary *views = @{@"tableView": _circleDetailsVC.view, @"editingBar": self.editingBar};
    
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
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];;
    NSString *token = [Config getToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CIRCLE_COMMENT_POST];
    NSInteger postid = _circle.id;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"postid":[NSString stringWithFormat:@"%ld",postid],@"commentid":[NSString stringWithFormat:@"%ld",_commentid],@"content":self.editingBar.editView.text}                                                                                   error:nil];//912
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    
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
                    [_circleDetailsVC.tableView setContentOffset:CGPointZero animated:NO];
                    [_circleDetailsVC reloadCommentList];
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
