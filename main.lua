package.path = package.path .. ";./?/init.lua"

if not pcall(require, "init") then
  require "moonscript"
  require "init"
end
