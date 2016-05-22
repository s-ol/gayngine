package.path = package.path .. ";./?/init.lua"

if not pcall(require, "init") then
  require "moonscript"
  package.loaded.init = nil
  require "init"
end
