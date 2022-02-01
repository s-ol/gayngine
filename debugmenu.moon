{ graphics: lg, keyboard: lk, filesystem: lf } = love

require "imgui"
ffi = require "ffi"
Vector = require "lib.hump.vector"

export DIALOGUE

coolstring = do
  (val) ->
    switch type val
      when "function"
        { :name, :short_src, :linedefined } = debug.getinfo val
        file = (short_src or "")\match ".?/?(.*)"
        file = file\match("(.*)%.lua") or file\match("(.*)%.moon") or file
        "<F:#{name or linedefined}:#{file}>"
      when "string"
        "\"#{val}\""
      else
        tostring val

SCENES = {}
for dir in *lf.getDirectoryItems "game/scenes"
  if lf.getInfo "game/scenes/#{dir}", "directory"
    SCENES[dir] = {}
    for file in *lf.getDirectoryItems "game/scenes/#{dir}"
      if scene = file\match "(.*)%.psd$"
        table.insert SCENES[dir], scene

    SCENES[dir] = nil if not next SCENES[dir]

class Console
  new: =>
    log = (...) ->
      a = {...}

      @add {
        text: table.concat a, "  "
        type: "debug",
        interactive: true,
      }

    help = ->
      @add {
        text: "
Just type lua.

Useful functions and variables:

SCENE
T.player    - alias for SCENE.tags.player
I.slot      - alias for SCENE.instances.slot
S           - alias for debugger node selection
log, print  - print to Console
help        - this text
",
      type: "debug",
      interactive: true,
    }

    @history = {}
    @log = {}
    @env = setmetatable {
      :log, :help,
      print: log,
    }, __index: (key) =>
      switch key
        when "T" then SCENE.tags
        when "I" then SCENE.instances
        when "S" then DEBUG.selected_node
        else _G[key]

    @filter = warn: true, error: true, input: true

  submit: =>
    table.insert @history, @buffer
    table.insert @log, {
      text: "# #{@buffer}",
      type: "input",
    }
    @history.index = nil

    unless @buffer\match("^[^%s]+%s*=") or @buffer\match("for") or @buffer\match "while"
      @buffer = "return " .. @buffer

    f, err = loadstring @buffer
    @buffer = nil

    local out
    if f
      out = { pcall setfenv f, @env }

      err = out[2] if not out[1]

    if err
      table.insert @log, {
        text: err
        type: "error"
        interactive: true,
      }

      return ret

    table.remove out, 1

    out = [coolstring val for val in *out]
    out = { "nil" } if #out == 0

    table.insert @log, {
      text: "=> " .. table.concat out, ", "
      type: "debug",
      interactive: true,
    }

  add: (entry) =>
    last = @log[#@log]
    if last and last.text == entry.text and last.type == entry.type
      last.number = (last.number or 1) + 1
      return

    table.insert @log, entry

  keypressed: (key) =>
    return unless @typing and #@history > 0

    switch key
      when "up"
        if @history.index
          @history.index = math.max 1, @history.index - 1
        else
          if @buffer and @buffer != ""
            @history.stash = @buffer
          @history.index = #@history

        @buffer = @history[@history.index]
        @set_focus = true

      when "down"
        if @history.index
          if @history.index == #@history
            @buffer = @history.stash
            @history.index = nil
          else
            @history.index = math.min #@history, @history.index + 1
            @buffer = @history[@history.index]
        @set_focus = true

  colors =
    input: { 1, 1, 1, 1 },
    debug: { .7, .7, .7, 1 },
    warn: { .7, .7, 0, 1 },
    error: { .7, 0, 0, 1 },

  draw: =>
    imgui.SetNextWindowSize 520, 600, "FirstUseEver"
    ret = imgui.Begin "Console", true

    @filter.debug = imgui.Checkbox "DEBUG", @filter.debug
    imgui.SameLine!
    @filter.warn = imgui.Checkbox "WARN", @filter.warn
    imgui.SameLine!
    @filter.error = imgui.Checkbox "ERROR", @filter.error

    imgui.Separator!
    imgui.BeginChild "ScrollingRegion", 0, -imgui.GetTextLineHeightWithSpacing!, false, "HorizontalScrollbar"

    for entry in *@log
      continue unless @filter[entry.type] or entry.interactive

      imgui.PushStyleColor "Text", unpack colors[entry.type]
      imgui.TextWrapped entry.text
      imgui.PopStyleColor!
      if entry.number
        if entry.number > 1000
          imgui.Text "[ca. #{100 * math.floor entry.number / 100} times]"
        else
          imgui.Text "[#{entry.number} times]"

      if entry.extra and imgui.BeginPopupContextWindow!
        imgui.Text entry.extra
        imgui.EndPopup!

    imgui.SetScrollHere 1 if @scroll_bottom
    @scroll_bottom = false

    imgui.EndChild!
    imgui.Separator!

    @buffer, submit = imgui.InputText "Input###{@history.index}", @buffer or "", 512, { "EnterReturnsTrue" }

    @typing = imgui.IsItemActive!

    if submit
      @submit!
      @scroll_bottom = true

    if @set_focus or submit
      imgui.SetKeyboardFocusHere -1
      @set_focus = nil

    imgui.End!

    ret

class DebugMenu
  new: =>
    @enabled = not _BUILD
    @console = Console!
    @tools = {}

  log: (text, add=0) =>
    { :name, :source, :currentline } = debug.getinfo 2 + add

    @console\add {
      :text,
      type: "debug",
      extra: "#{name}#{source}:#{currentline}",
    }

  warn: (text, add=0) =>
    { :name, :source, :currentline } = debug.getinfo 2 + add

    @console\add {
      :text,
      type: "warn",
      extra: "#{name}#{source}:#{currentline}",
    }

  error: (msg, add=0) =>
    { :name, :source, :currentline } = debug.getinfo 2 + add

    if _BUILD
      error "#{name}#{source}:#{currentline}: #{msg}"
    else
      @console\add {
        text: "#{name}:#{currentline}  #{msg}",
        extra: "#{name}#{source}:#{currentline}",
        type: "error",
      }

  assert_: (level, cond, msg, ...) =>
    return cond, msg, ... if cond

    { :name, :source, :currentline } = debug.getinfo 2 + level

    if _BUILD
      error "#{name}#{source}:#{currentline}: #{msg}"
    else
      @console\add {
        text: "#{name}:#{currentline}  #{msg}",
        extra: "#{name}#{source}:#{currentline}",
        type: "error",
      }
  assert: (...) => @assert_ 1, ...

  keypressed: (key) =>
    if @enabled and imgui.GetWantCaptureKeyboard!
      imgui.KeyPressed key
      @console\keypressed key if @tools.console
      imgui.GetWantCaptureKeyboard!
    else
      if key == "d" and lk.isDown "lshift"
        @enabled = not @enabled
        true
  keyreleased: (key) => imgui.GetWantCaptureKeyboard!, imgui.KeyReleased key
  textinput: (t) => imgui.GetWantCaptureKeyboard!, imgui.TextInput t

  mousepressed: (x, y, button) => imgui.GetWantCaptureMouse!, imgui.MousePressed button
  mousemoved: (x, y) => imgui.GetWantCaptureMouse!, imgui.MouseMoved x, y
  mousereleased: (x, y, button) => imgui.GetWantCaptureMouse!, imgui.MouseReleased button

  wheelmoved: (x, y) => imgui.WheelMoved y

  update: => imgui.NewFrame!

  draw: =>
    return unless @enabled

    local open_scene_switcher
    if imgui.BeginMainMenuBar!
      if imgui.BeginMenu "Tools"
        if imgui.MenuItem "Debug Mode", "D", @enabled
          @enabled = not @enabled
        @tools.test_window = imgui.MenuItem("Test Window", nil, @tools.test_window) or @tools.test_window
        if imgui.MenuItem "Switch Scene", "S"
          open_scene_switcher = true
        imgui.EndMenu!
    imgui.EndMainMenuBar!

    if imgui.Button "Reload Scene"
      SCENE\reload!
      SCENE\init!

    imgui.SameLine!
    if imgui.Button "Skip Dialogue"
      DIALOGUE\clear! if DIALOGUE
      DIALOGUE = nil

    imgui.SameLine!
    if imgui.Button "Switch Scene"
      open_scene_switcher = true

    imgui.OpenPopup "scene switcher" if open_scene_switcher
    if imgui.BeginPopup "scene switcher"
      @scene_switcher!
      imgui.EndPopup!

    @tools.scene_view = imgui.Checkbox "Scene View", @tools.scene_view
    imgui.SameLine!
    @tools.inspector = imgui.Checkbox "Node Inspector", @tools.inspector
    imgui.SameLine!
    @tools.console = imgui.Checkbox "Console", @tools.console
    @tools.hitboxes = imgui.Checkbox "Show Hitboxes", @tools.hitboxes

    if imgui.CollapsingHeader "Scene State"
      imgui.LabelText "Dialogue", coolstring DIALOGUE
      if imgui.IsItemClicked!
        @tools.inspector = true
        @selected_node = DIALOGUE

      imgui.Separator!
      for key, value in pairs SCENE.state
        imgui.LabelText key, coolstring value

    if imgui.CollapsingHeader "Scene Tags"
      for name, node in pairs SCENE.tags
        @draw_node node, "#{name}: #{node.name or "<no name>"}"

    if @tools.scene_view
      @tools.scene_view = imgui.Begin "Scene View", true, { "AlwaysVerticalScrollbar" }

      for node in *SCENE.tree
        @draw_node node

      imgui.End!

    if @tools.inspector
      name = "Node Inspector"
      if @selected_node
        name = "Node Inspector: #{@selected_node.name or "<no name>"}"
      @tools.inspector = imgui.Begin "#{name}###inspector", true, { "AlwaysVerticalScrollbar" }

      if not @selected_node
        imgui.Text "No node selected. Find one in the scene tags or the scene view"
      else
        imgui.Text @selected_node.name or "<no name>"
        imgui.Separator!
        for key, value in pairs @selected_node
          imgui.LabelText coolstring(key), coolstring value

      imgui.End!

    if @tools.test_window
      @tools.test_window = imgui.ShowTestWindow true

    if @tools.console
      @tools.console = @console\draw!

    imgui.Render!

  scene_switcher: =>
    for name, scenes in pairs SCENES
      if SCENE.scene\match name
        imgui.TextColored .7, .7, 0, 1, name
      else
        imgui.TextDisabled name
      for scene in *scenes
        imgui.Bullet!
        if SCENE.scene == "#{name}.#{scene}"
          if imgui.Selectable "reload #{scene}"
            SCENE\reload!
            SCENE\init!
        else
          if imgui.Selectable "#{scene}###{name}"
            SCENE\transition_to "#{name}.#{scene}"

  draw_node: (node, name) =>
    flags = { "OpenOnArrow", "OpenOnDoubleClick", "DefaultOpen" }
    table.insert flags, "Selected" if @selected_node == node
    table.insert flags, "Bullet" if not node[1]
    if imgui.TreeNodeEx name or node.name, flags
      for child in *node
        @draw_node child

      imgui.TreePop!

    if imgui.IsItemClicked!
      @tools.inspector = true unless @selected_node == node
      @selected_node = node

{
  :DebugMenu,
}
