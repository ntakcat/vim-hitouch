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

function! s:GetHex(code)
    return str2nr(strcharpart(a:code, 1, 2), 16)
endfunction

function! s:Highlight(group, fgbg, r, g, b)
    execute(printf("highlight %s %s=#%02x%02x%02x", a:group, 'gui' . a:fgbg, a:r, a:g, a:b))
endfunction

function! s:HighlightString(group, fgbg, value)
    execute(printf("highlight %s %s=%s", a:group, 'gui' . a:fgbg, a:value))
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

function! hitouch#NearestRGroup(group, value, percent)
    call hitouch#NearestRGroupFGBG(a:group, 'fg', a:value, a:percent)
    call hitouch#NearestRGroupFGBG(a:group, 'bg', a:value, a:percent)
endfunction
function! hitouch#NearestRGroupFGBG(group, fgbg, value, percent)
    let value = s:GetHex(a:value)
    let [r, g, b] = s:GetRGB(s:GetCode(a:group, a:fgbg))
    if r > value
	let r = r - (r - value) * a:percent / 100
    else
	let r = r + (value - r) * a:percent / 100
    endif
    call s:Highlight(a:group, a:fgbg, r, g, b)
endfunction

function! hitouch#NearestGGroup(group, value, percent)
    call hitouch#NearestGGroupFGBG(a:group, 'fg', a:value, a:percent)
    call hitouch#NearestGGroupFGBG(a:group, 'bg', a:value, a:percent)
endfunction
function! hitouch#NearestGGroupFGBG(group, fgbg, value, percent)
    let value = s:GetHex(a:value)
    let [r, g, b] = s:GetRGB(s:GetCode(a:group, a:fgbg))
    if g > value
	let g = g - (g - value) * a:percent / 100
    else
	let g = g + (value - g) * a:percent / 100
    endif
    call s:Highlight(a:group, a:fgbg, r, g, b)
endfunction

function! hitouch#NearestBGroup(group, value, percent)
    call hitouch#NearestBGroupFGBG(a:group, 'fg', a:value, a:percent)
    call hitouch#NearestBGroupFGBG(a:group, 'bg', a:value, a:percent)
endfunction
function! hitouch#NearestBGroupFGBG(group, fgbg, value, percent)
    let value = s:GetHex(a:value)
    let [r, g, b] = s:GetRGB(s:GetCode(a:group, a:fgbg))
    if b > value
	let b = b - (b - value) * a:percent / 100
    else
	let b = b + (value - b) * a:percent / 100
    endif
    call s:Highlight(a:group, a:fgbg, r, g, b)
endfunction

function! hitouch#GammaGroup(group, gamma)
    call hitouch#GammaGroupFGBG(a:group, 'fg', a:gamma)
    call hitouch#GammaGroupFGBG(a:group, 'bg', a:gamma)
endfunction
function! hitouch#GammaGroupFGBG(group, fgbg, gamma)
    let [r, g, b] = s:GetRGB(s:GetCode(a:group, a:fgbg))
    let r = float2nr(pow(r / 255.0, a:gamma / 10.0) * 255)
    let g = float2nr(pow(g / 255.0, a:gamma / 10.0) * 255)
    let b = float2nr(pow(b / 255.0, a:gamma / 10.0) * 255)
    call s:Highlight(a:group, a:fgbg, r, g, b)
endfunction

function! hitouch#DirectGroup(group, value)
    call hitouch#DirectGroupFGBG(a:group, 'fg', a:value)
    call hitouch#DirectGroupFGBG(a:group, 'bg', a:value)
endfunction
function! hitouch#DirectGroupFGBG(group, fgbg, value)
    if strcharpart(a:value, 0, 1) == '#'
	let [r, g, b] = s:GetRGB(a:value)
	call s:Highlight(a:group, a:fgbg, r, g, b)
    else
	call s:HighlightString(a:group, a:fgbg, a:value)
    endi
endfunction

function! hitouch#DirectRGroup(group, value)
    call hitouch#DirectRGroupFGBG(a:group, 'fg', a:value)
    call hitouch#DirectRGroupFGBG(a:group, 'bg', a:value)
endfunction
function! hitouch#DirectRGroupFGBG(group, fgbg, value)
    let [r, g, b] = s:GetRGB(s:GetCode(a:group, a:fgbg))
    let r = s:GetHex(a:value)
    call s:Highlight(a:group, a:fgbg, r, g, b)
endfunction

function! hitouch#DirectGGroup(group, value)
    call hitouch#DirectGGroupFGBG(a:group, 'fg', a:value)
    call hitouch#DirectGGroupFGBG(a:group, 'bg', a:value)
endfunction
function! hitouch#DirectGGroupFGBG(group, fgbg, value)
    let [r, g, b] = s:GetRGB(s:GetCode(a:group, a:fgbg))
    let g = s:GetHex(a:value)
    call s:Highlight(a:group, a:fgbg, r, g, b)
endfunction

function! hitouch#DirectBGroup(group, value)
    call hitouch#DirectBGroupFGBG(a:group, 'fg', a:value)
    call hitouch#DirectBGroupFGBG(a:group, 'bg', a:value)
endfunction
function! hitouch#DirectBGroupFGBG(group, fgbg, value)
    let [r, g, b] = s:GetRGB(s:GetCode(a:group, a:fgbg))
    let b = s:GetHex(a:value)
    call s:Highlight(a:group, a:fgbg, r, g, b)
endfunction

function! s:ForeachHighlight(func, arg1)
    for l in split(execute('highlight'), '\n')
	if match(l, 'cleared') == -1 && match(l, 'links') == -1
	    let n = substitute(l, '^\(\w*\).*$', '\1', '')
	    if n != ''
		call a:func(n, a:arg1)
	    endif
	endif
    endfor
endfunction

function! s:ForeachHighlight2(func, arg1, arg2)
    for l in split(execute('highlight'), '\n')
	if match(l, 'cleared') == -1 && match(l, 'links') == -1
	    let n = substitute(l, '^\(\w*\).*$', '\1', '')
	    if n != ''
		call a:func(n, a:arg1, a:arg2)
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

function! hitouch#NearestRGroupFG(group, value, percent)
    call hitouch#NearestRGroupFGBG(a:group, 'fg', a:value, a:percent)
endfunction
function! hitouch#NearestRGroupBG(group, value, percent)
    call hitouch#NearestRGroupFGBG(a:group, 'bg', a:value, a:percent)
endfunction

function! hitouch#NearestGGroupFG(group, value, percent)
    call hitouch#NearestGGroupFGBG(a:group, 'fg', a:value, a:percent)
endfunction
function! hitouch#NearestGGroupBG(group, value, percent)
    call hitouch#NearestGGroupFGBG(a:group, 'bg', a:value, a:percent)
endfunction

function! hitouch#NearestBGroupFG(group, value, percent)
    call hitouch#NearestBGroupFGBG(a:group, 'fg', a:value, a:percent)
endfunction
function! hitouch#NearestBGroupBG(group, value, percent)
    call hitouch#NearestBGroupFGBG(a:group, 'bg', a:value, a:percent)
endfunction

function! hitouch#GammaGroupFG(group, gamma)
    call hitouch#GammaGroupFGBG(a:group, 'fg', a:gamma)
endfunction
function! hitouch#GammaGroupBG(group, gamma)
    call hitouch#GammaGroupFGBG(a:group, 'bg', a:gamma)
endfunction

function! hitouch#DirectGroupFG(group, value)
    call hitouch#DirectGroupFGBG(a:group, 'fg', a:value)
endfunction
function! hitouch#DirectGroupBG(group, value)
    call hitouch#DirectGroupFGBG(a:group, 'bg', a:value)
endfunction

function! hitouch#DirectRGroupFG(group, value)
    call hitouch#DirectRGroupFGBG(a:group, 'fg', a:value)
endfunction
function! hitouch#DirectRGroupBG(group, value)
    call hitouch#DirectRGroupFGBG(a:group, 'bg', a:value)
endfunction

function! hitouch#DirectGGroupFG(group, value)
    call hitouch#DirectGGroupFGBG(a:group, 'fg', a:value)
endfunction
function! hitouch#DirectGGroupBG(group, value)
    call hitouch#DirectGGroupFGBG(a:group, 'bg', a:value)
endfunction

function! hitouch#DirectBGroupFG(group, value)
    call hitouch#DirectBGroupFGBG(a:group, 'fg', a:value)
endfunction
function! hitouch#DirectBGroupBG(group, value)
    call hitouch#DirectBGroupFGBG(a:group, 'bg', a:value)
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

function! hitouch#KelvinFG(kelvin)
    call s:ForeachHighlight(function('hitouch#KelvinGroupFG'), a:kelvin)
endfunction
function! hitouch#KelvinBG(kelvin)
    call s:ForeachHighlight(function('hitouch#KelvinGroupBG'), a:kelvin)
endfunction
function! hitouch#Kelvin(kelvin)
    call s:ForeachHighlight(function('hitouch#KelvinGroupFG'), a:kelvin)
    call s:ForeachHighlight(function('hitouch#KelvinGroupBG'), a:kelvin)
endfunction

function! hitouch#NearestFG(rgb, percent)
    call s:ForeachHighlight2(function('hitouch#NearestGroupFG'), a:rgb, a:percent)
endfunction
function! hitouch#NearestBG(rgb, percent)
    call s:ForeachHighlight2(function('hitouch#NearestGroupBG'), a:rgb, a:percent)
endfunction
function! hitouch#Nearest(rgb, percent)
    call s:ForeachHighlight2(function('hitouch#NearestGroupFG'), a:rgb, a:percent)
    call s:ForeachHighlight2(function('hitouch#NearestGroupBG'), a:rgb, a:percent)
endfunction

function! hitouch#NearestRFG(value, percent)
    call s:ForeachHighlight2(function('hitouch#NearestRGroupFG'), a:value, a:percent)
endfunction
function! hitouch#NearestRBG(value, percent)
    call s:ForeachHighlight2(function('hitouch#NearestRGroupBG'), a:value, a:percent)
endfunction
function! hitouch#NearestR(value, percent)
    call s:ForeachHighlight2(function('hitouch#NearestRGroupFG'), a:value, a:percent)
    call s:ForeachHighlight2(function('hitouch#NearestRGroupBG'), a:value, a:percent)
endfunction

function! hitouch#NearestGFG(value, percent)
    call s:ForeachHighlight2(function('hitouch#NearestGGroupFG'), a:value, a:percent)
endfunction
function! hitouch#NearestGBG(value, percent)
    call s:ForeachHighlight2(function('hitouch#NearestGGroupBG'), a:value, a:percent)
endfunction
function! hitouch#NearestG(value, percent)
    call s:ForeachHighlight2(function('hitouch#NearestGGroupFG'), a:value, a:percent)
    call s:ForeachHighlight2(function('hitouch#NearestGGroupBG'), a:value, a:percent)
endfunction

function! hitouch#NearestBFG(value, percent)
    call s:ForeachHighlight2(function('hitouch#NearestBGroupFG'), a:value, a:percent)
endfunction
function! hitouch#NearestBBG(value, percent)
    call s:ForeachHighlight2(function('hitouch#NearestBGroupBG'), a:value, a:percent)
endfunction
function! hitouch#NearestB(value, percent)
    call s:ForeachHighlight2(function('hitouch#NearestBGroupFG'), a:value, a:percent)
    call s:ForeachHighlight2(function('hitouch#NearestBGroupBG'), a:value, a:percent)
endfunction

function! hitouch#GammaFG(gamma)
    call s:ForeachHighlight(function('hitouch#GammaGroupFG'), a:gamma)
endfunction
function! hitouch#GammaBG(gamma)
    call s:ForeachHighlight(function('hitouch#GammaGroupBG'), a:gamma)
endfunction
function! hitouch#Gamma(gamma)
    call s:ForeachHighlight(function('hitouch#GammaGroupFG'), a:gamma)
    call s:ForeachHighlight(function('hitouch#GammaGroupBG'), a:gamma)
endfunction

function! hitouch#DirectFG(value)
    call s:ForeachHighlight(function('hitouch#DirectGroupFG'), a:value)
endfunction
function! hitouch#DirectBG(value)
    call s:ForeachHighlight(function('hitouch#DirectGroupBG'), a:value)
endfunction
function! hitouch#Direct(value)
    call s:ForeachHighlight(function('hitouch#DirectGroupFG'), a:value)
    call s:ForeachHighlight(function('hitouch#DirectGroupBG'), a:value)
endfunction

function! hitouch#DirectRFG(value)
    call s:ForeachHighlight(function('hitouch#DirectRGroupFG'), a:value)
endfunction
function! hitouch#DirectRBG(value)
    call s:ForeachHighlight(function('hitouch#DirectRGroupBG'), a:value)
endfunction
function! hitouch#DirectR(value)
    call s:ForeachHighlight(function('hitouch#DirectRGroupFG'), a:value)
    call s:ForeachHighlight(function('hitouch#DirectRGroupBG'), a:value)
endfunction

function! hitouch#DirectGFG(value)
    call s:ForeachHighlight(function('hitouch#DirectGGroupFG'), a:value)
endfunction
function! hitouch#DirectGBG(value)
    call s:ForeachHighlight(function('hitouch#DirectGGroupBG'), a:value)
endfunction
function! hitouch#DirectG(value)
    call s:ForeachHighlight(function('hitouch#DirectGGroupFG'), a:value)
    call s:ForeachHighlight(function('hitouch#DirectGGroupBG'), a:value)
endfunction

function! hitouch#DirectBFG(value)
    call s:ForeachHighlight(function('hitouch#DirectBGroupFG'), a:value)
endfunction
function! hitouch#DirectBBG(value)
    call s:ForeachHighlight(function('hitouch#DirectBGroupBG'), a:value)
endfunction
function! hitouch#DirectB(value)
    call s:ForeachHighlight(function('hitouch#DirectBGroupFG'), a:value)
    call s:ForeachHighlight(function('hitouch#DirectBGroupBG'), a:value)
endfunction
