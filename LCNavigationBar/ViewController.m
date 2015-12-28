//
//  ViewController.m
//  LCNavigationBar
//
//  Created by CNlichao on 15/12/21.
//  Copyright © 2015年 com.lic. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationBar+Awesome.h"

#define UI_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UIImage *_heardImage;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeard;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view from its nib.
    self.title = @"好很好";
    self.tableView.tableHeaderView = self.tableHeard;
    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self.view layoutIfNeeded];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _heardImage = [self reSizeImage:[UIImage imageNamed:@"backGround"] toSize:self.tableView.tableHeaderView.frame.size];
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self setNavBarByContentInset];
        if (!self.view.window ){
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor greenColor]];
        }
    }
}
/**
 *  根据contentinset 计算截图位置
 */
- (void) setNavBarByContentInset {
    UIEdgeInsets inset =  self.tableView.contentInset;
    //重其它界面返回可能改变 contentInset.top
    if (self.tableView.contentOffset.y <= - inset.top) {
        //裁剪图片设置为navigationbar 的背景
        UIImage *backgroundImage = [self getImageFromImage:_heardImage subImageSize:CGSizeMake(UI_SCREEN_WIDTH, 64) subImageRect:CGRectMake(0, 0, UI_SCREEN_WIDTH, 64)];
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    } else if (self.tableView.contentOffset.y <=self.tableView.tableHeaderView.frame.size.height - 64 - inset.top) {
        UIImage *backgroundImage = [self getImageFromImage:_heardImage subImageSize:CGSizeMake(UI_SCREEN_WIDTH, 64) subImageRect:CGRectMake(0, self.tableView.contentOffset.y + inset.top, UI_SCREEN_WIDTH, 64)];
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor greenColor]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"ViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [UITableViewCell new];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"我可以渐变";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


#pragma mark - private method
//图片裁剪
-(UIImage *)getImageFromImage:(UIImage*) superImage subImageSize:(CGSize)subImageSize subImageRect:(CGRect)subImageRect {
    //    CGSize subImageSize = CGSizeMake(WIDTH, HEIGHT); //定义裁剪的区域相对于原图片的位置
    //    CGRect subImageRect = CGRectMake(START_X, START_Y, WIDTH, HEIGHT);
    CGImageRef imageRef = superImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
    UIGraphicsBeginImageContext(subImageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subImageRect, subImageRef);
    UIImage* returnImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext(); //返回裁剪的部分图像
    return returnImage;
}

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize {
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

@end
