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

function! s:ForeachHighlight(match, name, fgbg, arg1)
    for l in split(execute('highlight'), '\n')
	if match(l, 'cleared\|links') == -1
	    let s = matchstr(substitute(l, '^\(\w*\).*$', '\1', ''), a:match)
	    if s != ''
		let s:f = function('s:' . a:name . 'Group', [s, a:fgbg, a:arg1])
		call s:f()
	    endif
	endif
    endfor
endfunction

function! s:ForeachHighlightDirect(group, name, fgbg, arg1)
    let s:f = function('s:' . a:name . 'Group', [a:group, a:fgbg, a:arg1])
    call s:f()
endfunction

function! s:ForeachHighlight2(match, name, fgbg, arg1, arg2)
    for l in split(execute('highlight'), '\n')
	if match(l, 'cleared\|links') == -1
	    let s = matchstr(substitute(l, '^\(\w*\).*$', '\1', ''), a:match)
	    if s != ''
		let s:f = function('s:' . a:name . 'Group', [s, a:fgbg, a:arg1, a:arg2])
		call s:f()
	    endif
	endif
    endfor
endfunction

function! s:BrightnessGroup(group, fgbg, percent)
    let [r, g, b] = s:GetRGB(s:GetCode(a:group, a:fgbg))
    let r = a:percent ? r + (255 - r) * a:percent / 100 : r
    let g = a:percent ? g + (255 - g) * a:percent / 100 : g
    let b = a:percent ? b + (255 - b) * a:percent / 100 : b
    call s:Highlight(a:group, a:fgbg, r, g, b)
endfunction
function! hitouch#Brightness(percent)
    call hitouch#BrightnessFG(a:percent)
    call hitouch#BrightnessBG(a:percent)
endfunction
function! hitouch#BrightnessFG(percent)
    call hitouch#BrightnessGroupFG('.*', a:percent)
endfunction
function! hitouch#BrightnessBG(percent)
    call hitouch#BrightnessGroupBG('.*', a:percent)
endfunction
function! hitouch#BrightnessGroup(group, percent)
    call hitouch#BrightnessGroupFG(a:group, a:percent)
    call hitouch#BrightnessGroupBG(a:group, a:percent)
endfunction
function! hitouch#BrightnessGroupFG(group, percent)
    call hitouch#BrightnessGroupFGBG(a:group, 'fg', a:percent)
endfunction
function! hitouch#BrightnessGroupBG(group, percent)
    call hitouch#BrightnessGroupFGBG(a:group, 'bg', a:percent)
endfunction
function! hitouch#BrightnessGroupFGBG(group, fgbg, percent)
    call s:ForeachHighlight(a:group, 'Brightness', a:fgbg, a:percent)
endfunction

function! s:DarknessGroup(group, fgbg, percent)
    let [r, g, b] = s:GetRGB(s:GetCode(a:group, a:fgbg))
    let r = a:percent ? r - r * a:percent / 100 : r
    let g = a:percent ? g - g * a:percent / 100 : g
    let b = a:percent ? b - b * a:percent / 100 : b
    call s:Highlight(a:group, a:fgbg, r, g, b)
endfunction
function! hitouch#Darkness(percent)
    call hitouch#DarknessFG(a:percent)
    call hitouch#DarknessBG(a:percent)
endfunction
function! hitouch#DarknessFG(percent)
    call hitouch#DarknessGroupFG('.*', a:percent)
endfunction
function! hitouch#DarknessBG(percent)
    call hitouch#DarknessGroupBG('.*', a:percent)
endfunction
function! hitouch#DarknessGroup(group, percent)
    call hitouch#DarknessGroupFG(a:group, a:percent)
    call hitouch#DarknessGroupBG(a:group, a:percent)
endfunction
function! hitouch#DarknessGroupFG(group, percent)
    call hitouch#DarknessGroupFGBG(a:group, 'fg', a:percent)
endfunction
function! hitouch#DarknessGroupBG(group, percent)
    call hitouch#DarknessGroupFGBG(a:group, 'bg', a:percent)
endfunction
function! hitouch#DarknessGroupFGBG(group, fgbg, percent)
    call s:ForeachHighlight(a:group, 'Darkness', a:fgbg, a:percent)
endfunction

function! s:GrayscaleGroup(group, fgbg, percent)
    let [r, g, b] = s:GetRGB(s:GetCode(a:group, a:fgbg))
    let m = (2 * r + 4 * g + b) / 7
    let r = r - ((r - m) * a:percent) / 100
    let g = g - ((g - m) * a:percent) / 100
    let b = b - ((b - m) * a:percent) / 100
    call s:Highlight(a:group, a:fgbg, r, g, b)
endfunction
function! hitouch#Grayscale(percent)
    call hitouch#GrayscaleFG(a:percent)
    call hitouch#GrayscaleBG(a:percent)
endfunction
function! hitouch#GrayscaleFG(percent)
    call hitouch#GrayscaleGroupFG('.*', a:percent)
endfunction
function! hitouch#GrayscaleBG(percent)
    call hitouch#GrayscaleGroupBG('.*', a:percent)
endfunction
function! hitouch#GrayscaleGroup(group, percent)
    call hitouch#GrayscaleGroupFG(a:group, a:percent)
    call hitouch#GrayscaleGroupBG(a:group, a:percent)
endfunction
function! hitouch#GrayscaleGroupFG(group, percent)
    call hitouch#GrayscaleGroupFGBG(a:group, 'fg', a:percent)
endfunction
function! hitouch#GrayscaleGroupBG(group, percent)
    call hitouch#GrayscaleGroupFGBG(a:group, 'bg', a:percent)
endfunction
function! hitouch#GrayscaleGroupFGBG(group, fgbg, percent)
    call s:ForeachHighlight(a:group, 'Grayscale', a:fgbg, a:percent)
endfunction

function! s:KelvinGroup(group, fgbg, kelvin)
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
function! hitouch#Kelvin(kelvin)
    call hitouch#KelvinFG(a:kelvin)
    call hitouch#KelvinBG(a:kelvin)
endfunction
function! hitouch#KelvinFG(kelvin)
    call hitouch#KelvinGroupFG('.*', a:kelvin)
endfunction
function! hitouch#KelvinBG(kelvin)
    call hitouch#KelvinGroupBG('.*', a:kelvin)
endfunction
function! hitouch#KelvinGroup(group, kelvin)
    call hitouch#KelvinGroupFG(a:group, a:kelvin)
    call hitouch#KelvinGroupBG(a:group, a:kelvin)
endfunction
function! hitouch#KelvinGroupFG(group, kelvin)
    call hitouch#KelvinGroupFGBG(a:group, 'fg', a:kelvin)
endfunction
function! hitouch#KelvinGroupBG(group, kelvin)
    call hitouch#KelvinGroupFGBG(a:group, 'bg', a:kelvin)
endfunction
function! hitouch#KelvinGroupFGBG(group, fgbg, kelvin)
    call s:ForeachHighlight(a:group, 'Kelvin', a:fgbg, a:kelvin)
endfunction

function! s:NearestGroup(group, fgbg, rgb, percent)
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
function! hitouch#Nearest(rgb, percent)
    call hitouch#NearestFG(a:rgb, a:percent)
    call hitouch#NearestBG(a:rgb, a:percent)
endfunction
function! hitouch#NearestFG(rgb, percent)
    call hitouch#NearestGroupFG('.*', a:rgb, a:percent)
endfunction
function! hitouch#NearestBG(rgb, percent)
    call hitouch#NearestGroupBG('.*', a:rgb, a:percent)
endfunction
function! hitouch#NearestGroup(group, rgb, percent)
    call hitouch#NearestGroupFG(a:group, a:rgb, a:percent)
    call hitouch#NearestGroupBG(a:group, a:rgb, a:percent)
endfunction
function! hitouch#NearestGroupFG(group, rgb, percent)
    call hitouch#NearestGroupFGBG(a:group, 'fg', a:rgb, a:percent)
endfunction
function! hitouch#NearestGroupBG(group, rgb, percent)
    call hitouch#NearestGroupFGBG(a:group, 'bg', a:rgb, a:percent)
endfunction
function! hitouch#NearestGroupFGBG(group, fgbg, rgb, percent)
    call s:ForeachHighlight2(a:group, 'Nearest', a:fgbg, a:rgb, a:percent)
endfunction

function! s:NearestRGroup(group, fgbg, value, percent)
    let value = s:GetHex(a:value)
    let [r, g, b] = s:GetRGB(s:GetCode(a:group, a:fgbg))
    if r > value
	let r = r - (r - value) * a:percent / 100
    else
	let r = r + (value - r) * a:percent / 100
    endif
    call s:Highlight(a:group, a:fgbg, r, g, b)
endfunction
function! hitouch#NearestR(rgb, percent)
    call hitouch#NearestRFG(a:rgb, a:percent)
    call hitouch#NearestRBG(a:rgb, a:percent)
endfunction
function! hitouch#NearestRFG(rgb, percent)
    call hitouch#NearestRGroupFG('.*', a:rgb, a:percent)
endfunction
function! hitouch#NearestRBG(rgb, percent)
    call hitouch#NearestRGroupBG('.*', a:rgb, a:percent)
endfunction
function! hitouch#NearestRGroup(group, rgb, percent)
    call hitouch#NearestRGroupFG(a:group, a:rgb, a:percent)
    call hitouch#NearestRGroupBG(a:group, a:rgb, a:percent)
endfunction
function! hitouch#NearestRGroupFG(group, rgb, percent)
    call hitouch#NearestRGroupFGBG(a:group, 'fg', a:rgb, a:percent)
endfunction
function! hitouch#NearestRGroupBG(group, rgb, percent)
    call hitouch#NearestRGroupFGBG(a:group, 'bg', a:rgb, a:percent)
endfunction
function! hitouch#NearestRGroupFGBG(group, fgbg, rgb, percent)
    call s:ForeachHighlight2(a:group, 'NearestR', a:fgbg, a:rgb, a:percent)
endfunction

function! s:NearestGGroup(group, fgbg, value, percent)
    let value = s:GetHex(a:value)
    let [r, g, b] = s:GetRGB(s:GetCode(a:group, a:fgbg))
    if g > value
	let g = g - (g - value) * a:percent / 100
    else
	let g = g + (value - g) * a:percent / 100
    endif
    call s:Highlight(a:group, a:fgbg, r, g, b)
endfunction
function! hitouch#NearestG(rgb, percent)
    call hitouch#NearestGFG(a:rgb, a:percent)
    call hitouch#NearestGBG(a:rgb, a:percent)
endfunction
function! hitouch#NearestGFG(rgb, percent)
    call hitouch#NearestGGroupFG('.*', a:rgb, a:percent)
endfunction
function! hitouch#NearestGBG(rgb, percent)
    call hitouch#NearestGGroupBG('.*', a:rgb, a:percent)
endfunction
function! hitouch#NearestGGroup(group, rgb, percent)
    call hitouch#NearestGGroupFG(a:group, a:rgb, a:percent)
    call hitouch#NearestGGroupBG(a:group, a:rgb, a:percent)
endfunction
function! hitouch#NearestGGroupFG(group, rgb, percent)
    call hitouch#NearestGGroupFGBG(a:group, 'fg', a:rgb, a:percent)
endfunction
function! hitouch#NearestGGroupBG(group, rgb, percent)
    call hitouch#NearestGGroupFGBG(a:group, 'bg', a:rgb, a:percent)
endfunction
function! hitouch#NearestGGroupFGBG(group, fgbg, rgb, percent)
    call s:ForeachHighlight2(a:group, 'NearestG', a:fgbg, a:rgb, a:percent)
endfunction

function! s:NearestBGroup(group, fgbg, value, percent)
    let value = s:GetHex(a:value)
    let [r, g, b] = s:GetRGB(s:GetCode(a:group, a:fgbg))
    if b > value
	let b = b - (b - value) * a:percent / 100
    else
	let b = b + (value - b) * a:percent / 100
    endif
    call s:Highlight(a:group, a:fgbg, r, g, b)
endfunction
function! hitouch#NearestB(rgb, percent)
    call hitouch#NearestBFG(a:rgb, a:percent)
    call hitouch#NearestBBG(a:rgb, a:percent)
endfunction
function! hitouch#NearestBFG(rgb, percent)
    call hitouch#NearestBGroupFG('.*', a:rgb, a:percent)
endfunction
function! hitouch#NearestBBG(rgb, percent)
    call hitouch#NearestBGroupBG('.*', a:rgb, a:percent)
endfunction
function! hitouch#NearestBGroup(group, rgb, percent)
    call hitouch#NearestBGroupFG(a:group, a:rgb, a:percent)
    call hitouch#NearestBGroupBG(a:group, a:rgb, a:percent)
endfunction
function! hitouch#NearestBGroupFG(group, rgb, percent)
    call hitouch#NearestBGroupFGBG(a:group, 'fg', a:rgb, a:percent)
endfunction
function! hitouch#NearestBGroupBG(group, rgb, percent)
    call hitouch#NearestBGroupFGBG(a:group, 'bg', a:rgb, a:percent)
endfunction
function! hitouch#NearestBGroupFGBG(group, fgbg, rgb, percent)
    call s:ForeachHighlight2(a:group, 'NearestB', a:fgbg, a:rgb, a:percent)
endfunction

function! s:GammaGroup(group, fgbg, gamma)
    let [r, g, b] = s:GetRGB(s:GetCode(a:group, a:fgbg))
    let r = float2nr(pow(r / 255.0, a:gamma / 10.0) * 255)
    let g = float2nr(pow(g / 255.0, a:gamma / 10.0) * 255)
    let b = float2nr(pow(b / 255.0, a:gamma / 10.0) * 255)
    call s:Highlight(a:group, a:fgbg, r, g, b)
endfunction
function! hitouch#Gamma(gamma)
    call hitouch#GammaFG(a:gamma)
    call hitouch#GammaBG(a:gamma)
endfunction
function! hitouch#GammaFG(gamma)
    call hitouch#GammaGroupFG('.*', a:gamma)
endfunction
function! hitouch#GammaBG(gamma)
    call hitouch#GammaGroupBG('.*', a:gamma)
endfunction
function! hitouch#GammaGroup(group, gamma)
    call hitouch#GammaGroupFG(a:group, a:gamma)
    call hitouch#GammaGroupBG(a:group, a:gamma)
endfunction
function! hitouch#GammaGroupFG(group, gamma)
    call hitouch#GammaGroupFGBG(a:group, 'fg', a:gamma)
endfunction
function! hitouch#GammaGroupBG(group, gamma)
    call hitouch#GammaGroupFGBG(a:group, 'bg', a:gamma)
endfunction
function! hitouch#GammaGroupFGBG(group, fgbg, gamma)
    call s:ForeachHighlight(a:group, 'Gamma', a:fgbg, a:gamma)
endfunction

function! s:DirectGroup(group, fgbg, value)
    if strcharpart(a:value, 0, 1) == '#'
	let [r, g, b] = s:GetRGB(a:value)
	call s:Highlight(a:group, a:fgbg, r, g, b)
    else
	call s:HighlightString(a:group, a:fgbg, a:value)
    endif
endfunction
function! hitouch#Direct(value)
    call hitouch#DirectFG(a:value)
    call hitouch#DirectBG(a:value)
endfunction
function! hitouch#DirectFG(value)
    call hitouch#DirectGroupFG('.*', a:value)
endfunction
function! hitouch#DirectBG(value)
    call hitouch#DirectGroupBG('.*', a:value)
endfunction
function! hitouch#DirectGroup(group, value)
    call hitouch#DirectGroupFG(a:group, a:value)
    call hitouch#DirectGroupBG(a:group, a:value)
endfunction
function! hitouch#DirectGroupFG(group, value)
    call hitouch#DirectGroupFGBG(a:group, 'fg', a:value)
endfunction
function! hitouch#DirectGroupBG(group, value)
    call hitouch#DirectGroupFGBG(a:group, 'bg', a:value)
endfunction
function! hitouch#DirectGroupFGBG(group, fgbg, value)
    call s:ForeachHighlightDirect(a:group, 'Direct', a:fgbg, a:value)
endfunction

function! s:DirectRGroup(group, fgbg, value)
    let [r, g, b] = s:GetRGB(s:GetCode(a:group, a:fgbg))
    let r = s:GetHex(a:value)
    call s:Highlight(a:group, a:fgbg, r, g, b)
endfunction
function! hitouch#DirectR(value)
    call hitouch#DirectRFG(a:value)
    call hitouch#DirectRBG(a:value)
endfunction
function! hitouch#DirectRFG(value)
    call hitouch#DirectRGroupFG('.*', a:value)
endfunction
function! hitouch#DirectRBG(value)
    call hitouch#DirectRGroupBG('.*', a:value)
endfunction
function! hitouch#DirectRGroup(group, value)
    call hitouch#DirectRGroupFG(a:group, a:value)
    call hitouch#DirectRGroupBG(a:group, a:value)
endfunction
function! hitouch#DirectRGroupFG(group, value)
    call hitouch#DirectRGroupFGBG(a:group, 'fg', a:value)
endfunction
function! hitouch#DirectRGroupBG(group, value)
    call hitouch#DirectRGroupFGBG(a:group, 'bg', a:value)
endfunction
function! hitouch#DirectRGroupFGBG(group, fgbg, value)
    call s:ForeachHighlight(a:group, 'DirectR', a:fgbg, a:value)
endfunction

function! s:DirectGGroup(group, fgbg, value)
    let [r, g, b] = s:GetRGB(s:GetCode(a:group, a:fgbg))
    let g = s:GetHex(a:value)
    call s:Highlight(a:group, a:fgbg, r, g, b)
endfunction
function! hitouch#DirectG(value)
    call hitouch#DirectGFG(a:value)
    call hitouch#DirectGBG(a:value)
endfunction
function! hitouch#DirectGFG(value)
    call hitouch#DirectGGroupFG('.*', a:value)
endfunction
function! hitouch#DirectGBG(value)
    call hitouch#DirectGGroupBG('.*', a:value)
endfunction
function! hitouch#DirectGGroup(group, value)
    call hitouch#DirectGGroupFG(a:group, a:value)
    call hitouch#DirectGGroupBG(a:group, a:value)
endfunction
function! hitouch#DirectGGroupFG(group, value)
    call hitouch#DirectGGroupFGBG(a:group, 'fg', a:value)
endfunction
function! hitouch#DirectGGroupBG(group, value)
    call hitouch#DirectGGroupFGBG(a:group, 'bg', a:value)
endfunction
function! hitouch#DirectGGroupFGBG(group, fgbg, value)
    call s:ForeachHighlight(a:group, 'DirectG', a:fgbg, a:value)
endfunction

function! s:DirectBGroup(group, fgbg, value)
    let [r, g, b] = s:GetRGB(s:GetCode(a:group, a:fgbg))
    let b = s:GetHex(a:value)
    call s:Highlight(a:group, a:fgbg, r, g, b)
endfunction
function! hitouch#DirectB(value)
    call hitouch#DirectBFG(a:value)
    call hitouch#DirectBBG(a:value)
endfunction
function! hitouch#DirectBFG(value)
    call hitouch#DirectBGroupFG('.*', a:value)
endfunction
function! hitouch#DirectBBG(value)
    call hitouch#DirectBGroupBG('.*', a:value)
endfunction
function! hitouch#DirectBGroup(group, value)
    call hitouch#DirectBGroupFG(a:group, a:value)
    call hitouch#DirectBGroupBG(a:group, a:value)
endfunction
function! hitouch#DirectBGroupFG(group, value)
    call hitouch#DirectBGroupFGBG(a:group, 'fg', a:value)
endfunction
function! hitouch#DirectBGroupBG(group, value)
    call hitouch#DirectBGroupFGBG(a:group, 'bg', a:value)
endfunction
function! hitouch#DirectBGroupFGBG(group, fgbg, value)
    call s:ForeachHighlight(a:group, 'DirectB', a:fgbg, a:value)
endfunction
