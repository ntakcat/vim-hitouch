## What is this? ##
Change the color of Vim.

## :Brightness ##
Brighten up. The numbers that can be used are 0-100. If it is 0, nothing will change. If it is 50, it will be about 50% brighter.
```
HiBrightness {percent}
HiBrightnessFG {percent}
HiBrightnessBG {percent}
HiBrightnessGroup {group} {percent}
HiBrightnessGroupFG {group} {percent}
HiBrightnessGroupBG {group} {percent}
```

## :Darkness ##
Darken. The usable value is 0-100. It is the opposite of Brightness.
```
HiDarkness {percent}
HiDarknessFG {percent}
HiDarknessBG {percent}
HiDarknessGroup {group} {percent}
HiDarknessGroupFG {group} {percent}
HiDarknessGroupBG {group} {percent}
```

## :Grayscale ##
Make it lighter. 0-100, the higher the number, the whiter it becomes.
```
HiGrayscale {percent}
HiGrayscaleFG {percent}
HiGrayscaleBG {percent}
HiGrayscaleGroup {group} {percent}
HiGrayscaleGroupFG {group} {percent}
HiGrayscaleGroupBG {group} {percent}
```

## :Kelvin ##
Change the color temperature. Centering on 6500, the value is red when the value is small and blue when it is large.
```
HiKelvin {kelvin}
HiKelvinFG {kelvin}
HiKelvinBG {kelvin}
HiKelvinGroup {group} {kelvin}
HiKelvinGroupFG {group} {kelvin}
HiKelvinGroupBG {group} {kenvin}
```

## :Nearest ##
Approximates the specified color. If you apply half the pure blue ('#0000FF', 50). 'rgb' is a '#' + six digit hexadecimal number.
```
HiNearest {rgb} {percent}
HiNearestFG {rgb} {percent}
HiNearestBG {rgb} {percent}
HiNearestGroup {group} {rgb} {percent}
HiNearestGroupFG {group} {rgb} {percent}
HiNearestGroupBG {gruop} {rgb} {percent}
```

## :NearestR :NearestG :NearestB ##
Affects only 'R'ed, 'G'reen, and 'B'lue. 'value' is a '#' + two digit hexadecimal number.
```
NearestR {value} {percent}
NearestRFG {value} {percent}
NearestRBG {value} {percent}
NearestRGroup {group} {value} {percent}
NearestRGroupFG {group} {vaule} {percent}
NearestRGroupBG {group} {value} {percent}
NearestG {value} {percent}
NearestGFG {value} {percent}
NearestGBG {value} {percent}
NearestGGroup {group} {value} {percent}
NearestGGroupFG {group} {vaule} {percent}
NearestGGroupBG {group} {value} {percent}
NearestB {value} {percent}
NearestBFG {value} {percent}
NearestBBG {value} {percent}
NearestBGroup {group} {value} {percent}
NearestBGroupFG {group} {vaule} {percent}
NearestBGroupBG {group} {value} {percent}
```

## :Gamma ##
Set Gamma. Specify a value that is 10 times the general gamma value.
```
HiGamma {gamma}
HiGammaFG {gamma}
HiGammaBG {gamma}
HiGammaGroup {group} {gamma}
HiGammaGroupFG {group} {gamma}
HiGammaGroupBG {group} {gamma}
```

## :Direct ##
Use the given value directly. 'value' is a '#' + six digit hexadecimal number, or color name.
```
HiDirect {value}
HiDirectFG {value}
HiDirectBG {value}
HiDirectGroup {group} {value}
HiDirectGroupFG {group} {value}
HiDirectGroupBG {group} {value}
```

## :DirectR :DirectG :DirectB ##
Same as above. 'value' is a '#' + two digit hexadecimal number.
```
HiDirectR {value} {percent}
HiDirectRFG {value} {percent}
HiDirectRBG {value} {percent}
HiDirectRGroup {group} {value} {percent}
HiDirectRGroupFG {group} {value} {percent}
HiDirectRGroupBG {group} {value} {percent}
HiDirectG {value} {percent}
HiDirectGFG {value} {percent}
HiDirectGBG {value} {percent}
HiDirectGGroup {group} {value} {percent}
HiDirectGGroupFG {group} {value} {percent}
HiDirectGGroupBG {group} {value} {percent}
HiDirectB {value} {percent}
HiDirectBFG {value} {percent}
HiDirectBBG {value} {percent}
HiDirectBGroup {group} {value} {percent}
HiDirectBGroupFG {group} {value} {percent}
HiDirectBGroupBG {group} {value} {percent}
```

## Copy ##
This is a simple copy operation. Get and store RGB values.
```
HiCopyGroup {group}
HiCopyGroupFG {group}
HiCopyGroupBG {group}
```

## Paste ##
This is a simple paster operation. Copies the stored RGV values.
```
HiPasteGroup {group}
HiPasteGroupFG {group}
HiPasteGroupBG {group}
```

## Unlink ##
If the group is a link, you cannot get the RGB values, you need to remove the link.
```
HiUnlinkGroup {group}
HiUnlinkGroupFG {group}
HiUnlinkGroupBG {group}
```

## Note ##
Even colors that look the same will not be the same if they are slightly different. In addition, since the current color is changed, the effect is strong as many times as the command is executed.

You may need to run :packloadall beforehand.

## Sample ##
My current settings.
```
if empty(globpath(&rtp, 'autoload/hitouch.vim'))
    finish
endif

function! CopyNormalToFolded()
    HiUnlinkGroup Normal
    HiCopyGroupBG Normal
    HiPasteGroupBG Folded
endfunction
function! DefaultDisplay()
    call s:Hitouch('DefaultDisplay')
    highlight clear
    call s:HiClearDefault()
endfunction
function! DefaultPlusDisplay()
    call s:Hitouch('DefaultPlusDisplay')
    highlight clear
    call CopyNormalToFolded()
endfunction
function! GreenDisplay()
    call s:Hitouch('GreenDisplay')
    call s:HiClearDefault()
    HiUnlinkGroup Normal
    HiDirectGroupFG Normal #C0C0C0
    HiDirectGroupBG Normal #101010
    HiGamma 32
    HiGrayscale 80
    HiNearestFG #00A000 70
    HiNearestBG #00A000 10
    HiNearestGroup Error.* #FF0000 50
    HiNearestGroup Warning.* #FFFF00 50
    HiDirectGroupFG Comment #00FF00
endfunction
function! PlasmaDisplay()
    call s:Hitouch('PlasmaDisplay')
    call s:HiClearDefault()
    HiUnlinkGroup Normal
    HiDirectGroupFG Normal #C0C0C0
    HiDirectGroupBG Normal #101010
    HiGamma 32
    HiGrayscale 70
    HiNearestFG #FF9020 50
    HiNearestBG #302010 90
    HiNearestGroup Error #FF0000 50
    HiNearestGroup WarningMsg #FFFF00 50
    HiDarknessFG 20
    HiNearestGroupFG Comment #FF9020 98
endfunction
function! StrangeDisplay()
    call s:Hitouch('StrangeDisplay')
    call s:HiClearDefault()
    HiUnlinkGroup Normal
    HiDirectGroupFG Normal #C0C0C0
    HiDirectGroupBG Normal #101010
    HiGrayscale 100
    HiNearestFG #FFFFFF 80
    HiNearestBG #004040 75
    HiDarkness 10
    HiDirectGroupFG Comment #FFFFFF
    HiDirectGroupFG cCppOut #002020
    HiNearestGroupFG Folded #008080 50

    HiCopyGroup Normal
    HiPasteGroup ColorColumn
    HiBrightnessGroupBG ColorColumn 10

    HiNearestGroupFG Error #FFFFFF 100
    HiNearestGroupBG Error #800000 100
    HiCopyGroup Error
    HiPasteGroup ErrorMsg

    HiNearestGroupFG WarningMsg #FFFFFF 100
    HiNearestGroupBG WarningMsg #808000 100
    HiCopyGroup WarningMsg
    HiPasteGroup LspWarningText
    HiPasteGroup LspWarningHighlight
endfunction
function! CmdExeDisplay()
    call s:Hitouch('CmdExeDisplay')
    call s:HiClearDefault()
    HiUnlinkGroup Normal
    HiDirectGroupFG Normal #C0C0C0
    HiDirectGroupBG Normal #101010
    HiNearestFG #C0C0C0 100
    HiNearestBG #101010 100
endfunction
function! GrayscaleDisplay()
    call s:Hitouch('GrayscaleDisplay')
    call s:HiClearDefault()
    HiUnlinkGroup Normal
    HiDirectGroupFG Normal #C0C0C0
    HiDirectGroupBG Normal #101010
    call CopyNormalToFolded()
    HiGrayscale 80
endfunction
function! DarkStrangeDisplay()
    call StrangeDisplay()
    call s:Hitouch('DarkStrangeDisplay')
    HiDarkness 50
endfunction
function! DarkDefaultDisplay()
    call DefaultDisplay()
    call s:Hitouch('DarkDefaultDisplay')
    HiDarkness 50
endfunction
nnoremap <silent> 1<c-l> :call DefaultDisplay()<cr>
nnoremap <silent> 2<c-l> :call GreenDisplay()<cr>
nnoremap <silent> 3<c-l> :call PlasmaDisplay()<cr>
nnoremap <silent> 4<c-l> :call StrangeDisplay()<cr>
nnoremap <silent> 5<c-l> :call CmdExeDisplay()<cr>
nnoremap <silent> 6<c-l> :call GrayscaleDisplay()<cr>
nnoremap <silent> 7<c-l> :call DarkStrangeDisplay()<cr>
nnoremap <silent> 8<c-l> :call DarkDefaultDisplay()<cr>
nnoremap <silent> 9<c-l> :call DefaultPlusDisplay()<cr>
function! s:Echoes(msg)
    echo a:msg
endfunction
function! s:Hitouch(msg)
    let l = [a:msg]
    call writefile(l, expand('~/.hitouch'))
endfunction
function! s:HiClearDefault()
    highlight clear
    colorscheme default
endfunction
function! s:HitouchSetting()
    if filereadable(expand('~/.hitouch'))
	execute 'call ' . readfile(expand('~/.hitouch'), 1)[0] . '()'
    endif
endfunction
syntax on
silent! set termguicolors
colorscheme default
call s:HitouchSetting()
```

## License ##
Same as vim.
