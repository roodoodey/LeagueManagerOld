//
//  MAXBlockSwitch.h
//  ReusableComponentsApp
//
//  Created by Mathieu Skulason on 02/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAXBlockSwitch : UISwitch

/**
 @description The block is called when the switch has been pressed.
 */
-(void)switchValueChangedWithCompletion:(void (^)(void))completion;

@end
