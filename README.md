## What is this? ##
Change the color of Vim. Implemented Brightness, Darkness, Grayscale and Kelvin.

## :Brightness ##
Brighten up. The numbers that can be used are 0-100. If it is 0, nothing will change. If it is 50, it will be about 50% brighter.

## :Darkness ##
Darken. The usable value is 0-100. It is the opposite of Brightness.

## :Grayscale ##
Make it lighter. 0-100, the higher the number, the whiter it becomes.

## :Kelvin ##
Change the color temperature. Centering on 6500, the value is red when the value is small and blue when it is large.

## Note ##
Even colors that look the same will not be the same if they are slightly different. In addition, since the current color is changed, the effect is strong as many times as the command is executed.

From .vimrc you have to call decorated functions like 'hitouch#Brightness()'.

## License ##
Same as vim.