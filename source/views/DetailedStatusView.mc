import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;

// Factory that creates text pages
class DetailedStatusViewFactory extends WatchUi.ViewLoopFactory {
    private var _statuses as Array<LineStatus>;

    function initialize(statusData as LineStatusData) {
        ViewLoopFactory.initialize();
        _statuses = statusData.statuses; 
    }

    function getSize() {
        return _statuses.size();
    }

    function getView(idx as Number) {
        var lineStatus = _statuses[idx];
        
        var view = new DetailedStatusView(lineStatus);
        var delegate = new DetailedStatusViewDelegate(view);
        return [view, delegate];
    }
}

class DetailedStatusView extends WatchUi.View {
    //private var _status as LineStatus;
    private var _header as Lang.String;
    private var _headerColor as Number;
    private var _body as Lang.String;

    // Space above the header
    private var _headerTopMargin as Lang.Number = 35; 
    // Space below the body
    private var _bodyBottomMargin as Lang.Number = 35;  
    // Portion of screen to use for body text (should be between 0 and 1)
    private var _widthMultiplier as Lang.Float = 0.8;
    // Additional margin to apply to sides of body text
    private var _bodySideMargin as Lang.Number = 10;

    private var _headerFontSize as Graphics.FontType = Graphics.FONT_SYSTEM_TINY;
    private var _bodyFontSize as Graphics.FontType = Graphics.FONT_SYSTEM_XTINY;


    // Below values are initialised later
    private var _screenHeight as Lang.Number = 0;
    private var _screenWidth as Lang.Number = 0;
    private var _scrollOffset as Lang.Number = 0;
    private var _maxScrollOffset as Lang.Number = 0;
    private var _separatorY as Lang.Number = 0;
    private var _bodyYStart as Lang.Number = 0;
    private var _bodyHeight as Lang.Number = 0;
    private var _lineHeight as Lang.Number = 0;
    private var _wrappedLines as Lang.Array = [];

    function initialize(status as LineStatus) {
        View.initialize();
        //_status = status;
        _header = status.description;
        if (status.reason != null) {
            _body = status.reason;
        } else {
            _body = "No further information available.";
        }
        _headerColor = status.color();
    }

    function onLayout(dc) {
        _screenWidth = dc.getWidth();
        _screenHeight = dc.getHeight();
        var screenShape = System.getDeviceSettings().screenShape;
        
        // Calculate safe area for circular screens
        var safeWidth;
        if (screenShape == System.SCREEN_SHAPE_ROUND) {
            safeWidth = (_screenWidth * _widthMultiplier).toNumber();
        } else {
            safeWidth = _screenWidth - (_bodySideMargin * 2);
        }
        
        // Header positioning - leave room at top
        var headerFontHeight = dc.getFontHeight(_headerFontSize);
        _separatorY = _headerTopMargin + headerFontHeight + 5;
        
        // Body starts after separator with some spacing
        _bodyYStart = _separatorY + 10;
        _bodyHeight = _screenHeight - _bodyYStart - 10 - _bodyBottomMargin;

        // Calculate line height for body text
        _lineHeight = dc.getFontHeight(_bodyFontSize);
        
        // Wrap text into lines
        _wrappedLines = wrapText(dc, _body, safeWidth, _bodyFontSize);
        
        // Calculate max scroll offset
        var totalTextHeight = _wrappedLines.size() * _lineHeight;
        _maxScrollOffset = totalTextHeight - _bodyHeight;
        if (_maxScrollOffset < 0) {
            _maxScrollOffset = 0;
        }
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        var screenWidth = dc.getWidth();
        var screenShape = System.getDeviceSettings().screenShape;
        
        var centerX = screenWidth / 2;
        
        // Draw header
        dc.setColor(_headerColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            centerX,
            _headerTopMargin,
            _headerFontSize,
            _header,
            Graphics.TEXT_JUSTIFY_CENTER
        );

        // Draw separator line
        var lineMargin = screenShape == System.SCREEN_SHAPE_ROUND ? 
            (screenWidth * 0.25 / 2).toNumber() : 10;
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(lineMargin, _separatorY, screenWidth - lineMargin, _separatorY);

        // Set clipping region for body text
        dc.setClip(0, _bodyYStart, screenWidth, _bodyHeight);
        
        // Draw body text lines
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        var currentY = _bodyYStart - _scrollOffset;
        
        for (var i = 0; i < _wrappedLines.size(); i++) {
            // Only draw lines that are visible
            if (currentY + _lineHeight >= _bodyYStart && 
                currentY <= _bodyYStart + _bodyHeight) {
                dc.drawText(
                    centerX,
                    currentY,
                    _bodyFontSize,
                    _wrappedLines[i],
                    Graphics.TEXT_JUSTIFY_CENTER
                );
            }
            currentY += _lineHeight;
        }
        
        // Clear clipping
        dc.clearClip();
        
        // Draw scroll indicator if needed
        if (_maxScrollOffset > 0) {
            drawScrollIndicator(dc);
        }
    }

    function drawScrollIndicator(dc) {
        
        var scrollBarX = _screenWidth - 5;
        var scrollBarY = _bodyYStart + 5;
        var scrollBarHeight = _bodyHeight - 10;
        
        // Background
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(scrollBarX, scrollBarY, scrollBarX, scrollBarY + scrollBarHeight);
        
        // Thumb
        var scrollPercent = _scrollOffset.toFloat() / _maxScrollOffset.toFloat();
        var thumbHeight = 20;
        var thumbY = scrollBarY + (scrollPercent * (scrollBarHeight - thumbHeight));
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(scrollBarX - 1, thumbY, 3, thumbHeight);
    }

    function wrapText(dc, text, maxWidth, font) {
        var words = splitString(text, " ");
        var lines = [];
        var currentLine = "";
        
        for (var i = 0; i < words.size(); i++) {
            var testLine = currentLine.length() > 0 ? currentLine + " " + words[i] : words[i];
            var testWidth = dc.getTextWidthInPixels(testLine, font);
            
            if (testWidth > maxWidth && currentLine.length() > 0) {
                lines.add(currentLine);
                currentLine = words[i];
            } else {
                currentLine = testLine;
            }
        }
        
        if (currentLine.length() > 0) {
            lines.add(currentLine);
        }
        
        return lines;
    }

    function scroll(amount) {
        _scrollOffset += amount;
        
        if (_scrollOffset < 0) {
            _scrollOffset = 0;
        }
        if (_scrollOffset > _maxScrollOffset) {
            _scrollOffset = _maxScrollOffset;
        }
        
        WatchUi.requestUpdate();
    }

    function smallScroll(y as Number) {
        if (y < _screenHeight / 2) {
            scroll(-30);
        } else {
            scroll(30);
        }
    }

    function pageDown() {
        // Scroll down by the visible body height (page down)
        scroll(_bodyHeight);
    }
    
    function pageUp() {
        // Scroll up by the visible body height (page up)
        scroll(-_bodyHeight);
    }

    function canScrollDown() {
        return _scrollOffset < _maxScrollOffset;
    }

    function canScrollUp() {
        return _scrollOffset > 0;
    }
}

class DetailedStatusViewDelegate extends WatchUi.BehaviorDelegate {
    private var _view as DetailedStatusView;

    function initialize(view) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onNextPage() {
        System.print("onNextPage ");
        if (_view.canScrollDown()) {
            _view.pageDown();
            System.println("handled");
            return true;
        } else {
            System.println("not handled");
            return false;
        }
    }

    function onPreviousPage() {
        System.print("onPreviousPage ");
        if (_view.canScrollUp()) {
            _view.pageUp();
            System.println("handled");
            return true;
        } else {
            System.println("not handled");
            return false;
        }
    }

    function onSwipe(swipeEvent) {
        var direction = swipeEvent.getDirection();

        System.print("onSwipe ");
        
        if (direction == WatchUi.SWIPE_UP && _view.canScrollDown()) {
            _view.pageDown();
            System.println("handled");
            return true;
        } else if (direction == WatchUi.SWIPE_DOWN && _view.canScrollUp()) {
            _view.pageUp();
            System.println("handled");
            return true;
        } else if (direction == WatchUi.SWIPE_RIGHT) {
            WatchUi.popView(WatchUi.SLIDE_RIGHT);
            System.println("handled");
            return true;
        }
        System.println("not handled");
        return false;
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }

    function onTap(clickEvent as ClickEvent) as Boolean {
        var y = clickEvent.getCoordinates()[1];
        _view.smallScroll(y);
        return true;
    }
}