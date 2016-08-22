{ graphics: lg, keyboard: lk, filesystem: lf } = love

require "imgui"
Vector = require "lib.hump.vector"

export DIALOGUE

SCENES = {}
for dir in *lf.getDirectoryItems "game/scenes"
  if lf.isDirectory "game/scenes/#{dir}"
    SCENES[dir] = {}
    for file in *lf.getDirectoryItems "game/scenes/#{dir}"
      if scene = file\match "(.*)%.psd$"
        table.insert SCENES[dir], scene

    SCENES[dir] = nil if not next SCENES[dir]

class DebugMenu
  new: =>
    @enabled = not _BUILD

    @tools = {}

    @proxy = setmetatable {},
      __index: (key) => @[key] = false

    @DEBUG = setmetatable {},
      __call: (_, tgl) ->
        @enabled
      __newindex: @proxy
      __index: (_, key) ->
        if @enabled
          @proxy[key]
        else
          false

  keypressed: (key) =>
    if key == "d" and lk.isDown "lshift"
      @enabled = not @enabled
      true
    else
      imgui.GetWantCaptureKeyboard!, imgui.KeyPressed key
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

    _, @tools.scene_view = imgui.Checkbox "Scene View", @tools.scene_view
    imgui.SameLine!
    _, @tools.inspector = imgui.Checkbox "Node Inspector", @tools.inspector
    _, @tools.hitboxes = imgui.Checkbox "Show Hitboxes", @tools.hitboxes

    if imgui.CollapsingHeader "Scene State"
      imgui.LabelText "Dialogue", tostring DIALOGUE
      imgui.Separator!
      for key, value in pairs SCENE.state
        imgui.LabelText key, tostring value

    if imgui.CollapsingHeader "Scene Tags"
      for name, node in pairs SCENE.tags
        @draw_node node, "#{name}: #{node.name or "<no name>"}"

    if @tools.scene_view
      _, @tools.scene_view = imgui.Begin "Scene View", true, { "AlwaysVerticalScrollbar" }

      for node in *SCENE.tree
        @draw_node node

      imgui.End!

    if @tools.inspector
      name = "Node Inspector"
      if @selected_node
        name = "Node Inspector: #{@selected_node.name or "<no name>"}"
      _, @tools.inspector = imgui.Begin "#{name}###inspector", true, { "AlwaysVerticalScrollbar" }

      if not @selected_node
        imgui.Text "No node selected. Find one in the scene tags or the scene view"
      else
        imgui.Text @selected_node.name or "<no name>"
        imgui.Separator!
        for key, value in pairs @selected_node
          imgui.LabelText tostring(key), tostring value

      imgui.End!

    if @tools.test_window
      @tools.test_window = imgui.ShowTestWindow true

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
          imgui.TextColored 1, 1, 0, 1, scene
          imgui.SameLine 300
          if imgui.SmallButton "reload"
            SCENE\reload!
            SCENE\init!
            imgui.CloseCurrentPopup!
        else
          imgui.Text scene
          imgui.SameLine 300
          if imgui.SmallButton "load###{name}#{scene}"
            SCENE\transition_to "#{name}.#{scene}"
            imgui.CloseCurrentPopup!

  draw_node: (node, name) =>
    flags = { "OpenOnArrow", "OpenOnDoubleClick" }
    table.insert flags, "Selected" if @selected_node == node
    table.insert flags, "Leaf" if not node[1]
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
