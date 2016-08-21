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

    if imgui.BeginMainMenuBar!
      if imgui.BeginMenu "Tools"
        if imgui.MenuItem "Switch Scene", "S"
          imgui.OpenPopup "scene switcher"
        imgui.EndMenu!
    imgui.EndMainMenuBar!

    if imgui.Button "Reload Scene"
      SCENE\reload!
      SCENE\init!

    imgui.SameLine!
    if imgui.Button "Skip Dialogue"
      DIALOGUE\clear! if DIALOGUE
      DIALOGUE = nil

    _, @tools.scene_view = imgui.Checkbox "Scene View", @tools.scene_view
    imgui.SameLine!
    _, @tools.inspector = imgui.Checkbox "Node Inspector", @tools.inspector

    if imgui.CollapsingHeader "Scene State"
      imgui.LabelText "Dialogue", tostring DIALOGUE
      imgui.Separator!
      for key, value in pairs SCENE.state
        imgui.LabelText key, tostring value

    if imgui.CollapsingHeader "Scene Tags"
      for name, node in pairs SCENE.tags
        @draw_node node

    if imgui.CollapsingHeader "Scene Switcher"
      @scene_switcher!

    if @tools.scene_view
      _, @tools.scene_view = imgui.Begin "Scene View", true, { "AlwaysVerticalScrollbar" }

      for node in *SCENE.tree
        @draw_node node

      imgui.End!

    if @tools.inspector
      _, @tools.inspector = imgui.Begin "Node Inspector", true, { "AlwaysVerticalScrollbar" }

      if not @selected_node
        imgui.Text "No node selected. Find one in the scene tags or the scene view"
      else
        imgui.Text @selected_node.name

      imgui.End!

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
        else
          imgui.Text scene
          imgui.SameLine 300
          if imgui.SmallButton "load #{scene}"
            SCENE\transition_to "#{name}.#{scene}"

  draw_node: (node) =>
    flags = { "OpenOnArrow", "OpenOnDoubleClick" }
    table.insert flags, "Selected" if @selected_node == node
    table.insert flags, "Leaf" if not node[1]
    if imgui.TreeNodeEx node.name, flags
      for child in *node
        @draw_node child

      imgui.TreePop!

    if imgui.IsItemClicked!
      @selected_node = node

{
  :DebugMenu,
}
