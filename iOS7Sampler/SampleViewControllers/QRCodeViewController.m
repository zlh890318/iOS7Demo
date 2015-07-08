//
//  QRCodeViewController.m
//  iOS7Sampler
//
//  Created by shuichi on 9/25/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "QRCodeViewController.h"
#import <CoreImage/CoreImage.h>
#import "QRScanViewController.h"


#define kText @"http://d.hatena.ne.jp/shu223/"


@interface QRCodeViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UITextField *textField;

@end


@implementation QRCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *scan = [[UIButton alloc] init];
    [scan setTitle:@"扫描" forState:(UIControlStateNormal)];
    [scan setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [scan addTarget:self action:@selector(scan) forControlEvents:(UIControlEventTouchUpInside)];
    [scan sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:scan];
    
    self.imageView.image = [self QRImageWithText:kText];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)creat:(id)sender
{
    self.imageView.image = [self QRImageWithText:self.textField.text];
}

- (UIImage *)QRImageWithText:(NSString *)text
{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    
    UIImage *image = [UIImage imageWithCGImage:cgImage
                                         scale:1.
                                   orientation:UIImageOrientationUp];
    
    // Resize without interpolating
    UIImage *resized = [self resizeImage:image
                             withQuality:kCGInterpolationNone
                                    rate:8.0];
    CGImageRelease(cgImage);
    
    return resized;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}

// =============================================================================
#pragma mark - Private

- (UIImage *)resizeImage:(UIImage *)image
             withQuality:(CGInterpolationQuality)quality
                    rate:(CGFloat)rate
{
	UIImage *resized = nil;
	CGFloat width = image.size.width * rate;
	CGFloat height = image.size.height * rate;
	
	UIGraphicsBeginImageContext(CGSizeMake(width, height));
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetInterpolationQuality(context, quality);
	[image drawInRect:CGRectMake(0, 0, width, height)];
	resized = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return resized;
}

- (void)scan
{
    [self.navigationController pushViewController:[[QRScanViewController alloc] initWithNibName:@"QRScanViewController" bundle:[NSBundle mainBundle]] animated:YES];
}

@end
