# SynchronizedScrollViews
Synchronizes the scrolling of two NSScrollViews.

https://github.com/usagimaru/SynchronizedScrollViews/assets/1835776/c5a08824-c8e3-48bb-a5da-fc2b5265d564

## Note 1

There is a problem that simply changing NSClipView.bounds does not synchronize the movement when bounced by trackpad input. The following methods all have this problem:

```swift
let newOffset: NSPoint = …
// A 👎
trackerScrollView.contentView.scroll(newOffset)
// B 👎
trackerScrollView.contentView.bounds.origin = newOffset
// C 👎
trackerScrollView.documentView?.scroll(newValue)
```

However, using NSScrollView’s [`scroll(_ clipView: NSClipView, to point: NSPoint)`](https://developer.apple.com/documentation/appkit/nsview/1531337-scroll) works perfectly. Use it for scrollview synchronization.

```swift
let newOffset: NSPoint = …
// D 👍
trackerScrollView.scroll(trackerScrollView.contentView, to: newOffset)

// And call it to adjust scrollers
trackerScrollView.reflectScrolledClipView(trackerScrollView.contentView)
```

## Note 2

I also tried bypassing [`scrollWheel(with: NSEvent)`](https://developer.apple.com/documentation/appkit/nsresponder/1534192-scrollwheel) event to another scroll view. However, this is very inaccurate and not practical for scroll synchronization. Frame rate drops and coordinates jump occasionally.