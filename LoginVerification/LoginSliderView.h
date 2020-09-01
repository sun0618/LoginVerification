//
//  LoginSliderView.h
//  LoginVerification
//
//  Created by yang.sun on 2020/8/28.
//  Copyright © 2020 sun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    ViewTypePuzzle = 0,
    ViewTypeRandomChar,
    ViewTypeSlider,
}ViewType;

NS_ASSUME_NONNULL_BEGIN

@interface LoginSliderView : UIView

-(void)show:(ViewType)viewType;

@end

NS_ASSUME_NONNULL_END
