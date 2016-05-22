ffi = require "ffi"

if love.system.getOS! == "Windows"
  ffi.load "kernel32"
  ffi.cdef "
    typedef void            VOID;
    typedef char            CHAR;
    typedef unsigned long   DWORD;
    typedef int             BOOL;
    typedef const CHAR      *LPCTSTR;
    typedef VOID            *HANDLE;

    DWORD WaitForSingleObject(
      HANDLE hHandle,
      DWORD  dwMilliseconds
    );

    BOOL FindNextChangeNotification(
      HANDLE hChangeHandle
    );

    HANDLE FindFirstChangeNotification(
      LPCTSTR lpPathName,
      BOOL    bWatchSubtree,
      DWORD   dwNotifyFilter
    );
  "

weakmt = __mode: 'v'
class Watcher
  new: =>
    @files = {}

    switch love.system.getOS!
      when "Windows"
        @handle = ffi.C.FindFirstChangeNotification ".", true, 0x00000010
      when "Linux"
        inotify = require "inotify"
        @handle = inotify.init blocking: false
        @handle\addwatch ".", inotify.IN_MODIFY, inotify.IN_ACCESS

  register: (filename, obj) =>
    if @files[filename]
      table.insert @files[filename], obj
    else
      print "listening to changes for #{filename}..."
      @files[filename] = setmetatable { obj, modified: love.filesystem.getLastModified filename }, weakmt

  update: =>
    local changes
    switch love.system.getOS!
      when "Windows"
        changes = 0 == ffi.C.WaitForSingleObject @handle, 0
      when "Linux"
        changes = #@handle\read! > 0

    if changes
      for name, objs in pairs @files
        modified = love.filesystem.getLastModified name
        if objs.modified < modified
          print "old #{objs.modified}, new #{modified}"
          objs.modified = modified
          for _, obj in pairs objs
            if "number" == type _
              obj\reload name

      if love.system.getOS! == "Windows"
          ffi.C.FindNextChangeNotification @handle

{
  :Watcher,
}
