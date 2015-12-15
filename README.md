### ROLControlPanel

A custom view like iOS  controller center and noti. Support swiping gesture.
![Screenshot](https://github.com/st0x8/ROLControlPanel/raw/master/ScreenShot/ScreenShot.gif)

### Feartures

- A drawer that can slide up and down. 
- Can add any other view upon this custom view.
- Can detect the drawer open and close.
- Not supporting rotation currently.

### Requirements
- iOS7.0 or later.
- ARC memory management.
- Disable rotation.

### How to use

Download and drag the ```ROLControlPanel``` folder into your Xcode project. 
 Then``` #import "ROLControlPanel.h"```. 

```
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    ROLControlPanel *panelView = [[ROLControlPanel alloc] initWithParentView:self.view];
    panelView.delegate = self;
    panelView.slideAnimationDuration = 0.5;//default is 0.33
    panelView.PanelCloseBlock = ^(void) {
        NSLog(@"Block panel close!");
    };
    panelView.PanelRevealBlock = ^(void) {
        NSLog(@"Block panel reveal!");
    };

```
## License

Usage is provided under the MIT License.  

Copyright (c) 2015 Roy Lin



Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:



The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.



THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.