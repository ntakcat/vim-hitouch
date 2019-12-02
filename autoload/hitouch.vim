function! hitouch#BrightnessGroup(group, fgbg, percent)
    let code = synIDattr(synIDtrans(hlID(a:group)), a:fgbg . '#')
    if code == ''
	if a:fgbg == 'fg'
	    let code = '#c0c0c0'
	else
	    let code = '#000000'
	endif
    endif
    let r = str2nr(strcharpart(code, 1, 2), 16)
    let g = str2nr(strcharpart(code, 3, 2), 16)
    let b = str2nr(strcharpart(code, 5, 2), 16)
    let r = a:percent ? r + (255 - r) * a:percent / 100 : r
    let g = a:percent ? g + (255 - g) * a:percent / 100 : g
    let b = a:percent ? b + (255 - b) * a:percent / 100 : b
    execute(printf("highlight %s %s=#%02x%02x%02x", a:group, 'gui' . a:fgbg, r, g, b))
endfunction

function! hitouch#DarknessGroup(group, fgbg, percent)
    let code = synIDattr(synIDtrans(hlID(a:group)), a:fgbg . '#')
    if code == ''
	if a:fgbg == 'fg'
	    let code = '#c0c0c0'
	else
	    let code = '#000000'
	endif
    endif
    let r = str2nr(strcharpart(code, 1, 2), 16)
    let g = str2nr(strcharpart(code, 3, 2), 16)
    let b = str2nr(strcharpart(code, 5, 2), 16)
    let r = a:percent ? r - r * a:percent / 100 : r
    let g = a:percent ? g - g * a:percent / 100 : g
    let b = a:percent ? b - b * a:percent / 100 : b
    execute(printf("highlight %s %s=#%02x%02x%02x", a:group, 'gui' . a:fgbg, r, g, b))
endfunction

function! hitouch#GrayscaleGroup(group, fgbg, percent)
    let code = synIDattr(synIDtrans(hlID(a:group)), a:fgbg . '#')
    if code == ''
	if a:fgbg == 'fg'
	    let code = '#c0c0c0'
	else
	    let code = '#080808'
	endif
    endif
    let r = str2nr(strcharpart(code, 1, 2), 16)
    let g = str2nr(strcharpart(code, 3, 2), 16)
    let b = str2nr(strcharpart(code, 5, 2), 16)
    let m = (2 * r + 4 * g + b) / 7
    let r = r - ((r - m) * a:percent) / 100
    let g = g - ((g - m) * a:percent) / 100
    let b = b - ((b - m) * a:percent) / 100
    execute(printf("highlight %s %s=#%02x%02x%02x", a:group, 'gui' . a:fgbg, r, g, b))
endfunction

function! hitouch#KelvinGroup(group, fgbg, kelvin)
    let code = synIDattr(synIDtrans(hlID(a:group)), a:fgbg . '#')
    if code == ''
	if a:fgbg == 'fg'
	    let code = '#c0c0c0'
	else
	    let code = '#000000'
	endif
    endif
    let r = str2nr(strcharpart(code, 1, 2), 16)
    let g = str2nr(strcharpart(code, 3, 2), 16)
    let b = str2nr(strcharpart(code, 5, 2), 16)
    let k = min([max([a:kelvin, 1000]), 40000]) / 100
    let lr = (k <= 66) ? 255 : min([max([329.69 * pow(k - 60, -0.13), 0]), 255])
    let lg = (k <= 66) ? min([max([float2nr(99.47 * log(k) - 161.11), 0]), 255]) : min([max([288.12 * pow(k - 60, -0.07), 0.0]), 255])
    let lb = (k >= 66) ? 255 : (k <= 19) ? 0 : min([max([float2nr(138.51 * log(k - 10) - 305.04), 0]), 255])
    let r = and((r * lr) / 256, 255)
    let g = and((g * lg) / 256, 255)
    let b = and((b * lb) / 256, 255)
    execute(printf("highlight %s %s=#%02x%02x%02x", a:group, 'gui' . a:fgbg, r, g, b))
endfunction

function! hitouch#Brightness(percent)
    for l in split(execute('highlight'), '\n')
	if match(l, 'cleared') == -1 && match(l, 'links') == -1
	    let n = substitute(l, '^\(\w*\).*$', '\1', '')
	    if n != ''
		call hitouch#BrightnessGroup(n, 'fg', a:percent)
		call hitouch#BrightnessGroup(n, 'bg', a:percent)
	    endif
	endif
    endfor
endfunction

function! hitouch#Darkness(percent)
    for l in split(execute('highlight'), '\n')
	if match(l, 'cleared') == -1 && match(l, 'links') == -1
	    let n = substitute(l, '^\(\w*\).*$', '\1', '')
	    if n != ''
		call hitouch#DarknessGroup(n, 'fg', a:percent)
		call hitouch#DarknessGroup(n, 'bg', a:percent)
	    endif
	endif
    endfor
endfunction

function! hitouch#Grayscale(percent)
    for l in split(execute('highlight'), '\n')
	if match(l, 'cleared') == -1 && match(l, 'links') == -1
	    let n = substitute(l, '^\(\w*\).*$', '\1', '')
	    if n != ''
		call hitouch#GrayscaleGroup(n, 'fg', a:percent)
		call hitouch#GrayscaleGroup(n, 'bg', a:percent)
	    endif
	endif
    endfor
endfunction

function! hitouch#Kelvin(kelvin)
    for l in split(execute('highlight'), '\n')
	if match(l, 'cleared') == -1 && match(l, 'links') == -1
	    let n = substitute(l, '^\(\w*\).*$', '\1', '')
	    if n != ''
		call hitouch#KelvinGroup(n, 'fg', a:kelvin)
		call hitouch#KelvinGroup(n, 'bg', a:kelvin)
	    endif
	endif
    endfor
endfunction
