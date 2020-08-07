Figure out if you've done a quest:

Into chat:
```
/script for k,v in pairs(GetQuestsCompleted()) do if k == 962 then print(v) end  end
```
Replace `962` with your quest number. If you've completed it you'll see `true`
in the console, otherwise nothing.

Sheep
```
#showtooltip
/target [@mouseover,harm,nodead]
/tm [harm,nodead]5
/cast [harm,nodead]Polymorph
/p {moon} Sheeping %t.
/p {moon}
/targetlasttarget [@mouseover,harm,nodead]
```

