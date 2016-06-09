package.path = package.path .. ";./?/init.lua;?.lua"

_BUILD = true
if not pcall(require, "init") then
  require "moonscript"
  _BUILD = false
  package.loaded.init = nil
  require "init"
end
