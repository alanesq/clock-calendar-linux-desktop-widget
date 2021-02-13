# clock-calendar-linux-desktop-widget

<p align="center"><img src="/clock.png"/></p>

I was asked to provide an analog clock and calendar widget for the linux desktop but I struggled to find and easy to understand
example of how to do this so I am providing the solution I found in case it is of use/interest to anyone else

There are two files required:
      Lindas-Clock.conkey = a konkey file which displays the current month as a calendar 
      Lindas-Clock.lua = a LUA file which displays the clock

Install Conkey with the commands:
      sudo apt-get install conkey
      sudo apt-get install conkey-all

Note: you will need to change the location of the file in 'Lindas-Clock.conkey' to wherever you have saved the files to
      i.e. 'lua_load = '~/apps/Lindas-Clock/Lindas-Clock.lua','

Then start the widget with the command 'conky -c Lindas-Clock.conkey'

Note: This is not all my own work but includes bits of code, modified found from several places (sadly I have lost the links to them)
