## What is this? ##
Change the color of Vim. Implemented Brightness, Darkness, Grayscale, Kelvin and Nearest.

## :Brightness ##
Brighten up. The numbers that can be used are 0-100. If it is 0, nothing will change. If it is 50, it will be about 50% brighter.
hitouch#Brightness(percent)
hitouch#BrightnessFG(percent)
hitouch#BrightnessBG(percent)
hitouch#BrightnessGroup(group, percent)
hitouch#BrightnessGroupFG(group, percent)
hitouch#BrightnessGroupBG(group, percent)

## :Darkness ##
Darken. The usable value is 0-100. It is the opposite of Brightness.
hitouch#Darkness(percent)
hitouch#DarknessFG(percent)
hitouch#DarknessBG(percent)
hitouch#DarknessGroup(group, percent)
hitouch#DarknessGroupFG(group, percent)
hitouch#DarknessGroupBG(group, percent)

## :Grayscale ##
Make it lighter. 0-100, the higher the number, the whiter it becomes.
hitouch#Grayscale(percent)
hitouch#GrayscaleFG(percent)
hitouch#GrayscaleBG(percent)
hitouch#GrayscaleGroup(group, percent)
hitouch#GrayscaleGroupFG(group, percent)
hitouch#GrayscaleGroupBG(group, percent)

## :Kelvin ##
Change the color temperature. Centering on 6500, the value is red when the value is small and blue when it is large.
hitouch#Kelvin(percent)
hitouch#KelvinFG(percent)
hitouch#KelvinBG(percent)
hitouch#KelvinGroup(group, percent)
hitouch#KelvinGroupFG(group, percent)
hitouch#KelvinGroupBG(group, percent)

## :Nearest ##
Approximates the specified color. If you apply half the pure blue ('#0000FF', 50).
hitouch#Nearest(rgb, percent)
hitouch#NearestFG(rgb, percent)
hitouch#NearestBG(rgb, percent)
hitouch#NearestGroup(group, rgb, percent)
hitouch#NearestGroupFG(group, rgb, percent)
hitouch#NearestGroupBG(group, rgb, percent)

## Note ##
Even colors that look the same will not be the same if they are slightly different. In addition, since the current color is changed, the effect is strong as many times as the command is executed.

From .vimrc you have to call decorated functions like 'hitouch#Brightness()'.

You may need to run :packloadall beforehand.

## License ##
Same as vim.
