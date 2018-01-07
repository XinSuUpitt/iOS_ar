//
//  ViewController.m
//  ARPORTAL
//
//  Created by Suxin on 12/30/17.
//  Copyright © 2017 Suxin. All rights reserved.
//

#import "ViewController.h"
#import "Manager.h"
#import "HomeViewController.h"
#import "AccountViewController.h"

@interface ViewController () <ARSCNViewDelegate>

@property (nonatomic, strong) IBOutlet ARSCNView *sceneView;

@end

    
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set the view's delegate
    self.sceneView.delegate = self;
    
    // Show statistics such as fps and timing information
    self.sceneView.showsStatistics = NO;
    
    panameraViewImgString = @"art.scnassets/01.jpg";
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Create a session configuration
    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
    
    configuration.planeDetection = ARPlaneDetectionHorizontal;

    // Run the view's session
    [self.sceneView.session runWithConfiguration:configuration];
    
    [self initUI];
}

- (void)initUI
{
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    self.homeCtrl = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    self.accountCtrl = [[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil];
    
    [self initTopBarView];
    
    [self initBlurView];
    
    [self initHorizontalScrollView];
}

- (void)initTopBarView
{
    CGFloat itemSize = 36;
    CGFloat itemOriginY = 20 + ([Manager isPhoneX] ? 24 : 0);
    CGFloat paddingLeft = 20;
    
    addIV = [[UIImageView alloc] initWithFrame:CGRectMake(width/2-itemSize/2, itemOriginY, itemSize, itemSize)];
    [addIV setImage:[UIImage imageNamed:@"plus"]];
    addIV.image = [addIV.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [addIV setTintColor:[UIColor whiteColor]];
    [self.view addSubview:addIV];
    UITapGestureRecognizer *addIVTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addIVTapGRTap)];
    [addIV setUserInteractionEnabled:YES];
    [addIV addGestureRecognizer:addIVTapGR];
    
    homeIV = [[UIImageView alloc] initWithFrame:CGRectMake(paddingLeft, itemOriginY, itemSize, itemSize)];
    [homeIV setImage:[UIImage imageNamed:@"home"]];
    homeIV.image = [homeIV.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [homeIV setTintColor:[UIColor whiteColor]];
    [self.view addSubview:homeIV];
    UITapGestureRecognizer *homeIVTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(homeIVTapGRTap)];
    [homeIV setUserInteractionEnabled:YES];
    [homeIV addGestureRecognizer:homeIVTapGR];
    
    accountIV = [[UIImageView alloc] initWithFrame:CGRectMake(width-paddingLeft-itemSize, itemOriginY, itemSize, itemSize)];
    [accountIV setImage:[UIImage imageNamed:@"user"]];
    accountIV.image = [accountIV.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [accountIV setTintColor:[UIColor whiteColor]];
    [self.view addSubview:accountIV];
    UITapGestureRecognizer *accountIVTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accountIVTapGRTap)];
    [accountIV setUserInteractionEnabled:YES];
    [accountIV addGestureRecognizer:accountIVTapGR];
    
}

- (void)initBlurView
{
    hotImgsView = [[UIView alloc] initWithFrame:CGRectMake(0, height - 150, width, height)];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = hotImgsView.bounds;
    [hotImgsView addSubview:blurEffectView];
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    vibrancyView.frame = hotImgsView.bounds;
    [blurEffectView.contentView addSubview:vibrancyView];
    [self.view addSubview:hotImgsView];
}

- (void)initHorizontalScrollView
{
    horizontalScrollView = [[UIScrollView alloc] init];
    horizontalScrollView.delegate = self;
    int scrollWidth = 100;
    horizontalScrollView.frame = CGRectMake(hotImgsView.frame.origin.x, hotImgsView.frame.origin.y, width, scrollWidth);
    [self initImgArray];
    
    int xOffSet = 0;
    for (int i = 0; i < [imgNameArray count]; i++) {
        UIButton *imageView = [[UIButton alloc] initWithFrame:CGRectMake(xOffSet + 10, 10, 80, 80)];
        [imageView setImage:[UIImage imageNamed:[imgNameArray objectAtIndex:i]] forState:UIControlStateNormal];
        imageView.tag = i;
        [imageView addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [horizontalScrollView addSubview:imageView];
        
        xOffSet += 100;
    }
    
    [self.view addSubview:horizontalScrollView];
    horizontalScrollView.contentSize = CGSizeMake(scrollWidth + xOffSet, scrollWidth);
}

- (void)initImgArray
{
    imgNameArray = [[NSArray alloc] initWithObjects:@"art.scnassets/01.jpg",@"art.scnassets/02.jpg",@"art.scnassets/03.jpg",@"art.scnassets/04.jpg",@"art.scnassets/05.jpg",@"art.scnassets/06.jpg",@"art.scnassets/07.jpg",@"art.scnassets/08.jpg",@"art.scnassets/09.jpg",@"art.scnassets/10.jpg",@"art.scnassets/11.jpg",@"art.scnassets/12.jpg",@"art.scnassets/13.jpg",@"art.scnassets/14.jpg",@"art.scnassets/15.jpg",@"art.scnassets/16.jpg",@"art.scnassets/17.jpg",@"art.scnassets/18.jpg", nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Pause the view's session
    [self.sceneView.session pause];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)touchDown:(id)sender
{
    UIButton* button = (UIButton*)sender;
    panameraViewImgString = [imgNameArray objectAtIndex:button.tag];
    if (sphereNode) {
        sphereNode.childNodes.firstObject.geometry.firstMaterial.diffuse.contents = panameraViewImgString;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // tap screen to show portal, disregard to detect plane, not good sometimes
//    SCNScene *sphereScene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
//
//    SCNNode *sphereNode = [sphereScene.rootNode childNodeWithName:@"portal" recursively:YES];
//    if (sphereNode) {
//        SCNNode *camera = self.sceneView.pointOfView;
//        SCNVector3 position = SCNVector3Make(0, 0, -5);
//        sphereNode.position = [camera convertPosition:position toNode:nil];
//        //sphereNode.position = SCNVector3Make(hitResult.worldTransform.columns[3].x, hitResult.worldTransform.columns[3].y + 0.25, hitResult.worldTransform.columns[3].z);
//        [self.sceneView.scene.rootNode addChildNode:sphereNode];
//    }
    UITouch *touch = [[touches allObjects] firstObject];


    if (touch) {
        CGPoint locationPoint = [touch locationInView:self.sceneView];
        NSArray *results = [self.sceneView hitTest:locationPoint types:ARHitTestResultTypeExistingPlaneUsingExtent];

        ARHitTestResult *hitResult = [results firstObject];
        if (hitResult) {
            SCNScene *sphereScene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
            sphereNode = [sphereScene.rootNode childNodeWithName:@"portal" recursively:YES];
            if (sphereNode) {
                NSLog(@"material Node are %lu", (unsigned long)sphereNode.childNodes.count);
                sphereNode.childNodes.firstObject.geometry.firstMaterial.diffuse.contents = panameraViewImgString;
                SCNNode *camera = self.sceneView.pointOfView;
                SCNVector3 position = SCNVector3Make(0, MAX(hitResult.worldTransform.columns[3].y+0.5, 0) , -1);
                sphereNode.position = [camera convertPosition:position toNode:nil];
                [self.sceneView.scene.rootNode addChildNode:sphereNode];
            }
        }
    }
}

#pragma mark - ARSCNViewDelegate

/*
// Override to create and configure nodes for anchors added to the view's session.
- (SCNNode *)renderer:(id<SCNSceneRenderer>)renderer nodeForAnchor:(ARAnchor *)anchor {
    SCNNode *node = [SCNNode new];
 
    // Add geometry to the node...
 
    return node;
}
*/

- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    if (![anchor isKindOfClass:[ARPlaneAnchor class]]) {
        return;
    }
    ARPlaneAnchor *planeAnchor = anchor;

    SCNPlane *plane = [SCNPlane planeWithWidth:planeAnchor.extent.x height:planeAnchor.extent.z];

    SCNNode *planeNode = [[SCNNode alloc] init];
    planeNode.position = SCNVector3Make(0, 0, planeAnchor.center.z);
    planeNode.transform = SCNMatrix4MakeRotation(-M_PI/2, 1, 0, 0);
    SCNMaterial *gridMaterial = [[SCNMaterial alloc] init];
    gridMaterial.diffuse.contents = [UIImage imageNamed:@"art.scnassets/grid.png"];

    plane.materials = [NSArray arrayWithObjects:gridMaterial, nil];

    planeNode.geometry = plane;

    [node addChildNode:planeNode];
    
}

- (void)session:(ARSession *)session didFailWithError:(NSError *)error {
    // Present an error message to the user
    
}

- (void)sessionWasInterrupted:(ARSession *)session {
    // Inform the user that the session has been interrupted, for example, by presenting an overlay
    
}

- (void)sessionInterruptionEnded:(ARSession *)session {
    // Reset tracking and/or remove existing anchors if consistent tracking is required
    
}

#pragma mark - tap gesture method
- (void)addIVTapGRTap
{
    
}

- (void)homeIVTapGRTap
{
    [self.view.superview addSubview:self.homeCtrl.view];
    self.homeCtrl.view.frame = CGRectMake(-width, 0, width, height);
    self.homeCtrl.view.alpha = 0;
    [UIView animateWithDuration:.2 animations:^{
        self.homeCtrl.view.frame = CGRectMake(0, 0, width, height);
        self.homeCtrl.view.alpha = 1;
    } completion:^(BOOL finish){
        self.homeCtrl.view.frame = CGRectMake(0, 0, width, height);
        self.homeCtrl.view.alpha = 1;
        [self.view removeFromSuperview];
    }];
}

-(void)accountIVTapGRTap
{
    [self.view.superview addSubview:self.accountCtrl.view];
    self.accountCtrl.view.frame = CGRectMake(width, 0, width, height);
    self.accountCtrl.view.alpha = 0;
    [UIView animateWithDuration:.2 animations:^{
        self.accountCtrl.view.frame = CGRectMake(0, 0, width, height);
        self.accountCtrl.view.alpha = 1;
    } completion:^(BOOL finish){
        self.accountCtrl.view.frame = CGRectMake(0, 0, width, height);
        self.accountCtrl.view.alpha = 1;
        [self.view removeFromSuperview];
    }];
}

@end
