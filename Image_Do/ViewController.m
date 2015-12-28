//
//  ViewController.m
//  Image_   Image_filter filter
//
//  Created by 周双建 on 15/12/24.
//  Copyright © 2015年 周双建. All rights reserved.
//
/*
 UIImage和UIView使用的是左上原点坐标，Core Image和Core Graphics使用的是左下原点坐标
 */
#import "ViewController.h"

@interface ViewController ()
{
@protected
    //创建图像上下文
    CIContext * Context ;
    // 创建显示图片的控件
    UIImageView * ImageV;
    //我们要处理的图像
    CIImage * WillDoImage;
    //处理后，我们得到的图像
    CIImage * OutImage;
    //添加滤镜镜头
    CIFilter * Filter_zsj;
@public
    // 滤镜功能背景图
    UIView * View ;
    
    
}
@property(nonatomic,strong) NSMutableArray * AllPointArray;
// 标记是否可以涂鸦
@property(nonatomic,assign) BOOL TuYaBool;
//系统暂时图像
@property(nonatomic,strong) UIImage * Temp_Image;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.AllPointArray = [NSMutableArray arrayWithCapacity:0];
    self.Temp_Image = [UIImage imageNamed:@"4673e28380ac5b03ab2f8da9bb78d9e4.jpg"];
    [self loadNav];
    [self makeUI];
    // 创建滤镜的功能按钮
    [self filterBtn];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)loadNav{
    UILabel * Nav_Label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-100, 20, 200, 44)];
    Nav_Label.textAlignment = NSTextAlignmentCenter;
    Nav_Label.text = @"成功QQ吧提供--滤镜";
    Nav_Label.textColor = [UIColor magentaColor];
    Nav_Label.font = [UIFont fontWithName:@"" size:22];
    Nav_Label.shadowColor = [UIColor lightGrayColor];
    Nav_Label.shadowOffset = CGSizeMake(5, -5);
    [self.view addSubview:Nav_Label];
    UIView * Line =[[UIView alloc] initWithFrame:CGRectMake(0, 63.5, self.view.bounds.size.width, 0.5) ];
    Line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview: Line];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//图形布局
-(void)makeUI{
    // 添加加载控件（image）
    ImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 65, self.view.bounds.size.width, self.view.bounds.size.height-65)];
    // 设置图片的显示模式
    ImageV.contentMode = UIViewContentModeScaleToFill;
    //显示图像
    [self.view addSubview:ImageV];
    // 创建图像上下文
    [self getcontext];
    // 创建滤镜，镜头
    [self createFilter];
    //开始绘图
    [self createImage];
    // 进行图片的显示
    [self showImage];
}
-(void)getcontext{
    // 直接获取，以免处理优先级降低
    Context = [CIContext contextWithOptions:nil];
    
    // 第二种：
    // 使用OpenGl 我们选着 最低的版本
    /*
     EAGLContext * EAG = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES1 sharegroup:nil];
     Context = [CIContext contextWithEAGLContext:EAG];*/
    
    // 还有第三种
    /*NSNumber * Number = [NSNumber numberWithBool:YES];
     NSDictionary * Option_Dict = [NSDictionary dictionaryWithObject:Number forKey:kCIContextUseSoftwareRenderer];
     Context = [CIContext contextWithOptions:Option_Dict];
     */
}
-(void)createFilter{
    Filter_zsj = [CIFilter filterWithName:@"CIColorControls"] ;
}
-(void)createImage{
    ImageV.image = self.Temp_Image;
    //获取图像
    WillDoImage = [CIImage imageWithCGImage:ImageV.image.CGImage];
    //让滤镜镜头捕捉到她
    [Filter_zsj setValue:WillDoImage forKey:@"inputImage"];
}
-(void)showImage{
    // 获取滤镜后的图片
    CIImage * OverImage = [Filter_zsj outputImage];
    // 创建图像上下文
    // extent  Extent(xmin, ymin, xmax, ymax, spatialReference) 创建一个范围对象。坐标表示边界框左下角和右上角的坐标
    CGImageRef   ImageRef = [Context createCGImage:OverImage fromRect: [OverImage extent]];
    // 从图像上下文获取图像
    ImageV.image = [UIImage imageWithCGImage:ImageRef];
    CGImageRelease(ImageRef);
}
-(void)filterBtn{
    UIView * Filter_View = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    Filter_View.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:Filter_View];
    NSArray * Btn_titleArray = @[@"滤镜",@"磨皮",@"瘦身",@"涂鸦"];
    for (int i =0 ;i< Btn_titleArray.count ;i++){
        UIButton * Button = [UIButton buttonWithType:UIButtonTypeCustom];
        Button.frame = CGRectMake(10 + i* (80+(self.view.frame.size.width-340)/3), 5, 80, 40);
        Button.layer.cornerRadius = 6;
        [Button.layer setBorderWidth: 0.5];
        Button.tag = i;
        [Button setTitle:Btn_titleArray[i] forState:UIControlStateNormal];
        [Button addTarget:self action:@selector(filterClick:) forControlEvents:UIControlEventTouchUpInside];
        [Filter_View addSubview:Button];
    }
}
//图像滤镜处理
-(void)filterClick:(UIButton*)filterbtn{
    switch (filterbtn.tag) {
        case 0:
        {
            if (filterbtn.selected) {
                filterbtn.selected = NO;
                [self deallocView];
            }else{
                filterbtn.selected = YES;
                [self filterstar];
            }
        }
            break;
        case 1:{
            
        }
            break;
        case 2:
            
            break;
        case 3:
            if (filterbtn.selected) {
                filterbtn.selected = NO;
                self.TuYaBool = NO;
            }else{
                filterbtn.selected = YES;
                self.TuYaBool = YES;
            }
            break;
            
        default:
            break;
    }
}
-(void)filterstar{
    View = [[UIView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height-210, self.view.frame.size.width-20, 150)];
    View.backgroundColor = [UIColor whiteColor];
    View.layer.cornerRadius = 6;
    [self.view addSubview:View];
    NSArray * ColoerFunction = @[@"亮    度 :",@"饱和度 :",@"对比度 :"];
    
    for (int i =0 ; i< ColoerFunction.count; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10,10+ i * 50, 70, 40)];
        label.text = ColoerFunction[i];
        label.textColor = [UIColor redColor];
        [View addSubview:label];
        
        UISlider * Slider = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 10+ i * 50, CGRectGetWidth(View.frame)-CGRectGetWidth(label.frame)-25, 40)];
        Slider.maximumValue = 1.0;
        Slider.minimumValue = 0.0;
        Slider.tag = 100+i;
        Slider.thumbTintColor = [UIColor greenColor];
        Slider.maximumTrackTintColor = [UIColor purpleColor];
        [Slider addTarget:self action:@selector(slider:) forControlEvents:UIControlEventValueChanged];
        [View addSubview:Slider];
    }
    
    
}
// 背景图的消失
-(void)deallocView{
    [View removeFromSuperview];
}
// 功能
-(void)slider:(UISlider*)slider{
    switch (slider.tag - 100) {
        case 0:{
            // 亮度
            [Filter_zsj setValue:[NSNumber numberWithFloat:slider.value] forKey:@"inputBrightness"];
            [self showImage];
            
        }
            break;
        case 1:{
            // 饱和度 注意：饱和度的数值
            [Filter_zsj setValue:[NSNumber numberWithFloat:(1.0-slider.value)] forKey:@"inputSaturation"];
            [self showImage];
        }
            break;
        case 2:{
            // 对比度
            [Filter_zsj setValue:[NSNumber numberWithFloat:(1.0-slider.value)] forKey:@"inputContrast"];
            [self showImage];
        }
            break;
        default:
            break;
    }
}
// 涂鸦
-(void)tuya{
    // 获取图像的上下文
    
    for (int i = 0 ; i<_AllPointArray.count; i++) {
        for (int j =0 ; j<(int)([_AllPointArray[i] count]-1); j++) {
            UIGraphicsBeginImageContext(ImageV.frame.size);
            [ImageV.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-65)];
            // 取得第一个
            CGPoint onepoint = [_AllPointArray[i][j] CGPointValue];
            // 获取下一个
            CGPoint nextpoint = [_AllPointArray[i][j+1] CGPointValue];
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), onepoint.x, onepoint.y);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), nextpoint.x, nextpoint.y);
            [[UIColor redColor] set];
            CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathStroke);
            ImageV.image = UIGraphicsGetImageFromCurrentImageContext();
        }
    }
    self.Temp_Image = ImageV.image;
    [self createImage];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.TuYaBool) {
        NSMutableArray * pointArray = [NSMutableArray arrayWithCapacity:0];
        [_AllPointArray addObject:pointArray];
    }
    
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.TuYaBool) {
        UITouch * touch = [touches anyObject];
        CGPoint  point = [touch locationInView:ImageV];
        NSValue * value = [NSValue valueWithCGPoint:point];
        [[_AllPointArray lastObject] addObject:value];
        [self tuya];
    }
}
@end
