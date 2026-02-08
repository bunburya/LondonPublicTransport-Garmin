import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Application;
import Toybox.Lang;

class StopPointArrivalsView extends WatchUi.View {
    private var _stopPointData as StopPointArrivals;
    private var _selectedIndex as Lang.Number = 0;

    private var _FONT_SIZE as Graphics.FontType = Graphics.FONT_XTINY;

    function initialize(stopId as String, stopName as String, data) {
        View.initialize();
        _stopPointData = new StopPointArrivals(stopId, stopName, data);
    }

    function setMessages(data) {
        _stopPointData = data;
        _selectedIndex = 0;
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();
        var screenShape = System.getDeviceSettings().screenShape;
        
        if (_stopPointData.arrivals.size() == 0) {
            dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                screenWidth / 2,
                screenHeight / 2,
                _FONT_SIZE,
                "No data",
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
            );
            return;
        }
        
        var centerX = screenWidth / 2;
        var centerY = screenHeight / 2;
        var lineHeight = dc.getFontHeight(_FONT_SIZE) + 5;
        
        // Calculate safe width for circular screens
        var textWidth = screenShape == System.SCREEN_SHAPE_ROUND ? 
            (screenWidth * 1).toNumber() : screenWidth - 20;
        
        // Draw up to 3 visible messages centered around the selected one
        var visibleCount = 3;
        var startIndex = _selectedIndex - 1;
        if (startIndex < 0) {
            startIndex = 0;
        }
        
        // Calculate starting Y position to center the selected item
        var startY = centerY - lineHeight;
        
        for (var i = 0; i < visibleCount; i++) {
            var arrIdx = startIndex + i;
            if (arrIdx >= _stopPointData.arrivals.size()) {
                break;
            }
            
            var yPos = startY + (i * lineHeight);
            var arrival = _stopPointData.arrivals[arrIdx];
            var isSelected = (arrIdx == _selectedIndex);
            
            // Truncate message if too long
            var truncatedMessage = truncateText(dc, arrival.toString(), textWidth, _FONT_SIZE);
            
            // Draw selection indicator and text
            if (isSelected) {
                // Highlight background for selected item
                dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_DK_GRAY);
                dc.fillRoundedRectangle(
                    centerX - textWidth / 2 - 5,
                    yPos - 2,
                    textWidth + 10,
                    lineHeight,
                    5
                );
                
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            } else {
                dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
            }
            
            dc.drawText(
                centerX,
                yPos,
                _FONT_SIZE,
                truncatedMessage,
                Graphics.TEXT_JUSTIFY_CENTER
            );
        }
        
        // Draw scroll indicators
        if (_selectedIndex > 0) {
            // Up arrow
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                centerX,
                10,
                Graphics.FONT_TINY,
                "▲",
                Graphics.TEXT_JUSTIFY_CENTER
            );
        }
        
        if (_selectedIndex < _stopPointData.arrivals.size() - 1) {
            // Down arrow
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                centerX,
                screenHeight - 20,
                Graphics.FONT_TINY,
                "▼",
                Graphics.TEXT_JUSTIFY_CENTER
            );
        }
        
        // Draw position indicator (e.g., "2/5")
        if (_stopPointData.arrivals.size() > 1) {
            var position = (_selectedIndex + 1) + "/" + _stopPointData.arrivals.size();
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                centerX,
                screenHeight - 35,
                Graphics.FONT_XTINY,
                position,
                Graphics.TEXT_JUSTIFY_CENTER
            );
        }
    }

    function truncateText(dc, text, maxWidth, font) {
        var textWidth = dc.getTextWidthInPixels(text, font);
        
        if (textWidth <= maxWidth) {
            return text;
        }
        
        // Truncate with ellipsis
        var truncated = text;
        while (textWidth > maxWidth && truncated.length() > 0) {
            truncated = truncated.substring(0, truncated.length() - 1);
            textWidth = dc.getTextWidthInPixels(truncated + "...", font);
        }
        
        return truncated + "...";
    }

    function scrollUp() {
        if (_selectedIndex > 0) {
            _selectedIndex--;
            WatchUi.requestUpdate();
        }
    }

    function scrollDown() {
        if (_selectedIndex < _stopPointData.arrivals.size() - 1) {
            _selectedIndex++;
            WatchUi.requestUpdate();
        }
    }

    function getSelectedMessage() {
        if (_selectedIndex >= 0 && _selectedIndex < _stopPointData.arrivals.size()) {
            return _stopPointData.arrivals[_selectedIndex];
        }
        return null;
    }
}

class MessageListDelegate extends WatchUi.BehaviorDelegate {
    private var _view;

    function initialize(view) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onNextPage() {
        _view.scrollDown();
        return true;
    }

    function onPreviousPage() {
        _view.scrollUp();
        return true;
    }

    function onSelect() {
        var message = _view.getSelectedMessage();
        if (message != null) {
            System.println("Selected: " + message);
            // Handle message selection here
            // Could open a detail view, trigger an action, etc.
        }
        return true;
    }

    function onSwipe(swipeEvent) {
        var direction = swipeEvent.getDirection();
        
        if (direction == WatchUi.SWIPE_UP) {
            _view.scrollDown();
            return true;
        } else if (direction == WatchUi.SWIPE_DOWN) {
            _view.scrollUp();
            return true;
        }
        
        return false;
    }
}
