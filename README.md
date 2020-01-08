## What is this? ##
Change the color of Vim. Implemented Brightness, Darkness, Grayscale, Kelvin and Nearest.

## :Brightness ##
Brighten up. The numbers that can be used are 0-100. If it is 0, nothing will change. If it is 50, it will be about 50% brighter.
```
hitouch#Brightness(percent)
hitouch#BrightnessFG(percent)
hitouch#BrightnessBG(percent)
hitouch#BrightnessGroup(group, percent)
hitouch#BrightnessGroupFG(group, percent)
hitouch#BrightnessGroupBG(group, percent)
```

## :Darkness ##
Darken. The usable value is 0-100. It is the opposite of Brightness.
```
hitouch#Darkness(percent)
hitouch#DarknessFG(percent)
hitouch#DarknessBG(percent)
hitouch#DarknessGroup(group, percent)
hitouch#DarknessGroupFG(group, percent)
hitouch#DarknessGroupBG(group, percent)
```

## :Grayscale ##
Make it lighter. 0-100, the higher the number, the whiter it becomes.
```
hitouch#Grayscale(percent)
hitouch#GrayscaleFG(percent)
hitouch#GrayscaleBG(percent)
hitouch#GrayscaleGroup(group, percent)
hitouch#GrayscaleGroupFG(group, percent)
hitouch#GrayscaleGroupBG(group, percent)
```

## :Kelvin ##
Change the color temperature. Centering on 6500, the value is red when the value is small and blue when it is large.
```
hitouch#Kelvin(Kelvin)
hitouch#KelvinFG(Kelvin)
hitouch#KelvinBG(Kelvin)
hitouch#KelvinGroup(group, Kelvin)
hitouch#KelvinGroupFG(group, Kelvin)
hitouch#KelvinGroupBG(group, Kelvin)
```

## :Nearest ##
Approximates the specified color. If you apply half the pure blue ('#0000FF', 50). 'rgb' is a '#' + six digit hexadecimal number.
```
hitouch#Nearest(rgb, percent)
hitouch#NearestFG(rgb, percent)
hitouch#NearestBG(rgb, percent)
hitouch#NearestGroup(group, rgb, percent)
hitouch#NearestGroupFG(group, rgb, percent)
hitouch#NearestGroupBG(group, rgb, percent)
```

## :NearestR :NearestG :NearestB ##
Affects only 'R'ed, 'G'reen, and 'B'lue. 'value' is a '#' + two digit hexadecimal number.
```
hitouch#NearestR(value, percent)
hitouch#NearestRFG(value, percent)
hitouch#NearestRBG(value, percent)
hitouch#NearestRGroup(group, value, percent)
hitouch#NearestRGroupFG(group, value, percent)
hitouch#NearestRGroupBG(group, value, percent)
hitouch#NearestR(value, percent)
hitouch#NearestRFG(value, percent)
hitouch#NearestRBG(value, percent)
hitouch#NearestGGroup(group, value, percent)
hitouch#NearestGGroupFG(group, value, percent)
hitouch#NearestGGroupBG(group, value, percent)
hitouch#NearestG(value, percent)
hitouch#NearestGFG(value, percent)
hitouch#NearestGBG(value, percent)
hitouch#NearestGGroup(group, value, percent)
hitouch#NearestGGroupFG(group, value, percent)
hitouch#NearestGGroupBG(group, value, percent)
hitouch#NearestBGroup(group, value, percent)
hitouch#NearestBGroupFG(group, value, percent)
hitouch#NearestBGroupBG(group, value, percent)
hitouch#NearestB(value, percent)
hitouch#NearestBFG(value, percent)
hitouch#NearestBBG(value, percent)
hitouch#NearestBGroup(group, value, percent)
hitouch#NearestBGroupFG(group, value, percent)
hitouch#NearestBGroupBG(group, value, percent)
```

## :Direct ##
Use the given value directly. 'value' is a '#' + six digit hexadecimal number, or color name.
```
hitouch#Direct(value)
hitouch#DirectFG(value)
hitouch#DirectBG(value)
hitouch#DirectGroup(group, value)
hitouch#DirectGroupFG(group, value)
hitouch#DirectGroupBG(group, value)
```

## :DirectR :DirectG :DirectB ##
Same as above. 'value' is a '#' + two digit hexadecimal number.
```
hitouch#DirectR(value, percent)
hitouch#DirectRFG(value, percent)
hitouch#DirectRBG(value, percent)
hitouch#DirectRGroup(group, value, percent)
hitouch#DirectRGroupFG(group, value, percent)
hitouch#DirectRGroupBG(group, value, percent)
hitouch#DirectR(value, percent)
hitouch#DirectRFG(value, percent)
hitouch#DirectRBG(value, percent)
hitouch#DirectGGroup(group, value, percent)
hitouch#DirectGGroupFG(group, value, percent)
hitouch#DirectGGroupBG(group, value, percent)
hitouch#DirectG(value, percent)
hitouch#DirectGFG(value, percent)
hitouch#DirectGBG(value, percent)
hitouch#DirectGGroup(group, value, percent)
hitouch#DirectGGroupFG(group, value, percent)
hitouch#DirectGGroupBG(group, value, percent)
hitouch#DirectBGroup(group, value, percent)
hitouch#DirectBGroupFG(group, value, percent)
hitouch#DirectBGroupBG(group, value, percent)
hitouch#DirectB(value, percent)
hitouch#DirectBFG(value, percent)
hitouch#DirectBBG(value, percent)
hitouch#DirectBGroup(group, value, percent)
hitouch#DirectBGroupFG(group, value, percent)
hitouch#DirectBGroupBG(group, value, percent)
```

## :Gamma ##
Set Gamma. Specify a value that is 10 times the general gamma value.
```
hitouch#Gamma(gamma)
hitouch#GammaFG(gamma)
hitouch#GammaBG(gamma)
hitouch#GammaGroup(group, gamma)
hitouch#GammaGroupFG(group, gamma)
hitouch#GammaGroupBG(group, gamma)
```

## Note ##
Even colors that look the same will not be the same if they are slightly different. In addition, since the current color is changed, the effect is strong as many times as the command is executed.

You may need to run :packloadall beforehand.

## Sample ##
```
function! GreenDisplay()
    syntax off
    syntax on
    colorscheme default
    call hitouch#DirectGroupFG('Normal', 'white')
    call hitouch#DirectGroupBG('Normal', 'black')
    call hitouch#Gamma(22)
    call hitouch#Grayscale(100)
    call hitouch#NearestFG('#00A000', 70)
    call hitouch#NearestBG('#00A000', 10)
    call hitouch#DirectGroupFG('Comment', '#00FF00')
endfunction
function! PlasmaDisplay()
    syntax off
    syntax on
    colorscheme default
    call hitouch#DirectGroupFG('Normal', 'white')
    call hitouch#DirectGroupBG('Normal', 'black')
    call hitouch#Gamma(32)
    call hitouch#Grayscale(70)
    call hitouch#NearestFG('#FF9020', 50)
    call hitouch#NearestBG('#302010', 90)
    call hitouch#NearestGroup('Error', '#FF0000', 50)
    call hitouch#NearestGroup('WarningMsg', '#FFFF00', 50)
    call hitouch#DarknessFG(20)
    call hitouch#NearestGroupFG('Comment', '#FF9020', 98)
endfunction
function! MonoDisplay()
    syntax off
    syntax on
    colorscheme default
    call hitouch#DirectGroupFG('Normal', 'white')
    call hitouch#DirectGroupBG('Normal', 'black')
    call hitouch#Grayscale(100)
endfunction
function! CommentDisplay()
    syntax off
    syntax on
    colorscheme default
    call hitouch#DirectGroupFG('Normal', 'white')
    call hitouch#DirectGroupBG('Normal', 'black')
    call hitouch#Grayscale(100)
    call hitouch#NearestGroupFG('Comment', '#3030C0', 60)
endfunction
syntax on
silent! set termguicolors
packloadall
augroup colormanip
    autocmd!
    autocmd FileType c,cpp,h highlight link Delimiter Pmenu
augroup END
nnoremap 1<c-l> :syntax off \| syntax on<cr>
nnoremap 2<c-l> :call GreenDisplay()<cr>
nnoremap 3<c-l> :call PlasmaDisplay()<cr>
nnoremap 4<c-l> :call MonoDisplay()<cr>
nnoremap 5<c-l> :call CommentDisplay()<cr>
```

## License ##
Same as vim.
