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

@import FirebaseStorage;
    
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set the view's delegate
    self.sceneView.delegate = self;
    
    // Show statistics such as fps and timing information
    self.sceneView.showsStatistics = NO;
    
    panameraViewImgString = @"art.scnassets/07.jpg";
    
    showARScene = NO;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    showVideo = NO;
    
    // Create a session configuration
    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
    
    configuration.planeDetection = ARPlaneDetectionHorizontal;

    // Run the view's session
    [self.sceneView.session runWithConfiguration:configuration];
    
    [self initUI];
    
//    FIRStorage *storage = [FIRStorage storage];
//    FIRStorageReference *storageRef = [storage referenceForURL:@"gs://arportal-xs.appspot.com/sphere_others/user_10.jpg"];
//    NSURL *localURL = [NSURL URLWithString:@"path/to/image"];
    
//    [storageRef dataWithMaxSize:3 * 1024 * 1024 completion:^(NSData *data, NSError *error){
//        if (error != nil) {
//            // Uh-oh, an error occurred!
//            NSLog(@"error");
//        } else {
//            // Data for "images/island.jpg" is returned
//            UIImageView *tmpUIImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, 300, 150)];
//            [tmpUIImageView setImage:[UIImage imageWithData:data]];
//            //[self.view addSubview:tmpUIImageView];
//
//            NSLog(@"data is %@", data);
//        }
//    }];
}

- (void)initUI
{
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    self.homeCtrl = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    self.homeCtrl.viewCtrlDelegate = self;
    self.accountCtrl = [[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil];
    self.accountCtrl.viewCtrlDelegate = self;
    
    [self initTopBarView];
    
    [self initBlurView];
    
    [self initHorizontalScrollView];
    
    UIScreenEdgePanGestureRecognizer *rightEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightEdgeGesture:)];
    rightEdgeGesture.edges = UIRectEdgeRight;
    rightEdgeGesture.delegate = self;
    [self.view addGestureRecognizer:rightEdgeGesture];
    
    centerX = self.view.bounds.size.width/2;
    
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftEdgeGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    leftEdgeGesture.delegate = self;
    [self.view addGestureRecognizer:leftEdgeGesture];
}

- (void)initTopBarView
{
    CGFloat itemSize = 30;
    CGFloat itemOriginY = 15 + ([Manager isPhoneX] ? 24 : 0);
    CGFloat paddingLeft = 15;
    
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
    [accountIV setImage:[UIImage imageNamed:@"account-100"]];
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
    
    refreshIV = [[UIImageView alloc] initWithFrame:CGRectMake(30, 100, 30, 30)];
    [refreshIV setImage:[UIImage imageNamed:@"refresh"]];
    [hotImgsView addSubview:refreshIV];
    [refreshIV setTintColor:[UIColor whiteColor]];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshTapped)];
    [refreshIV setUserInteractionEnabled:YES];
    [refreshIV addGestureRecognizer:tapGR];
}

- (void)refreshTapped
{
    if (showVideo) {
        [refreshIV setTintColor:[UIColor whiteColor]];
        showVideo = NO;
    } else {
        [refreshIV setTintColor:[UIColor redColor]];
        showVideo = YES;
    }
    
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
    imgNameArray = [[NSArray alloc] initWithObjects:@"art.scnassets/07.jpg",@"art.scnassets/08.jpg",@"art.scnassets/09.jpg",@"art.scnassets/10.jpg",@"art.scnassets/11.jpg",@"art.scnassets/12.jpg",@"art.scnassets/13.jpg",@"art.scnassets/14.jpg",@"art.scnassets/15.jpg",@"art.scnassets/16.jpg",@"art.scnassets/17.jpg",@"art.scnassets/18.jpg", nil];
}

- (void)addExitButton
{
    [addIV setHidden:YES];
    [homeIV setHidden:YES];
    [accountIV setHidden:YES];
    
    CGFloat itemSize = 30;
    CGFloat itemOriginY = 20 + ([Manager isPhoneX] ? 24 : 0);
    CGFloat paddingLeft = 15;
    exitIV = [[UIImageView alloc] initWithFrame:CGRectMake(width-paddingLeft-itemSize, itemOriginY, itemSize, itemSize)];
    [exitIV setImage:[UIImage imageNamed:@"x-thick"]];
    exitIV.image = [exitIV.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [exitIV setTintColor:[UIColor whiteColor]];
    [self.view addSubview:exitIV];
    UITapGestureRecognizer *accountIVTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitIVTapGRTap)];
    [exitIV setUserInteractionEnabled:YES];
    [exitIV addGestureRecognizer:accountIVTapGR];
}

- (void)resumeOriginalTopBar
{
    [addIV setHidden:NO];
    [homeIV setHidden:NO];
    [accountIV setHidden:NO];
    [exitIV setHidden:YES];
}

- (void)initARScene
{
    showARScene = NO;
    if (sphereNode) {
        [sphereNode removeFromParentNode];
    }
    [self.sceneView.session removeAnchor:planeAnchor];
    [self.sceneView.scene.rootNode removeFromParentNode];
    [self resumeOriginalTopBar];
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
        if (hitResult && showARScene == NO) {
            [self addExitButton];
            showARScene = YES;
            SCNScene *sphereScene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
            sphereNode = [sphereScene.rootNode childNodeWithName:@"portal" recursively:YES];
            if (sphereNode) {
                NSLog(@"material Node are %lu", (unsigned long)sphereNode.childNodes.count);
                
                if (showVideo) {
//                    NSArray *array = [[NSArray alloc] initWithObjects:@"art.scnassets/video_puppy", @"art.scnassets/video_london", @"art.scnassets/video_race", @"art.scnassets/video_starwar", nil];
//                    NSUInteger r = arc4random_uniform(4);
//                    NSString *str = [array objectAtIndex:r];
                    NSString *str = @"art.scnassets/louvre_museum";
                    SKVideoNode *videoSpriteKitNode = [[SKVideoNode alloc] initWithAVPlayer:[[AVPlayer alloc] initWithURL:[[NSBundle mainBundle] URLForResource:str withExtension:@"mp4"]]];
                    SKScene *spriteKitScene = [[SKScene alloc] initWithSize:CGSizeMake(3000, 3000)];
                    spriteKitScene.scaleMode = SKSceneScaleModeAspectFit;
                    videoSpriteKitNode.position = CGPointMake(spriteKitScene.size.width/2, spriteKitScene.size.height/2);
                    videoSpriteKitNode.size = spriteKitScene.size;
                    [spriteKitScene addChild:videoSpriteKitNode];
                    sphereNode.childNodes.firstObject.geometry.firstMaterial.diffuse.contents = spriteKitScene;
                    [videoSpriteKitNode play];
                    SCNNode *camera = self.sceneView.pointOfView;
                    SCNVector3 position = SCNVector3Make(0, MAX(hitResult.worldTransform.columns[3].y+0.5, 0) , -1);
                    sphereNode.position = [camera convertPosition:position toNode:nil];
                    sphereNode.transform = SCNMatrix4Translate(SCNMatrix4MakeRotation(-M_PI, 0, 0, 1), 0, 0.5, -1) ;
                    [self.sceneView.scene.rootNode addChildNode:sphereNode];
                } else {
                    sphereNode.childNodes.firstObject.geometry.firstMaterial.diffuse.contents = panameraViewImgString;
                    SCNNode *camera = self.sceneView.pointOfView;
                    SCNVector3 position = SCNVector3Make(0, MAX(hitResult.worldTransform.columns[3].y+0.5, 0) , -1);
                    sphereNode.position = [camera convertPosition:position toNode:nil];
                    [self.sceneView.scene.rootNode addChildNode:sphereNode];
                }
                
            }
            
            // with video
//            SKVideoNode *videoSpriteKitNode = [[SKVideoNode alloc] initWithAVPlayer:[[AVPlayer alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"art.scnassets/video_puppy" withExtension:@"mp4"]]];
//            SCNNode *videoNode = [[SCNNode alloc] init];
//            videoNode.geometry = [SCNSphere sphereWithRadius:30];
//
//            SKScene *spriteKitScene = [[SKScene alloc] initWithSize:CGSizeMake(2500, 2500)];
//            spriteKitScene.scaleMode = SKSceneScaleModeAspectFit;
//
//            videoSpriteKitNode.position = CGPointMake(spriteKitScene.size.width/2, spriteKitScene.size.height/2);
//            videoSpriteKitNode.size = spriteKitScene.size;
//
//            [spriteKitScene addChild:videoSpriteKitNode];
//
//            videoNode.geometry.firstMaterial.diffuse.contents = spriteKitScene;
//            videoNode.geometry.firstMaterial.doubleSided = YES;
//
//            [self.sceneView.scene.rootNode addChildNode:videoNode];
//            [videoSpriteKitNode play];
            
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
    planeAnchor = anchor;

    plane = [SCNPlane planeWithWidth:planeAnchor.extent.x height:planeAnchor.extent.z];

    planeNode = [[SCNNode alloc] init];
    planeNode.position = SCNVector3Make(0, 0, planeAnchor.center.z);
    planeNode.transform = SCNMatrix4MakeRotation(-M_PI/2, 1, 0, 0);
    SCNMaterial *gridMaterial = [[SCNMaterial alloc] init];
    gridMaterial.diffuse.contents = [UIImage imageNamed:@"art.scnassets/grid.png"];

    plane.materials = [NSArray arrayWithObjects:gridMaterial, nil];

    planeNode.geometry = plane;

    if (showARScene == NO) {
        [node addChildNode:planeNode];
    }
}

- (void)renderer:(id<SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    [[node.childNodes firstObject] removeFromParentNode];
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

#pragma mark - getter and setter
- (AccountViewController*)getAccountCtrl
{
    return self.accountCtrl;
}

- (HomeViewController*)getHomeCtrl
{
    return self.homeCtrl;
}

#pragma mark - swipe gesture methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handleLeftEdgeGesture:(UIScreenEdgePanGestureRecognizer *)gesture
{
    CGFloat distance = 100;
    UIView *fromView;
    UIView *toView;
    fromView = self.view;
    if (self.homeCtrl == nil) {
        self.homeCtrl = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        self.homeCtrl.viewCtrlDelegate = self;
    }
    [self.view.superview addSubview:self.homeCtrl.view];
    toView = self.homeCtrl.view;
    toView.frame = CGRectMake(-width, 0, width, height);
    if (UIGestureRecognizerStateBegan == gesture.state || UIGestureRecognizerStateChanged == gesture.state) {
        CGPoint transition = [gesture translationInView:gesture.view];
        toView.center = CGPointMake(centerX + transition.x - width, fromView.center.y);
    } else {
        CGPoint transition = [gesture translationInView:gesture.view];
        if (transition.x > distance) {
            toView.center = CGPointMake(centerX + transition.x - width, fromView.center.y);
            [UIView animateWithDuration:.3 animations:^{
                toView.center = CGPointMake(centerX, fromView.center.y);
            } completion:^(BOOL finished) {
                [self.sceneView.session pause];
            }];
        } else {
            toView.center = CGPointMake(centerX + transition.x - width, fromView.center.y);
            [UIView animateWithDuration:.3 animations:^{
                toView.center = CGPointMake(centerX-width, fromView.center.y);
            } completion:^(BOOL finished) {
                [toView removeFromSuperview];
            }];
        }
    }
}

- (void)handleRightEdgeGesture:(UIScreenEdgePanGestureRecognizer *)gesture
{
    CGFloat distance = 100;
    UIView *fromView;
    UIView *toView;
    fromView = self.view;
    if (self.accountCtrl == nil) {
        self.accountCtrl = [[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil];
        self.accountCtrl.viewCtrlDelegate = self;
    }
    [self.view.superview addSubview:self.accountCtrl.view];
    toView = self.accountCtrl.view;
    toView.frame = CGRectMake(width, 0, width, height);
    if (UIGestureRecognizerStateBegan == gesture.state || UIGestureRecognizerStateChanged == gesture.state) {
        CGPoint transition = [gesture translationInView:gesture.view];
        toView.center = CGPointMake(centerX + transition.x + width, fromView.center.y);
    } else {
        CGPoint transition = [gesture translationInView:gesture.view];
        if (-transition.x> distance) {
            toView.center = CGPointMake(centerX + transition.x + width, fromView.center.y);
            [UIView animateWithDuration:.3 animations:^{
                toView.center = CGPointMake(centerX, fromView.center.y);
            } completion:^(BOOL finished) {
                [self.sceneView.session pause];
            }];
        } else {
            toView.center = CGPointMake(centerX + transition.x - width, fromView.center.y);
            [UIView animateWithDuration:.3 animations:^{
                toView.center = CGPointMake(centerX-width, fromView.center.y);
            } completion:^(BOOL finished) {
                [toView removeFromSuperview];
            }];
        }
    }
}

#pragma mark - tap gesture method
- (void)addIVTapGRTap
{
    
}

- (void)homeIVTapGRTap
{
    if (self.homeCtrl == nil) {
        self.homeCtrl = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        self.homeCtrl.viewCtrlDelegate = self;
    }
    [self.view.superview addSubview:self.homeCtrl.view];
    self.homeCtrl.view.frame = CGRectMake(-width, 0, width, height);
    [UIView animateWithDuration:.3 animations:^{
        self.homeCtrl.view.frame = CGRectMake(0, 0, width, height);
        self.view.frame = CGRectMake(0, 0, width, height);
    } completion:^(BOOL finish){
        self.homeCtrl.view.frame = CGRectMake(0, 0, width, height);
        self.view.frame = CGRectMake(0, 0, width, height);
        [self.homeCtrl setSwipeType:SwipeOrScrollType_Default];
        [self.sceneView.session pause];
    }];
}

-(void)accountIVTapGRTap
{
    if (self.accountCtrl == nil) {
        self.accountCtrl = [[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil];
        self.accountCtrl.viewCtrlDelegate = self;
    }
    [self.view.superview addSubview:self.accountCtrl.view];
    self.accountCtrl.view.frame = CGRectMake(width, 0, width, height);
    [UIView animateWithDuration:.3 animations:^{
        self.accountCtrl.view.frame = CGRectMake(0, 0, width, height);
        self.view.frame = CGRectMake(-0, 0, width, height);
    } completion:^(BOOL finish){
        self.accountCtrl.view.frame = CGRectMake(0, 0, width, height);
        self.view.frame = CGRectMake(-0, 0, width, height);
        [self.sceneView.session pause];
    }];
}

- (void)exitIVTapGRTap
{
    [self initARScene];
}

#pragma mark - view change method
- (void)backToARPageFromHome
{
    self.homeCtrl.view.frame = CGRectMake(0, 0, width, height);
    self.view.frame = CGRectMake(width, 0, width, height);
    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
    configuration.planeDetection = ARPlaneDetectionHorizontal;
    [self.sceneView.session runWithConfiguration: configuration];
    [UIView animateWithDuration:.3 animations:^{
        self.homeCtrl.view.frame = CGRectMake(-width, 0, width, height);
        self.view.frame = CGRectMake(0, 0, width, height);
    } completion:^(BOOL finish){
        self.homeCtrl.view.frame = CGRectMake(-width, 0, width, height);
        self.view.frame = CGRectMake(0, 0, width, height);
        [self.homeCtrl.view removeFromSuperview];
    }];
}

- (void)backToARPageFromAccount
{
    self.accountCtrl.view.frame = CGRectMake(0, 0, width, height);
    self.view.frame = CGRectMake(-width, 0, width, height);
    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
    configuration.planeDetection = ARPlaneDetectionHorizontal;
    [self.sceneView.session runWithConfiguration: configuration];
    [UIView animateWithDuration:.3 animations:^{
        self.accountCtrl.view.frame = CGRectMake(width, 0, width, height);
        self.view.frame = CGRectMake(0, 0, width, height);
    } completion:^(BOOL finish){
        self.accountCtrl.view.frame = CGRectMake(width, 0, width, height);
        self.view.frame = CGRectMake(0, 0, width, height);
        [self.accountCtrl.view removeFromSuperview];
    }];
}

- (void)gotoAccountPageFromHome
{
    if (self.accountCtrl == nil) {
        self.accountCtrl = [[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil];
        self.accountCtrl.viewCtrlDelegate = self;
    }
    [self.view.superview addSubview:self.accountCtrl.view];
    self.homeCtrl.view.frame = CGRectMake(0, 0, width, height);
    self.accountCtrl.view.frame = CGRectMake(-width, 0, width, height);
    [UIView animateWithDuration:.3 animations:^{
        self.homeCtrl.view.frame = CGRectMake(width, 0, width, height);
        self.accountCtrl.view.frame = CGRectMake(0, 0, width, height);
    } completion:^(BOOL finish){
        self.homeCtrl.view.frame = CGRectMake(width, 0, width, height);
        self.accountCtrl.view.frame = CGRectMake(0, 0, width, height);
        [self.homeCtrl.view removeFromSuperview];
    }];
}

- (void)gotoHomePageFromAccount
{
    if (self.homeCtrl == nil) {
        self.homeCtrl = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        self.homeCtrl.viewCtrlDelegate = self;
    }
    [self.view.superview addSubview:self.homeCtrl.view];
    self.accountCtrl.view.frame = CGRectMake(0, 0, width, height);
    self.homeCtrl.view.frame = CGRectMake(width, 0, width, height);
    [UIView animateWithDuration:.3 animations:^{
        self.accountCtrl.view.frame = CGRectMake(-width, 0, width, height);
        self.homeCtrl.view.frame = CGRectMake(0, 0, width, height);
    } completion:^(BOOL finish){
        self.accountCtrl.view.frame = CGRectMake(-width, 0, width, height);
        self.homeCtrl.view.frame = CGRectMake(0, 0, width, height);
        [self.accountCtrl.view removeFromSuperview];
    }];
}

- (void)showARPageUnderView
{
    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
    configuration.planeDetection = ARPlaneDetectionHorizontal;
    [self.sceneView.session runWithConfiguration: configuration];
}

- (void)pauseARPageUnderView
{
    [self.sceneView.session pause];
}

#pragma mark - delegate methods
- (void)showPaneramaWith:(NSString*)string
{
    [self backToARPageFromHome];
    panameraViewImgString = [NSString stringWithString:string];
}

- (void)showPaneramaFromAccount:(NSString*)string
{
    [self backToARPageFromAccount];
    panameraViewImgString = [NSString stringWithString:string];
}

@end
