function! s:GetCode(group, fgbg)
    let code = synIDattr(synIDtrans(hlID(a:group)), a:fgbg . '#')
    if code == ''
	let code = synIDattr(synIDtrans(hlID('Normal')), a:fgbg . '#')
    endif
    if code == ''
	if a:fgbg == 'fg' && &g:background == 'dark'
	    let code = '#ffffff'
	elseif a:fgbg == 'bg' && &g:background == 'dark'
	    let code = '#000000'
	elseif a:fgbg == 'fg' && &g:background == 'light'
	    let code = '#000000'
	else
	    let code = '#ffffff'
	endif
    endif
    return code
endfunction

function! s:GetRGB(code)
    let r = str2nr(strcharpart(a:code, 1, 2), 16)
    let g = str2nr(strcharpart(a:code, 3, 2), 16)
    let b = str2nr(strcharpart(a:code, 5, 2), 16)
    return [r, g, b]
endfunction

function! s:Highlight(group, fgbg, r, g, b)
    execute(printf("highlight %s %s=#%02x%02x%02x", a:group, 'gui' . a:fgbg, a:r, a:g, a:b))
endfunction

function! hitouch#BrightnessGroup(group, percent)
    call hitouch#BrightnessGroupFGBG(a:group, 'fg', a:percent)
    call hitouch#BrightnessGroupFGBG(a:group, 'bg', a:percent)
endfunction
function! hitouch#BrightnessGroupFGBG(group, fgbg, percent)
    let [r, g, b] = s:GetRGB(s:GetCode(a:group, a:fgbg))
    let r = a:percent ? r + (255 - r) * a:percent / 100 : r
    let g = a:percent ? g + (255 - g) * a:percent / 100 : g
    let b = a:percent ? b + (255 - b) * a:percent / 100 : b
    call s:Highlight(a:group, a:fgbg, r, g, b)
endfunction

function! hitouch#DarknessGroup(group, percent)
    call hitouch#DarknessGroupFGBG(a:group, 'fg', a:percent)
    call hitouch#DarknessGroupFGBG(a:group, 'bg', a:percent)
endfunction
function! hitouch#DarknessGroupFGBG(group, fgbg, percent)
    let [r, g, b] = s:GetRGB(s:GetCode(a:group, a:fgbg))
    let r = a:percent ? r - r * a:percent / 100 : r
    let g = a:percent ? g - g * a:percent / 100 : g
    let b = a:percent ? b - b * a:percent / 100 : b
    call s:Highlight(a:group, a:fgbg, r, g, b)
endfunction

function! hitouch#GrayscaleGroup(group, percent)
    call hitouch#GrayscaleGroupFGBG(a:group, 'fg', a:percent)
    call hitouch#GrayscaleGroupFGBG(a:group, 'bg', a:percent)
endfunction
function! hitouch#GrayscaleGroupFGBG(group, fgbg, percent)
    let [r, g, b] = s:GetRGB(s:GetCode(a:group, a:fgbg))
    let m = (2 * r + 4 * g + b) / 7
    let r = r - ((r - m) * a:percent) / 100
    let g = g - ((g - m) * a:percent) / 100
    let b = b - ((b - m) * a:percent) / 100
    call s:Highlight(a:group, a:fgbg, r, g, b)
endfunction

function! hitouch#KelvinGroup(group, percent)
    call hitouch#KelvinGroupFGBG(a:group, 'fg', a:percent)
    call hitouch#KelvinGroupFGBG(a:group, 'bg', a:percent)
endfunction
function! hitouch#KelvinGroupFGBG(group, fgbg, kelvin)
    let [r, g, b] = s:GetRGB(s:GetCode(a:group, a:fgbg))
    let k = min([max([a:kelvin, 1000]), 40000]) / 100
    let lr = (k <= 66) ? 255 : min([max([329.69 * pow(k - 60, -0.13), 0]), 255])
    let lg = (k <= 66) ? min([max([float2nr(99.47 * log(k) - 161.11), 0]), 255]) : min([max([288.12 * pow(k - 60, -0.07), 0.0]), 255])
    let lb = (k >= 66) ? 255 : (k <= 19) ? 0 : min([max([float2nr(138.51 * log(k - 10) - 305.04), 0]), 255])
    let r = and((r * lr) / 256, 255)
    let g = and((g * lg) / 256, 255)
    let b = and((b * lb) / 256, 255)
    call s:Highlight(a:group, a:fgbg, r, g, b)
endfunction

function! hitouch#NearestGroup(group, rgb, percent)
    call hitouch#NearestGroupFGBG(a:group, 'fg', a:rgb, a:percent)
    call hitouch#NearestGroupFGBG(a:group, 'bg', a:rgb, a:percent)
endfunction
function! hitouch#NearestGroupFGBG(group, fgbg, rgb, percent)
    let [r1, g1, b1] = s:GetRGB(s:GetCode(a:group, a:fgbg))
    let [r2, g2, b2] = s:GetRGB(a:rgb)
    if r1 > r2
	let r = r1 - (r1 - r2) * a:percent / 100
    else
	let r = r1 + (r2 - r1) * a:percent / 100
    endif
    if g1 > g2
	let g = g1 - (g1 - g2) * a:percent / 100
    else
	let g = g1 + (g2 - g1) * a:percent / 100
    endif
    if b1 > b2
	let b = b1 - (b1 - b2) * a:percent / 100
    else
	let b = b1 + (b2 - b1) * a:percent / 100
    endif
    call s:Highlight(a:group, a:fgbg, r, g, b)
endfunction

function! s:ForeachHighlight(func, percent)
    for l in split(execute('highlight'), '\n')
	if match(l, 'cleared') == -1 && match(l, 'links') == -1
	    let n = substitute(l, '^\(\w*\).*$', '\1', '')
	    if n != ''
		call a:func(n, a:percent)
	    endif
	endif
    endfor
endfunction

function! hitouch#BrightnessGroupFG(group, percent)
    call hitouch#BrightnessGroupFGBG(a:group, 'fg', a:percent)
endfunction
function! hitouch#BrightnessGroupBG(group, percent)
    call hitouch#BrightnessGroupFGBG(a:group, 'bg', a:percent)
endfunction

function! hitouch#DarknessGroupFG(group, percent)
    call hitouch#DarknessGroupFGBG(a:group, 'fg', a:percent)
endfunction
function! hitouch#DarknessGroupBG(group, percent)
    call hitouch#DarknessGroupFGBG(a:group, 'bg', a:percent)
endfunction

function! hitouch#GrayscaleGroupFG(group, percent)
    call hitouch#GrayscaleGroupFGBG(a:group, 'fg', a:percent)
endfunction
function! hitouch#GrayscaleGroupBG(group, percent)
    call hitouch#GrayscaleGroupFGBG(a:group, 'bg', a:percent)
endfunction

function! hitouch#KelvinGroupFG(group, percent)
    call hitouch#KelvinGroupFGBG(a:group, 'fg', a:percent)
endfunction
function! hitouch#KelvinGroupBG(group, percent)
    call hitouch#KelvinGroupFGBG(a:group, 'bg', a:percent)
endfunction

function! hitouch#NearestGroupFG(group, rgb, percent)
    call hitouch#NearestGroupFGBG(a:group, 'fg', a:rgb, a:percent)
endfunction
function! hitouch#NearestGroupBG(group, rgb, percent)
    call hitouch#NearestGroupFGBG(a:group, 'bg', a:rgb, a:percent)
endfunction

function! hitouch#BrightnessFG(percent)
    call s:ForeachHighlight(function('hitouch#BrightnessGroupFG'), a:percent)
endfunction
function! hitouch#BrightnessBG(percent)
    call s:ForeachHighlight(function('hitouch#BrightnessGroupBG'), a:percent)
endfunction
function! hitouch#Brightness(percent)
    call s:ForeachHighlight(function('hitouch#BrightnessGroupFG'), a:percent)
    call s:ForeachHighlight(function('hitouch#BrightnessGroupBG'), a:percent)
endfunction

function! hitouch#DarknessFG(percent)
    call s:ForeachHighlight(function('hitouch#DarknessGroupFG'), a:percent)
endfunction
function! hitouch#DarknessBG(percent)
    call s:ForeachHighlight(function('hitouch#DarknessGroupBG'), a:percent)
endfunction
function! hitouch#Darkness(percent)
    call s:ForeachHighlight(function('hitouch#DarknessGroupFG'), a:percent)
    call s:ForeachHighlight(function('hitouch#DarknessGroupBG'), a:percent)
endfunction

function! hitouch#GrayscaleFG(percent)
    call s:ForeachHighlight(function('hitouch#GrayscaleGroupFG'), a:percent)
endfunction
function! hitouch#GrayscaleBG(percent)
    call s:ForeachHighlight(function('hitouch#GrayscaleGroupBG'), a:percent)
endfunction
function! hitouch#Grayscale(percent)
    call s:ForeachHighlight(function('hitouch#GrayscaleGroupFG'), a:percent)
    call s:ForeachHighlight(function('hitouch#GrayscaleGroupBG'), a:percent)
endfunction

function! hitouch#KelvinFG(percent)
    call s:ForeachHighlight(function('hitouch#KelvinGroupFG'), a:percent)
endfunction
function! hitouch#KelvinBG(percent)
    call s:ForeachHighlight(function('hitouch#KelvinGroupBG'), a:percent)
endfunction
function! hitouch#Kelvin(kelvin)
    call s:ForeachHighlight(function('hitouch#KelvinGroupFG'), a:kelvin)
    call s:ForeachHighlight(function('hitouch#KelvinGroupBG'), a:kelvin)
endfunction

function! hitouch#NearestFG(percent)
    for l in split(execute('highlight'), '\n')
	if match(l, 'cleared') == -1 && match(l, 'links') == -1
	    let n = substitute(l, '^\(\w*\).*$', '\1', '')
	    if n != ''
		call hitouch#NearestGroupFG(n, a:rgb, a:percent)
	    endif
	endif
    endfor
endfunction
function! hitouch#NearestBG(percent)
    for l in split(execute('highlight'), '\n')
	if match(l, 'cleared') == -1 && match(l, 'links') == -1
	    let n = substitute(l, '^\(\w*\).*$', '\1', '')
	    if n != ''
		call hitouch#NearestGroupBG(n, a:rgb, a:percent)
	    endif
	endif
    endfor
endfunction
function! hitouch#Nearest(rgb, percent)
    for l in split(execute('highlight'), '\n')
	if match(l, 'cleared') == -1 && match(l, 'links') == -1
	    let n = substitute(l, '^\(\w*\).*$', '\1', '')
	    if n != ''
		call hitouch#NearestGroupFG(n, a:rgb, a:percent)
		call hitouch#NearestGroupBG(n, a:rgb, a:percent)
	    endif
	endif
    endfor
endfunction
