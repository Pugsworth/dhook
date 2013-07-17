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
