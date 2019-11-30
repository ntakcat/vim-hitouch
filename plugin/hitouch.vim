if exists('g:loaded_hitouch')
    finish
endif
let g:loaded_hitouch = 1

command! -nargs=1 Brightness call hitouch#Brightness(<f-args>)
command! -nargs=1 Darkness call hitouch#Darkness(<f-args>)
command! -nargs=1 Grayscale call hitouch#Grayscale(<f-args>)
command! -nargs=1 Kelvin call hitouch#Kelvin(<f-args>)
