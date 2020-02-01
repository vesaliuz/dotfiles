--      ███╗   ██╗ ██████╗ ████████╗██╗███████╗██╗ ██████╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗███████╗
--      ████╗  ██║██╔═══██╗╚══██╔══╝██║██╔════╝██║██╔════╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
--      ██╔██╗ ██║██║   ██║   ██║   ██║█████╗  ██║██║     ███████║   ██║   ██║██║   ██║██╔██╗ ██║███████╗
--      ██║╚██╗██║██║   ██║   ██║   ██║██╔══╝  ██║██║     ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║╚════██║
--      ██║ ╚████║╚██████╔╝   ██║   ██║██║     ██║╚██████╗██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║███████║
--      ╚═╝  ╚═══╝ ╚═════╝    ╚═╝   ╚═╝╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝

-- ===================================================================
-- Imports
-- ===================================================================


local naughty = require('naughty')
local beautiful = require('beautiful')
local gears = require('gears')
local wibox = require('wibox')
local awful = require('awful')
local dpi = require('beautiful').xresources.apply_dpi


-- ===================================================================
-- Variable Definitions
-- ===================================================================


-- Defaults
naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = dpi(32)
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.timeout = 5
naughty.config.defaults.shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(6)) end
naughty.config.defaults.title = 'System Notification'

-- Apply theme variables
naughty.config.padding = 8
naughty.config.spacing = 8
naughty.config.defaults.margin = dpi(16)
naughty.config.defaults.border_width = 0
naughty.config.defaults.position = 'top_right'

-- Timeouts
naughty.config.presets.low.timeout = 3
naughty.config.presets.critical.timeout = 0

naughty.config.presets.normal = {
  font         = beautiful.title_font,
  fg           = beautiful.fg_normal,
  bg           = beautiful.bg_normal,
  position     = 'top_right'
}

naughty.config.presets.low = {
  font         = beautiful.title_font,
  fg           = beautiful.fg_normal,
  bg           = beautiful.bg_normal,
  position     = 'top_right'
}

naughty.config.presets.critical = {
  font         = 'SF Display Bold 10',
  fg           = '#ffffff',
  bg           = '#ff0000',
  position     = 'top_right',
  timeout      = 0
}

naughty.config.presets.ok = naughty.config.presets.normal
naughty.config.presets.info = naughty.config.presets.normal
naughty.config.presets.warn = naughty.config.presets.critical


-- ===================================================================
-- Error Handling
-- ===================================================================


if awesome.startup_errors then
  naughty.notify(
    {
      preset = naughty.config.presets.critical,
      title = 'Oops, there were errors during startup!',
      text = awesome.startup_errors
    }
  )
end

do
  local in_error = false
  awesome.connect_signal(
    'debug::error',
    function(err)
      if in_error then
        return
      end
      in_error = true

      naughty.notify(
        {
          preset = naughty.config.presets.critical,
          title = 'Oops, an error happened!',
          text = tostring(err)
        }
      )
      in_error = false
    end
  )
end


-- ===================================================================
-- Notification Template Setup
-- ===================================================================


beautiful.notification_bg = "#00000000"
local notification_bg = beautiful.notification_bg

naughty.connect_signal("request::display", function(n)
  naughty.layout.box {
    notification = n,
    type = "splash",
    shape = gears.shape.rectangle,
    widget_template = {
      {
        {
          {
            {
              {
                {
                  {
                    {
                      -- TITLE
                      {
                        {
                          {
                            align = "center",
                            widget = naughty.widget.title,
                          },
                          margins = beautiful.notification_margin,
                          widget  = wibox.container.margin,
                        },
                        -- BG of Titlebar
                        bg = '#000000'.. '44',
                        widget  = wibox.container.background,
                      },
                      -- ICON And Message
                      {
                        {
                          {
                            resize_strategy = 'center',
                            widget = naughty.widget.icon,
                          },
                          margins = dpi(5),
                          widget  = wibox.container.margin,
                        },
                        {
                          {
                            align = "center",
                            widget = naughty.widget.message,
                          },
                          margins = beautiful.notification_margin,
                          widget  = wibox.container.margin,
                        },
                        layout = wibox.layout.fixed.horizontal,
                      },
                      fill_space = true,
                      spacing = beautiful.notification_margin,
                      layout  = wibox.layout.fixed.vertical,
                    },
                    -- Margin between the fake background
                    -- Set to 0 to preserve the 'titlebar' effect
                    margins = dpi(0),
                    widget  = wibox.container.margin,
                  },
                  bg = notification_bg,
                  widget  = wibox.container.background,
                },
                -- Notification action list
                naughty.list.actions,
                spacing = dpi(4),
                layout  = wibox.layout.fixed.vertical,
              },
              bg     = "#00000000",
              id     = "background_role",
              widget = naughty.container.background,
            },
            strategy = "min",
            width    = dpi(160),
            widget   = wibox.container.constraint,
          },
          strategy = "max",
          width    = beautiful.notification_max_width or dpi(500),
          widget   = wibox.container.constraint,
        },
        -- Anti-aliasing container
        -- Real BG
        bg = beautiful.bg_normal,
        -- This will be the anti-aliased shape of the notification
        shape = gears.shape.rounded_rect,
        widget = wibox.container.background
      },
      -- Margin of the fake BG to have a space between notification and the screen edge
      margins = beautiful.notification_margin,
      widget  = wibox.container.margin
    }
  }
end)
