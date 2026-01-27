import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class StatusListView extends WatchUi.View {

    private var _tflApi = new TflApi();
    private var _lineStatuses as Array<Dictionary>;
    private var _scrollOffset as Number;
    private var _selectedIndex as Number;
    private var _cardHeight as Number;

    function initialize() {
        View.initialize();
        _lineStatuses = [];
        _scrollOffset = 0;
        _selectedIndex = 0;
        _cardHeight = 80; // Height of each card
    }

    function drawStatusCard(dc as Dc, idx as Number) {
        var padding = 10;
        var width = dc.getWidth();
        var height = dc.getHeight();
        var cardWidth = width - (2 * padding);
        var yPos = (idx * (_cardHeight + padding)) - _scrollOffset + 10;
            
        // Only draw cards that are visible on screen
        if (yPos + _cardHeight < 0 || yPos > height) {
            return;
        }

        var statusDict = _lineStatuses[idx] as Dictionary;
        var isSelected = (idx == _selectedIndex);

        // Draw card background
        if (isSelected) {
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLUE);
        } else {
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_DK_GRAY);
        }
        dc.fillRoundedRectangle(padding, yPos, cardWidth, _cardHeight, 8);

        // Draw card border
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(padding, yPos, cardWidth, _cardHeight, 8);

        // Draw item title
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var title = statusDict["name"] != null ? statusDict["name"] : statusDict["title"];
        if (title != null) {
            dc.drawText(
                width / 2,
                yPos + 20,
                Graphics.FONT_SMALL,
                title,
                Graphics.TEXT_JUSTIFY_CENTER
            );
        }

        var statuses = statusDict["lineStatuses"] as Array<Dictionary>;

        // Draw item description or value
        var description = statuses[0]["statusSeverityDescription"];
        if (description != null) {
            var descText = description.toString();
            // Truncate if too long
            if (descText.length() > 25) {
                descText = descText.substring(0, 22) + "...";
            }
            dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                width / 2,
                yPos + 45,
                Graphics.FONT_XTINY,
                descText,
                Graphics.TEXT_JUSTIFY_CENTER
            );
        }
    }

    // Load your resources here
    function onLayout(dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        _tflApi.getModeLineStatuses(["tube"]);
    }

    function onUpdate(dc) {
        _lineStatuses = _tflApi.lineStatuses as Array<Dictionary>;
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        if (_lineStatuses == null || _lineStatuses.size() == 0) {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                dc.getWidth() / 2,
                dc.getHeight() / 2,
                Graphics.FONT_MEDIUM,
                "No statuses to display",
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
            );
            return;
        }

        var width = dc.getWidth();
        var height = dc.getHeight();
        var padding = 10;
        

        // Draw all cards
        for (var i = 0; i < _lineStatuses.size(); i++) {
            drawStatusCard(dc, i);
        }

        // Draw scroll indicator if needed
        var totalHeight = _lineStatuses.size() * (_cardHeight + padding);
        if (totalHeight > height) {
            var scrollBarHeight = height - 20;
            var scrollBarY = 10;
            var scrollBarX = width - 5;
            
            // Background of scroll bar
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawLine(scrollBarX, scrollBarY, scrollBarX, scrollBarY + scrollBarHeight);
            
            // Thumb position
            var thumbHeight = (height.toFloat() / totalHeight.toFloat()) * scrollBarHeight;
            var thumbY = scrollBarY + ((_scrollOffset.toFloat() / totalHeight.toFloat()) * scrollBarHeight);
            
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.fillRectangle(scrollBarX - 1, thumbY, 3, thumbHeight > 5 ? thumbHeight : 5);
        }
    }

    function scroll(amount) {
        var height = System.getDeviceSettings().screenHeight;
        var maxScroll = (_lineStatuses.size() * (_cardHeight + 10)) - height + 20;
        
        System.println("Scroll offset before scroll: " + _scrollOffset);

        _scrollOffset += amount;
        
        // Clamp scroll offset
        if (_scrollOffset < 0) {
            _scrollOffset = 0;
        }
        if (_scrollOffset > maxScroll) {
            _scrollOffset = maxScroll;
        }

        System.println("Scroll offset after scroll: " + _scrollOffset);
        
        // Update selected index based on what's centered on screen
        updateSelectedFromScroll(height);
        
        WatchUi.requestUpdate();
    }

    function updateSelectedFromScroll(height) {
        // Find which card is closest to the center of the screen
        var centerY = height / 2;
        var bestIndex = 0;
        var bestDistance = 99999;
        
        for (var i = 0; i < _lineStatuses.size(); i++) {
            var cardY = (i * (_cardHeight + 10)) - _scrollOffset + 10;
            var cardCenterY = cardY + (_cardHeight / 2);
            var distance = cardCenterY - centerY;
            if (distance < 0) {
                distance = -distance;
            }
            
            if (distance < bestDistance) {
                bestDistance = distance;
                bestIndex = i;
            }
        }
        
        _selectedIndex = bestIndex;
    }

    // function scrollDown() {
    //     var height = System.getDeviceSettings().screenHeight;
    //     var maxScroll = (_lineStatuses.size() * (_cardHeight + 10)) - height + 20;
        
    //     _scrollOffset += 30;
    //     if (_scrollOffset > maxScroll) {
    //         _scrollOffset = maxScroll;
    //     }
    //     WatchUi.requestUpdate();
    // }

    // function scrollUp() {
    //     _scrollOffset -= 30;
    //     if (_scrollOffset < 0) {
    //         _scrollOffset = 0;
    //     }
    //     WatchUi.requestUpdate();
    // }

    // function selectNext() {
    //     if (_selectedIndex < _lineStatuses.size() - 1) {
    //         _selectedIndex++;
            
    //         // Auto-scroll to keep selected item visible
    //         var height = System.getDeviceSettings().screenHeight;
    //         var selectedYPos = (_selectedIndex * (_cardHeight + 10)) - _scrollOffset;
            
    //         if (selectedYPos + _cardHeight > height - 20) {
    //             _scrollOffset += (_cardHeight + 10);
    //         }
            
    //         WatchUi.requestUpdate();
    //     }
    // }

    // function selectPrevious() {
    //     if (_selectedIndex > 0) {
    //         _selectedIndex--;
            
    //         // Auto-scroll to keep selected item visible
    //         var selectedYPos = (_selectedIndex * (_cardHeight + 10)) - _scrollOffset;
            
    //         if (selectedYPos < 10) {
    //             _scrollOffset -= (_cardHeight + 10);
    //             if (_scrollOffset < 0) {
    //                 _scrollOffset = 0;
    //             }
    //         }
            
    //         WatchUi.requestUpdate();
    //     }
    // }


    function getSelectedItem() {
        return _lineStatuses[_selectedIndex];
    }
}

class StatusListBehaviorDelegate extends WatchUi.BehaviorDelegate {
    private var _view;
    private var _lastDragY;

    function initialize(view) {
        BehaviorDelegate.initialize();
        _view = view;
        _lastDragY = null;
    }

    function onTap(clickEvent) {
        var selectedItem = _view.getSelectedItem() as Dictionary?;
        System.println("Selected: " + selectedItem["name"]);
        
        // Handle tap selection - navigate to detail view, etc.
        
        return true;
    }

    function onDrag(dragEvent) {
        var coords = dragEvent.getCoordinates();
        System.println("Drag event initiated at " + coords);
        var currentY = coords[1];  // Y coordinate
        var eventType = dragEvent.getType();
        
        if (eventType == DRAG_TYPE_START || _lastDragY == null) {
            _lastDragY = currentY;
        } else if (eventType == DRAG_TYPE_CONTINUE || eventType == DRAG_TYPE_STOP) {
            // Calculate how much the finger moved
            var deltaY = currentY - _lastDragY;

            // Debug: print to see what's happening
            System.println("currentY: " + currentY + ", lastY: " + _lastDragY + ", delta: " + deltaY);   

            // Scroll in the opposite direction of finger movement
            // (dragging down scrolls content up, revealing items below)
            _view.scroll(-deltaY);

            _lastDragY = currentY;
            
            if (eventType == DRAG_TYPE_STOP) {
                _lastDragY = null;
            }
        }  
        return true;
    }

    function onRelease(clickEvent) {
        // Reset drag tracking when finger is lifted
        System.println("Release detected!");
        _lastDragY = null;
        return true;
    }

    // function onSwipe(swipeEvent) {
    //     var direction = swipeEvent.getDirection();
    //     System.println("onSwipe detected");
        
    //     if (direction == WatchUi.SWIPE_UP) {
    //         _view.scroll(60);  // Scroll down (swipe up = content moves up)
    //         return true;
    //     } else if (direction == WatchUi.SWIPE_DOWN) {
    //         _view.scroll(-60);  // Scroll up (swipe down = content moves down)
    //         return true;
    //     }
        
    //     return false;
    // }

    // function onNextPage() {
    //     _view.selectNext();
    //     return true;
    // }

    // function onPreviousPage() {
    //     _view.selectPrevious();
    //     return true;
    // }

    // function onSelect() {
    //     var selectedItem = _view.getSelectedItem() as Dictionary?;
    //     System.println("Selected: " + selectedItem["name"]);
        
    //     // Handle selection - navigate to detail view, etc.
        
    //     return true;
    // }
}