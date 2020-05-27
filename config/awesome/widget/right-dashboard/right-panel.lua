local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local HOME = os.getenv('HOME')

local apps = require('configuration.apps')
local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widget.material.clickable-container')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/right-dashboard/icons/'
local mat_list_item = require('widget.material.list-item')



panel_visible = false

local right_panel = function(screen)
  local panel_width = dpi(350)
  local panel = wibox {
    ontop = true,
    screen = screen,
    width = panel_width,
    height = screen.geometry.height,
    opacity = 1.0,
    x = screen.geometry.width - panel_width,
    bg = beautiful.background.hue_900,
    fg = beautiful.fg_normal,
  }

  panel.opened = false

  local backdrop = wibox
  {
    ontop = true,
    screen = screen,
    bg = '#00000000',
    type = 'dock',
    x = screen.geometry.x,
    y = screen.geometry.y,
    width = screen.geometry.width,
    height = screen.geometry.height
  }

  panel:struts(
    {
      right = 0
    }
  )
  openPanel = function()
    _G.switch_mode('widgets_mode')
    panel_visible = true
    backdrop.visible = true
    panel.visible = true
    panel:emit_signal('opened')
  end

  closePanel = function()
    panel_visible = false
    panel.visible = false
    backdrop.visible = false
    panel:emit_signal('closed')
  end

  -- Hide this panel when app dashboard is called.
  function panel:HideDashboard()
    closePanel()
  end

  function panel:toggle()
    self.opened = not self.opened
    if self.opened then
      openPanel()
    else
      closePanel()
    end
  end


  function panel:switch_mode(mode)
    if mode == 'notif_mode' then
      -- Update Content
      panel:get_children_by_id('notif_id')[1].visible = true
      panel:get_children_by_id('widgets_id')[1].visible = false
    elseif mode == 'widgets_mode' then
      -- Update Content
      panel:get_children_by_id('notif_id')[1].visible = false
      panel:get_children_by_id('widgets_id')[1].visible = true
    end
  end

  backdrop:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          panel:toggle()
        end
      )
    )
  )


  local separator = wibox.widget {
    orientation = 'horizontal',
    opacity = 0.0,
    forced_height = 15,
    widget = wibox.widget.separator,
  }

  panel:setup {
    expand = 'none',
    layout = wibox.layout.fixed.vertical,
    separator,
    {
      expand = 'none',
      layout = wibox.layout.align.horizontal,
      {
        nil,
        layout = wibox.layout.fixed.horizontal,
      },
      require('widget.right-dashboard.subwidgets.panel-mode-switcher'),
      {
        nil,
        layout = wibox.layout.fixed.horizontal,
      },
    },
    separator,
    {
      layout = wibox.layout.stack,
      -- Notification Center
      {
        id = 'notif_id',
        visible = true,
        separator,
        {
          {
            layout = wibox.layout.fixed.vertical,
            require('widget.notif-center'),
          },
          left = dpi(15),
          right = dpi(15),
          widget = wibox.container.margin
        },
        layout = wibox.layout.fixed.vertical,
      },
      -- Widget Center
      {
        id = 'widgets_id',
        visible = false,
        layout = wibox.layout.fixed.vertical,
        separator,
        {
          wibox.container.margin(require('widget.user-profile'), dpi(15), dpi(15), dpi(0), dpi(10)),
          layout = wibox.layout.fixed.vertical,
        },
        {
          wibox.container.margin(require('widget.weather'), dpi(15), dpi(15), dpi(10), dpi(5)),
          layout = wibox.layout.fixed.vertical,
        },
     separator,
			-- ## Music box ## --
		layout = wibox.layout.fixed.vertical,
		spacing = dpi(8),
		{
			layout = wibox.layout.fixed.vertical,
			{
			  spacing = dpi(4),
			  layout = wibox.layout.fixed.vertical,
			  {
				require('widget.music.content.progress-bar'),
				left = dpi(15),
				right = dpi(15),
				widget = wibox.container.margin,
			  },
			  
			  {
				require('widget.music.content.track-time').time_track,
				left = dpi(15),
				right = dpi(15),
				widget = wibox.container.margin,
			  },
			},
			
			{
			  require('widget.music.content.song-info').music_info,
			  left = dpi(15),
			  right = dpi(15),
			  widget = wibox.container.margin,
			},
			

			{
			  require('widget.music.content.media-buttons').navigate_buttons,
			  left = dpi(15),
			  right = dpi(15),
			  widget = wibox.container.margin,
			},
			
			{
			  require('widget.music.content.media-buttons').slider,
		          left = dpi(15),
			  right = dpi(15),
			  widget = wibox.container.margin,
			},

		},
			-- ## End of music box ## --	
	require('layout.left-panel.dashboard.quick-settings'),
	separator,
	--

	--
        {
          wibox.container.margin(require('widget.calculator'), dpi(15), dpi(15), dpi(0), dpi(0)),
          layout = wibox.layout.fixed.vertical,
        },

      }

    }

  }


  return panel
end


return right_panel


