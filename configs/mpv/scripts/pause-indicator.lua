local msg = require('mp.msg')
local log = {
  debug = function(format, ...)
    return msg.debug(format:format(...))
  end,
  info = function(format, ...)
    return msg.info(format:format(...))
  end,
  warn = function(format, ...)
    return msg.warn(format:format(...))
  end,
  dump = function(item, ignore)
    local level = 2
    if "table" ~= type(item) then
      msg.info(tostring(item))
      return 
    end
    local count = 1
    local tablecount = 1
    local result = {
      "{ @" .. tostring(tablecount)
    }
    local seen = {
      [item] = tablecount
    }
    local recurse
    recurse = function(item, space)
      for key, value in pairs(item) do
        if not (key == ignore) then
          if "table" == type(value) then
            if not (seen[value]) then
              tablecount = tablecount + 1
              seen[value] = tablecount
              count = count + 1
              result[count] = space .. tostring(key) .. ": { @" .. tostring(tablecount)
              recurse(value, space .. "  ")
              count = count + 1
              result[count] = space .. "}"
            else
              count = count + 1
              result[count] = space .. tostring(key) .. ": @" .. tostring(seen[value])
            end
          else
            if "string" == type(value) then
              value = ("%q"):format(value)
            end
            count = count + 1
            result[count] = space .. tostring(key) .. ": " .. tostring(value)
          end
        end
      end
    end
    recurse(item, "  ")
    count = count + 1
    result[count] = "}"
    return msg.info(table.concat(result, "\n"))
  end
}
local options = require('mp.options')
local utils = require('mp.utils')
local script_name = 'torque-progressbar'
mp.get_osd_size = mp.get_osd_size or mp.get_screen_size
local settings = {
  __defaults = { }
}
local settingsMeta = {
  __reload = function(self)
    for key, value in pairs(self.__defaults) do
      settings[key] = value
    end
    options.read_options(self, script_name .. '/main')
    if self['bar-height-inactive'] <= 0 then
      self['bar-hide-inactive'] = true
      self['bar-height-inactive'] = 1
    end
  end,
  __migrate = function(self)
    local oldConfig = mp.find_config_file(('lua-settings/%s.conf'):format(script_name))
    local newConfigFile = ('lua-settings/%s/main.conf'):format(script_name)
    local newConfig = mp.find_config_file(newConfigFile)
    if oldConfig and not newConfig then
      local folder, _ = utils.split_path(oldConfig)
      local configDir = utils.join_path(folder, script_name)
      newConfig = utils.join_path(configDir, 'main.conf')
      log.info(('Old configuration detected. Attempting to migrate %q -> %q'):format(oldConfig, newConfig))
      local dirExists = mp.find_config_file(configDir)
      if dirExists and not utils.readdir(configDir) then
        log.warn(('Configuration migration failed. %q exists and does not appear to be a folder'):format(configDir))
        return 
      else
        if not dirExists then
          local res = utils.subprocess({
            args = {
              'mkdir',
              configDir
            }
          })
          if res.error or res.status ~= 0 then
            log.warn(('Making directory %q failed.'):format(configDir))
            return 
          end
        end
      end
      local res = utils.subprocess({
        args = {
          'mv',
          oldConfig,
          newConfig
        }
      })
      if res.error or res.status ~= 0 then
        log.warn(('Moving file %q -> %q failed.'):format(oldConfig, newConfig))
        return 
      end
      if mp.find_config_file(newConfigFile) then
        return log.info('Configuration successfully migrated.')
      end
    end
  end,
  __newindex = function(self, key, value)
    self.__defaults[key] = value
    return rawset(self, key, value)
  end
}
settingsMeta.__index = settingsMeta
setmetatable(settings, settingsMeta)
settings:__migrate()
local helpText = { }
settings['hover-zone-height'] = 40
helpText['hover-zone-height'] = [[Sets the height of the rectangular area at the bottom of the screen that expands
the progress bar and shows playback time information when the mouse is hovered
over it.
]]
settings['top-hover-zone-height'] = 40
helpText['top-hover-zone-height'] = [[Sets the height of the rectangular area at the top of the screen that shows the
file name and system time when the mouse is hovered over it.
]]
settings['display-scale-factor'] = 1
helpText['display-scale-factor'] = [[Acts as a multiplier to increase the size of every UI element. Useful for high-
DPI displays that cause the UI to be rendered too small (happens at least on
macOS).
]]
settings['default-style'] = [[\fnSource Sans Pro\b1\bord2\shad0\fs30\c&HFC799E&\3c&H2D2D2D&]]
helpText['default-style'] = [[Default style that is applied to all UI elements. A string of ASS override tags.
Individual elements have their own style settings which override the tags here.
Changing the font will likely require changing the hover-time margin settings
and the offscreen-pos settings.

Here are some useful ASS override tags (omit square brackets):
\fn[Font Name]: sets the font to the named font.
\fs[number]: sets the font size to the given number.
\b[1/0]: sets the text bold or not (\b1 is bold, \b0 is regular weight).
\i[1/0]: sets the text italic or not (same semantics as bold).
\bord[number]: sets the outline width to the given number (in pixels).
\shad[number]: sets the shadow size to the given number (pixels).
\c&H[BBGGRR]&: sets the fill color for the text to the given color (hex pairs in
	             the order, blue, green, red).
\3c&H[BBGGRR]&: sets the outline color of the text to the given color.
\4c&H[BBGGRR]&: sets the shadow color of the text to the given color.
\alpha&H[AA]&: sets the line's transparency as a hex pair. 00 is fully opaque
               and FF is fully transparent. Some UI elements are composed of
               multiple layered lines, so adding transparency may not look good.
               For further granularity, \1a&H[AA]& controls the fill opacity,
               \3a&H[AA]& controls the outline opacity, and \4a&H[AA]& controls
               the shadow opacity.
]]
settings['enable-bar'] = true
helpText['enable-bar'] = [[Controls whether or not the progress bar is drawn at all. If this is disabled,
it also (naturally) disables the click-to-seek functionality.
]]
settings['bar-hide-inactive'] = false
helpText['bar-hide-inactive'] = [[Causes the bar to not be drawn unless the mouse is hovering over it or a
request-display call is active. This is somewhat redundant with setting bar-
height-inactive=0, except that it can allow for very rudimentary context-
sensitive behavior because it can be toggled at runtime. For example, by using
the binding `f cycle pause; script-binding progressbar/toggle-inactive-bar`, it
is possible to have the bar be persistently present only in windowed or
fullscreen contexts, depending on the default setting.
]]
settings['bar-height-inactive'] = 2
helpText['bar-height-inactive'] = [[Sets the height of the bar display when the mouse is not in the active zone and
there is no request-display active. A value of 0 or less will cause bar-hide-
inactive to be set to true and the bar height to be set to 1. This should result
in the desired behavior while avoiding annoying debug logging in mpv (libass
does not like zero-height objects).
]]
settings['bar-height-active'] = 8
helpText['bar-height-active'] = [[Sets the height of the bar display when the mouse is in the active zone or
request-display is active. There is no logic attached to this, so 0 or negative
values may have unexpected results.
]]
settings['progress-bar-width'] = 0
helpText['progress-bar-width'] = [[If greater than zero, changes the progress bar style to be a small segment
rather than a continuous bar and sets its width.
]]
settings['seek-precision'] = 'exact'
helpText['seek-precision'] = [[Affects precision of seeks due to clicks on the progress bar. Should be 'exact' or
'keyframes'. Exact is slightly slower, but won't jump around between two
different times when clicking in the same place.

Actually, this gets passed directly into the `seek` command, so the value can be
any of the arguments supported by mpv, though the ones above are the only ones
that really make sense.
]]
settings['bar-default-style'] = [[\bord0\shad0]]
helpText['bar-default-style'] = [[A string of ASS override tags that get applied to all three layers of the bar:
progress, cache, and background. You probably don't want to remove \bord0 unless
your default-style includes it.
]]
settings['bar-foreground-style'] = ''
helpText['bar-foreground-style'] = [[A string of ASS override tags that get applied only to the progress layer of the
bar.
]]
settings['bar-cache-style'] = [[\c&H515151&]]
helpText['bar-cache-style'] = [[A string of ASS override tags that get applied only to the cache layer of the
bar. The default sets only the color.
]]
settings['bar-background-style'] = [[\c&H2D2D2D&]]
helpText['bar-background-style'] = [[A string of ASS override tags that get applied only to the background layer of
the bar. The default sets only the color.
]]
settings['enable-elapsed-time'] = true
helpText['enable-elapsed-time'] = [[Sets whether or not the elapsed time is displayed at all.
]]
settings['elapsed-style'] = ''
helpText['elapsed-style'] = [[A string of ASS override tags that get applied only to the elapsed time display.
]]
settings['elapsed-left-margin'] = 4
helpText['elapsed-left-margin'] = [[Controls how far from the left edge of the window the elapsed time display is
positioned.
]]
settings['elapsed-bottom-margin'] = 0
helpText['elapsed-bottom-margin'] = [[Controls how far above the expanded progress bar the elapsed time display is
positioned.
]]
settings['enable-remaining-time'] = true
helpText['enable-remaining-time'] = [[Sets whether or not the remaining time is displayed at all.
]]
settings['remaining-style'] = ''
helpText['remaining-style'] = [[A string of ASS override tags that get applied only to the remaining time
display.
]]
settings['remaining-right-margin'] = 4
helpText['remaining-right-margin'] = [[Controls how far from the right edge of the window the remaining time display is
positioned.
]]
settings['remaining-bottom-margin'] = 0
helpText['remaining-bottom-margin'] = [[Controls how far above the expanded progress bar the remaining time display is
positioned.
]]
settings['enable-hover-time'] = true
helpText['enable-hover-time'] = [[Sets whether or not the calculated time corresponding to the mouse position
is displayed when the mouse hovers over the progress bar.
]]
settings['hover-time-style'] = [[\fs26]]
helpText['hover-time-style'] = [[A string of ASS override tags that get applied only to the hover time display.
Unfortunately, due to the way the hover time display is animated, alpha values
set here will be overridden. This is subject to change in future versions.
]]
settings['hover-time-left-margin'] = 120
helpText['hover-time-left-margin'] = [[Controls how close to the left edge of the window the hover time display can
get. If this value is too small, it will end up overlapping the elapsed time
display.
]]
settings['hover-time-right-margin'] = 130
helpText['hover-time-right-margin'] = [[Controls how close to the right edge of the window the hover time display can
get. If this value is too small, it will end up overlapping the remaining time
display.
]]
settings['hover-time-bottom-margin'] = 0
helpText['hover-time-bottom-margin'] = [[Controls how far above the expanded progress bar the remaining time display is
positioned.
]]
settings['enable-title'] = true
helpText['enable-title'] = [[Sets whether or not the video title is displayed at all.
]]
settings['title-style'] = ''
helpText['title-style'] = [[A string of ASS override tags that get applied only to the video title display.
]]
settings['title-left-margin'] = 4
helpText['title-left-margin'] = [[Controls how far from the left edge of the window the video title display is
positioned.
]]
settings['title-top-margin'] = 0
helpText['title-top-margin'] = [[Controls how far from the top edge of the window the video title display is
positioned.
]]
settings['title-print-to-cli'] = true
helpText['title-print-to-cli'] = [[Controls whether or not the script logs the video title and playlist position
to the console every time a new video starts.
]]
settings['enable-system-time'] = true
helpText['enable-system-time'] = [[Sets whether or not the system time is displayed at all.
]]
settings['system-time-style'] = ''
helpText['system-time-style'] = [[A string of ASS override tags that get applied only to the system time display.
]]
settings['system-time-format'] = '%H:%M'
helpText['system-time-format'] = [[Sets the format used for the system time display. This must be a strftime-
compatible format string.
]]
settings['system-time-right-margin'] = 4
helpText['system-time-right-margin'] = [[Controls how far from the right edge of the window the system time display is
positioned.
]]
settings['system-time-top-margin'] = 0
helpText['system-time-top-margin'] = [[Controls how far from the top edge of the window the system time display is
positioned.
]]
settings['pause-indicator'] = true
helpText['pause-indicator'] = [[Sets whether or not the pause indicator is displayed. The pause indicator is a
momentary icon that flashes in the middle of the screen, similar to youtube.
]]
settings['pause-indicator-foreground-style'] = [[\c&HFC799E&]]
helpText['pause-indicator-foreground-style'] = [[A string of ASS override tags that get applied only to the foreground of the
pause indicator.
]]
settings['pause-indicator-background-style'] = [[\c&H2D2D2D&]]
helpText['pause-indicator-background-style'] = [[A string of ASS override tags that get applied only to the background of the
pause indicator.
]]
settings['enable-chapter-markers'] = true
helpText['enable-chapter-markers'] = [[Sets whether or not the progress bar is decorated with chapter markers. Due to
the way the chapter markers are currently implemented, videos with a large
number of chapters may slow down the script somewhat, but I have yet to run
into this being a problem.
]]
settings['chapter-marker-width'] = 2
helpText['chapter-marker-width'] = [[Controls the width of each chapter marker when the progress bar is inactive.
]]
settings['chapter-marker-width-active'] = 4
helpText['chapter-marker-width-active'] = [[Controls the width of each chapter marker when the progress bar is active.
]]
settings['chapter-marker-active-height-fraction'] = 1
helpText['chapter-marker-active-height-fraction'] = [[Modifies the height of the chapter markers when the progress bar is active. Acts
as a multiplier on the height of the active progress bar. A value greater than 1
will cause the markers to be taller than the expanded progress bar, whereas a
value less than 1 will cause them to be shorter.
]]
settings['chapter-marker-before-style'] = [[\c&HFC799E&]]
helpText['chapter-marker-before-style'] = [[A string of ASS override tags that get applied only to chapter markers that have
not yet been passed.
]]
settings['chapter-marker-after-style'] = [[\c&H2D2D2D&]]
helpText['chapter-marker-after-style'] = [[A string of ASS override tags that get applied only to chapter markers that have
already been passed.
]]
settings['request-display-duration'] = 1
helpText['request-display-duration'] = [[Sets the amount of time in seconds that the UI stays on the screen after it
receives a request-display signal. A value of 0 will keep the display on screen
only as long as the key bound to it is held down.
]]
settings['redraw-period'] = 0.03
helpText['redraw-period'] = [[Controls how often the display is redrawn, in seconds. This does not seem to
significantly affect the smoothness of animations, and it is subject to the
accuracy limits imposed by the scheduler mpv uses. Probably not worth changing
unless you have major performance problems.
]]
settings['animation-duration'] = 0.25
helpText['animation-duration'] = [[Controls how long the UI animations take. A value of 0 disables all animations
(which breaks the pause indicator).
]]
settings['elapsed-offscreen-pos'] = -100
helpText['elapsed-offscreen-pos'] = [[Controls how far off the left side of the window the elapsed time display tries
to move when it is inactive. If you use a non-default font, this value may need
to be tweaked. If this value is not far enough off-screen, the elapsed display
will disappear without animating all the way off-screen. Positive values will
cause the display to animate the wrong direction.
]]
settings['remaining-offscreen-pos'] = -100
helpText['remaining-offscreen-pos'] = [[Controls how far off the left side of the window the remaining time display
tries to move when it is inactive. If you use a non-default font, this value may
need to be tweaked. If this value is not far enough off-screen, the elapsed
display will disappear without animating all the way off-screen. Positive values
will cause the display to animate the wrong direction.
]]
settings['hover-time-offscreen-pos'] = -50
helpText['hover-time-offscreen-pos'] = [[Controls how far off the bottom of the window the mouse hover time display tries
to move when it is inactive. If you use a non-default font, this value may need
to be tweaked. If this value is not far enough off-screen, the elapsed
display will disappear without animating all the way off-screen. Positive values
will cause the display to animate the wrong direction.
]]
settings['system-time-offscreen-pos'] = -100
helpText['system-time-offscreen-pos'] = [[Controls how far off the left side of the window the system time display tries
to move when it is inactive. If you use a non-default font, this value may need
to be tweaked. If this value is not far enough off-screen, the elapsed display
will disappear without animating all the way off-screen. Positive values will
cause the display to animate the wrong direction.
]]
settings['title-offscreen-pos'] = -40
helpText['title-offscreen-pos'] = [[Controls how far off the left side of the window the video title display tries
to move when it is inactive. If you use a non-default font, this value may need
to be tweaked. If this value is not far enough off-screen, the elapsed display
will disappear without animating all the way off-screen. Positive values will
cause the display to animate the wrong direction.
]]
settings:__reload()
local Stack
do
  local _class_0
  local removeElementMetadata, reindex
  local _base_0 = {
    insert = function(self, element, index)
      if index then
        table.insert(self, index, element)
        element[self] = index
      else
        table.insert(self, element)
        element[self] = #self
      end
      if self.containmentKey then
        element[self.containmentKey] = true
      end
    end,
    remove = function(self, element)
      if element[self] == nil then
        error("Trying to remove an element that doesn't exist in this stack.")
      end
      table.remove(self, element[self])
      reindex(self, element[self])
      return removeElementMetadata(self, element)
    end,
    clear = function(self)
      local element = table.remove(self)
      while element do
        removeElementMetadata(self, element)
        element = table.remove(self)
      end
    end,
    removeSortedList = function(self, elementList)
      if #elementList < 1 then
        return 
      end
      for i = 1, #elementList - 1 do
        local element = table.remove(elementList)
        table.remove(self, element[self])
        removeElementMetadata(self, element)
      end
      local lastElement = table.remove(elementList)
      table.remove(self, lastElement[self])
      reindex(self, lastElement[self])
      return removeElementMetadata(self, lastElement)
    end,
    removeList = function(self, elementList)
      table.sort(elementList, function(a, b)
        return a[self] < b[self]
      end)
      return self:removeSortedList(elementList)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, containmentKey)
      self.containmentKey = containmentKey
    end,
    __base = _base_0,
    __name = "Stack"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  removeElementMetadata = function(self, element)
    element[self] = nil
    if self.containmentKey then
      element[self.containmentKey] = false
    end
  end
  reindex = function(self, start)
    if start == nil then
      start = 1
    end
    for i = start, #self do
      (self[i])[self] = i
    end
  end
  Stack = _class_0
end
local Window
do
  local _class_0
  local osdScale
  local _base_0 = { }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "Window"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  osdScale = settings['display-scale-factor']
  self.__class.w, self.__class.h = 0, 0
  self.update = function(self)
    local w, h = mp.get_osd_size()
    w, h = math.floor(w / osdScale), math.floor(h / osdScale)
    if w ~= self.w or h ~= self.h then
      self.w, self.h = w, h
      return true
    else
      return false
    end
  end
  Window = _class_0
end
local Rect
do
  local _class_0
  local _base_0 = {
    cacheMaxBounds = function(self)
      self.xMax = self.x + self.w
      self.yMax = self.y + self.h
    end,
    setPosition = function(self, x, y)
      self.x = x or self.x
      self.y = y or self.y
      return self:cacheMaxBounds()
    end,
    setSize = function(self, w, h)
      self.w = w or self.w
      self.h = h or self.h
      return self:cacheMaxBounds()
    end,
    reset = function(self, x, y, w, h)
      self.x = x or self.x
      self.y = y or self.y
      self.w = w or self.w
      self.h = h or self.h
      return self:cacheMaxBounds()
    end,
    move = function(self, x, y)
      self.x = self.x + (x or self.x)
      self.y = self.y + (y or self.y)
      return self:cacheMaxBounds()
    end,
    stretch = function(self, w, h)
      self.w = self.w + (w or self.w)
      self.h = self.h + (h or self.h)
      return self:cacheMaxBounds()
    end,
    containsPoint = function(self, x, y)
      return (x >= self.x) and (x < self.xMax) and (y >= self.y) and (y < self.yMax)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, w, h)
      if x == nil then
        x = -1
      end
      if y == nil then
        y = -1
      end
      if w == nil then
        w = -1
      end
      if h == nil then
        h = -1
      end
      self.x, self.y, self.w, self.h = x, y, w, h
      return self:cacheMaxBounds()
    end,
    __base = _base_0,
    __name = "Rect"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Rect = _class_0
end
local AnimationQueue
do
  local _class_0
  local animationList, deletionQueue
  local _base_0 = { }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "AnimationQueue"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  animationList = Stack('active')
  deletionQueue = { }
  self.addAnimation = function(animation)
    if not (animation.active) then
      return animationList:insert(animation)
    end
  end
  self.removeAnimation = function(animation)
    if animation.active then
      return animationList:remove(animation)
    end
  end
  self.destroyAnimationStack = function()
    return animationList:clear()
  end
  self.animate = function()
    if #animationList == 0 then
      return 
    end
    local currentTime = mp.get_time()
    for _, animation in ipairs(animationList) do
      if animation:update(currentTime) then
        table.insert(deletionQueue, animation)
      end
    end
    if #deletionQueue > 0 then
      return animationList:removeSortedList(deletionQueue)
    end
  end
  self.active = function()
    return #animationList > 0
  end
  AnimationQueue = _class_0
end
local EventLoop
do
  local _class_0
  local _base_0 = {
    reconfigure = function(self)
      settings:__reload()
      AnimationQueue.destroyAnimationStack()
      for _, zone in ipairs(self.activityZones) do
        zone:reconfigure()
      end
      for _, element in ipairs(self.uiElements) do
        element:reconfigure()
      end
    end,
    addZone = function(self, zone)
      if zone == nil then
        return 
      end
      return self.activityZones:insert(zone)
    end,
    removeZone = function(self, zone)
      if zone == nil then
        return 
      end
      return self.activityZones:remove(zone)
    end,
    generateUIFromZones = function(self)
      local seenUIElements = { }
      self.script = { }
      self.uiElements:clear()
      AnimationQueue.destroyAnimationStack()
      for _, zone in ipairs(self.activityZones) do
        for _, uiElement in ipairs(zone.elements) do
          if not (seenUIElements[uiElement]) then
            self:addUIElement(uiElement)
            seenUIElements[uiElement] = true
          end
        end
      end
      return self.updateTimer:resume()
    end,
    addUIElement = function(self, uiElement)
      if uiElement == nil then
        error('nil UIElement added.')
      end
      self.uiElements:insert(uiElement)
      return table.insert(self.script, '')
    end,
    removeUIElement = function(self, uiElement)
      if uiElement == nil then
        error('nil UIElement removed.')
      end
      table.remove(self.script, uiElement[self.uiElements])
      return self.uiElements:remove(uiElement)
    end,
    resize = function(self)
      for _, zone in ipairs(self.activityZones) do
        zone:resize()
      end
      for _, uiElement in ipairs(self.uiElements) do
        uiElement:resize()
      end
    end,
    redraw = function(self, forceRedraw)
      if Window:update() then
        self:resize()
      end
      for index, zone in ipairs(self.activityZones) do
        zone:update(self.displayRequested, false)
      end
      AnimationQueue.animate()
      for index, uiElement in ipairs(self.uiElements) do
        if uiElement:redraw() then
          self.script[index] = uiElement:stringify()
        end
      end
      return mp.set_osd_ass(Window.w, Window.h, table.concat(self.script, '\n'))
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.script = { }
      self.uiElements = Stack()
      self.activityZones = Stack()
      self.displayRequested = false
      self.updateTimer = mp.add_periodic_timer(settings['redraw-period'], (function()
        local _base_1 = self
        local _fn_0 = _base_1.redraw
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)())
      self.updateTimer:stop()
      mp.register_event('shutdown', function()
        return self.updateTimer:kill()
      end)
      local displayRequestTimer
      local displayDuration = settings['request-display-duration']
      mp.add_key_binding("tab", "request-display", function(event)
        if event.event == "repeat" then
          return 
        end
        if event.event == "down" or event.event == "press" then
          if displayRequestTimer then
            displayRequestTimer:kill()
          end
          self.displayRequested = true
        end
        if event.event == "up" or event.event == "press" then
          if displayDuration == 0 then
            self.displayRequested = false
          else
            displayRequestTimer = mp.add_timeout(displayDuration, function()
              self.displayRequested = false
            end)
          end
        end
      end, {
        complex = true
      })
      return mp.add_key_binding('ctrl+r', 'reconfigure', (function()
        local _base_1 = self
        local _fn_0 = _base_1.reconfigure
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)(), {
        repeatable = false
      })
    end,
    __base = _base_0,
    __name = "EventLoop"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  EventLoop = _class_0
end
local Animation
do
  local _class_0
  local _base_0 = {
    update = function(self, now)
      if self.isReversed then
        self.linearProgress = math.max(0, math.min(1, self.linearProgress + (self.lastUpdate - now) * self.durationR))
        if self.linearProgress == 0 then
          self.isFinished = true
        end
      else
        self.linearProgress = math.max(0, math.min(1, self.linearProgress + (now - self.lastUpdate) * self.durationR))
        if self.linearProgress == 1 then
          self.isFinished = true
        end
      end
      self.lastUpdate = now
      local progress = math.pow(self.linearProgress, self.accel)
      self.value = (1 - progress) * self.initialValue + progress * self.endValue
      self.updateCb(self.value)
      if self.isFinished and self.finishedCb then
        self:finishedCb()
      end
      return self.isFinished
    end,
    interrupt = function(self, reverse)
      self.finishedCb = nil
      self.lastUpdate = mp.get_time()
      self.isReversed = reverse
      if not (self.active) then
        self.isFinished = false
        return AnimationQueue.addAnimation(self)
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, initialValue, endValue, duration, updateCb, finishedCb, accel)
      if accel == nil then
        accel = 1
      end
      self.initialValue, self.endValue, self.duration, self.updateCb, self.finishedCb, self.accel = initialValue, endValue, duration, updateCb, finishedCb, accel
      self.value = self.initialValue
      self.linearProgress = 0
      self.lastUpdate = mp.get_time()
      self.durationR = 1 / self.duration
      self.isFinished = (self.duration <= 0)
      self.active = false
      self.isReversed = false
    end,
    __base = _base_0,
    __name = "Animation"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Animation = _class_0
end
local UIElement
do
  local _class_0
  local _base_0 = {
    stringify = function(self)
      self.needsUpdate = false
      if not self.active then
        return ''
      else
        return table.concat(self.line)
      end
    end,
    activate = function(self, activate)
      if activate == true then
        self.animation:interrupt(false)
        self.active = true
      else
        self.animation:interrupt(true)
        self.animation.finishedCb = function()
          self.active = false
        end
      end
    end,
    reconfigure = function(self)
      self.needsUpdate = true
      self.animationDuration = settings['animation-duration']
    end,
    resize = function(self)
      return error('UIElement updateSize called')
    end,
    redraw = function(self)
      return self.needsUpdate
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.needsUpdate = false
      self.active = false
      self.animationDuration = settings['animation-duration']
    end,
    __base = _base_0,
    __name = "UIElement"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  UIElement = _class_0
end
local PauseIndicator
do
  local _class_0
  local _base_0 = {
    stringify = function(self)
      return table.concat(self.line)
    end,
    resize = function(self)
      local w, h = 0.5 * Window.w, 0.5 * Window.h
      self.line[5] = ([[%g,%g]]):format(w, h)
      self.line[12] = ([[%g,%g]]):format(w, h)
    end,
    redraw = function()
      return true
    end,
    animate = function(self, value)
      local scale = value * 50 + 100
      local scaleStr = ([[{\fscx%g\fscy%g]]):format(scale, scale)
      local alphaStr = ('%02X'):format(value * value * 255)
      self.line[1] = scaleStr
      self.line[8] = scaleStr
      self.line[3] = alphaStr
      self.line[10] = alphaStr
    end,
    destroy = function(self, animation)
      return self.eventLoop:removeUIElement(self)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, eventLoop, paused)
      self.eventLoop = eventLoop
      local w, h = 0.5 * Window.w, 0.5 * Window.h
      self.line = {
        [[{\fscx0\fscy0]],
        [[\alpha&H]],
        0,
        [[&\pos(]],
        ([[%g,%g]]):format(w, h),
        ([[)\an5\bord0%s\p1}]]):format(settings['pause-indicator-background-style']),
        0,
        [[{\fscx0\fscy0]],
        [[\alpha&H]],
        0,
        [[&\pos(]],
        ([[%g,%g]]):format(w, h),
        ([[)\an5\bord0%s\p1}]]):format(settings['pause-indicator-foreground-style']),
        0
      }
      if paused then
        self.line[7] = 'm 75 37.5 b 75 58.21 58.21 75 37.5 75 16.79 75 0 58.21 0 37.5 0 16.79 16.79 0 37.5 0 58.21 0 75 16.79 75 37.5 m 23 20 l 23 55 33 55 33 20 m 42 20 l 42 55 52 55 52 20\n'
        self.line[14] = 'm 0 0 m 75 75 m 23 20 l 23 55 33 55 33 20 m 42 20 l 42 55 52 55 52 20'
      else
        self.line[7] = 'm 75 37.5 b 75 58.21 58.21 75 37.5 75 16.79 75 0 58.21 0 37.5 0 16.79 16.79 0 37.5 0 58.21 0 75 16.79 75 37.5 m 25.8333 17.18 l 25.8333 57.6 60.8333 37.39\n'
        self.line[14] = 'm 0 0 m 75 75 m 25.8333 17.18 l 25.8333 57.6 60.8333 37.39'
      end
      AnimationQueue.addAnimation(Animation(0, 1, settings['animation-duration'], (function()
        local _base_1 = self
        local _fn_0 = _base_1.animate
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)(), (function()
        local _base_1 = self
        local _fn_0 = _base_1.destroy
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)()))
      return self.eventLoop:addUIElement(self)
    end,
    __base = _base_0,
    __name = "PauseIndicator"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  PauseIndicator = _class_0
end
local eventLoop = EventLoop()
local notFrameStepping = false
if settings['pause-indicator'] then
  local PauseIndicatorWrapper
  PauseIndicatorWrapper = function(event, paused)
    if notFrameStepping then
      return PauseIndicator(eventLoop, paused)
    elseif paused then
      notFrameStepping = true
    end
  end
  mp.add_key_binding('.', 'step-forward', function()
    notFrameStepping = false
    return mp.commandv('frame_step')
  end, {
    repeatable = true
  })
  mp.add_key_binding(',', 'step-backward', function()
    notFrameStepping = false
    return mp.commandv('frame_back_step')
  end, {
    repeatable = true
  })
  mp.observe_property('pause', 'bool', PauseIndicatorWrapper)
end
local initDraw
initDraw = function()
  mp.unregister_event(initDraw)
  notFrameStepping = true
  eventLoop:resize()
  eventLoop:redraw()
  return eventLoop.updateTimer:resume()
end
local fileLoaded
fileLoaded = function()
  return mp.register_event('playback-restart', initDraw)
end
return mp.register_event('file-loaded', fileLoaded)
