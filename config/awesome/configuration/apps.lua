local filesystem = require('gears.filesystem')

return {
  -- List of apps to start by default on some actions
  default = {
    terminal = 'termite',
    editor = 'gvim',
    rofi = 'rofi -show Search -modi Search:' .. filesystem.get_configuration_dir() .. '/configuration/rofi/sidebar/rofi-web-search.py' ..
      ' -theme ' .. filesystem.get_configuration_dir() .. '/configuration/rofi/sidebar/rofi.rasi',
    rofiappmenu = 'rofi -show drun -theme ' .. filesystem.get_configuration_dir() .. '/configuration/rofi/appmenu/drun.rasi',
    lock = 'mantablockscreen -sc',
    quake = 'kitty --name QuakeTerminal'
  },
  -- List of apps to start once on start-up
  run_on_start_up = {
    'compton --dbus --config ' .. filesystem.get_configuration_dir() .. '/configuration/compton.conf', -- Compositor
    'blueman-applet', -- Bluetooth tray icon
    'xfce4-power-manager --no-daemon --debug', -- Power manager
    '/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)', -- credential manager
    'xrdb $HOME/.Xresources', -- X Colors
    'nm-applet', -- NetworkManager Applet
    'mpd', -- Music Server
    'pulseeffects --gapplication-service', -- Equalizer
    'redshift-gtk -l 14.45:121.05', -- Redshift
    'albert'
  },

  -- List of binaries and functions to execute a certain task
  bins = {
    fullShot = require('binaries.snap').fullmode,
    areaShot = require('binaries.snap').areamode,
    selectShot = require('binaries.snap').selectmode,
    enableBlur = require('binaries.togglewinfx').enable,
    disableBlur = require('binaries.togglewinfx').disable,
    coverUpdate = require('binaries.extractcover').extractalbum
  }
}
