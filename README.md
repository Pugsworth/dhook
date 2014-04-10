dhook
=====

Small wrapper library for easy developing with hooks



Usage
-----

Same syntax as standard hooks.

```lua
dhook.add("Think", "Think.Print", function() print("Printing"); end);
```

The easy part comes when you need to disable or remove hooks added like this.
The library registers several console commands to manipulate the hooks.

Each of these console commands can take arguments:
(string name or unique identifier, [boolean usePatterns])

*note:* booleans are represented as 0 and 1. <br/>

######example usage:

```hook_remove HUDPaint hud``` -- removes the specific hook 'hud' that is in 'HUDPaint' <br/>
```hook_disable hud[0-9]+ 1``` -- disables all hooks that match the unique identifier of 'hud[0-9]+' <br/>

#####clientside
##########

* hook_remove
* hook_enable
* hook_enable

#####serverside
##########

* hook_sv_remove
* hook_sv_enable
* hook_sv_disable

All console commands have 2 addition suffixes that don't take arguments:

* _all
* _last

eg. hook_sv_remove_all

---

The rest of the methods in the library follow the same syntax as standard hooks:
(string name, string identifier)

* dhook.remove
* dhook.enable
* dhook.disable


---
License information:

The MIT License (MIT)

Copyright (c) [2014] [Kyle "Pugsworth" Wolsten]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
