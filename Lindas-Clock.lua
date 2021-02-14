--[[

    Clock for use with Conky written in Lua - 14Feb21
        modified from original code: https://github.com/fxthomas/conky/blob/master/clock.lua

    Call this script in Conky using the following before TEXT 
        lua_load = '~/apps/Lindas-Clock/Lindas-Clock.lua',
        lua_draw_hook_pre = 'draw_clock',

    Cairo info see: https://luapower.com/cairo , https://www.cairographics.org/tutorial/

]]

-----------------------------------------------------------------------------


require 'cairo'

function conky_draw_clock()
    if conky_window==nil then return end
    local w=conky_window.width
    local h=conky_window.height
    local cs=cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, w, h)
    cr=cairo_create(cs)
            
    
    --------------------------------------------------------------------
    
    
    --                         S e t t i n g s
    

        local clock_r=100                  -- Radius of the clock face (not including border) (in pixels)
        
        local xc=w/2                       -- x and y coordinates of clock center
        local yc=h-(w/2)
        
        show_seconds=true                  -- show the seconds hand (true/false)
        
        show_text=true                     -- show the text on the clock face (true/false)
        
        show_scale=true                    -- show the scale around clock face (true/false)
        
        handOpacity = 0.75                 -- hand opacity (0-1)
        
        secondHandLength = 0.96            -- length of the hands (0-1) 
        minuteHandLength = 0.87 
          hourHandLength = 0.50  
            
        secondHandWidth = 2                -- width of the hand (pixels)
        minuteHandWidth = 6  
          hourHandWidth = 8                 
        
        
    --------------------------------------------------------------------
            
            
    -- Get current time
        local hours=os.date("%I")
        local mins=os.date("%M")
        local secs=os.date("%S")
        
    -- calculate arcs for hands around clock face
        secs_arc=(2*math.pi/60) * secs
        mins_arc=(2*math.pi/60) * mins 
        hours_arc=(2*math.pi/12) * hours
        
    -- adjust arcs for smooth movement of hands
        mins_arc = mins_arc + (secs_arc / 60)
        hours_arc = hours_arc + (mins_arc / 12)
                         
    -- draw outer clock face
        local border_pat=cairo_pattern_create_linear(xc,yc-clock_r*1.25,xc,yc+clock_r*1.25)
        cairo_pattern_add_color_stop_rgb(border_pat,0.8,0.4,0,0.4)   -- clock border colour
        cairo_pattern_add_color_stop_rgb(border_pat,0.2,0.6,0,0.6)   -- clock border colour
        cairo_set_source(cr,border_pat)
        cairo_arc(cr,xc,yc,clock_r*1.125,0,2*math.pi)
        cairo_close_path(cr)
        cairo_set_line_width(cr,clock_r*0.25)
        cairo_stroke(cr)
    
    -- draw inner clock face
        cairo_arc(cr,xc,yc,clock_r,0,2*math.pi)
        local face_pat=cairo_pattern_create_radial(xc,yc+clock_r*0.75,0,xc,yc,clock_r)
        cairo_pattern_add_color_stop_rgb(face_pat,.3,0.65,0,0.6)   -- clock inner face colour
        cairo_pattern_add_color_stop_rgb(face_pat,.8,0.5,0,0.6)    -- clock inner face colour
        cairo_set_source(cr,face_pat)
        cairo_fill_preserve(cr)
        cairo_close_path(cr)
        cairo_set_line_width(cr, 1)
        cairo_stroke(cr) 
    
    -- draw markings around the clock face
        if show_scale then
            local mins
            cairo_set_source_rgb (cr, 0.1, 0.5, 0.5);     -- colour of the markings
            -- Minutes
                for i = 1,60,1 
                do
                    mins = (2*math.pi/60) * i        
                    xh=xc+1.0*clock_r*math.sin(mins)
                    yh=yc-1.0*clock_r*math.cos(mins)
                    cairo_move_to(cr,xc+1.05*clock_r*math.sin(mins),yc-1.05*clock_r*math.cos(mins))
                    cairo_line_to(cr,xc+1.10*clock_r*math.sin(mins),yc-1.10*clock_r*math.cos(mins))        
                end
                cairo_set_line_width (cr, 1);
                cairo_stroke (cr);
            -- Hours
                for i = 5,60,5    
                do
                    mins = (2*math.pi/60) * i        
                    xh=xc+1.0*clock_r*math.sin(mins)
                    yh=yc-1.0*clock_r*math.cos(mins)
                    cairo_move_to(cr,xc+1.05*clock_r*math.sin(mins),yc-1.05*clock_r*math.cos(mins))
                    cairo_line_to(cr,xc+1.15*clock_r*math.sin(mins),yc-1.15*clock_r*math.cos(mins))        
                end   
                cairo_set_line_width (cr, 3);
                cairo_stroke (cr);
        end
    
    -- draw text on clock face - see https://www.lua.org/pil/22.1.html
        if show_text then
            cairo_set_source_rgb (cr, 1, 0.5, 0);   -- text colour
            cairo_select_font_face(cr, "Purisa",  
                CAIRO_FONT_SLANT_NORMAL,
                CAIRO_FONT_WEIGHT_BOLD);         
            cairo_set_font_size(cr, 32);
            cairo_move_to(cr, xc -80, yc - 23);
            cairo_show_text(cr, os.date("%a%d%b"))     -- date       
            cairo_move_to(cr, xc -70, yc + 60);
            cairo_show_text(cr, os.date("%I:%M%P"))    -- time
        end
                
    -- Draw hour hand
        cairo_set_source_rgba (cr, .1, 0.3, .5, handOpacity);   -- colour of the hands
        xh=xc+hourHandLength*clock_r*math.sin(hours_arc)
        yh=yc-hourHandLength*clock_r*math.cos(hours_arc)
        cairo_move_to(cr,xc,yc)
        cairo_line_to(cr,xh,yh)
        cairo_set_line_cap(cr,CAIRO_LINE_CAP_ROUND)
        cairo_set_line_width(cr,hourHandWidth)
        cairo_stroke(cr)
        
    -- Draw minute hand
        xm=xc+minuteHandLength*clock_r*math.sin(mins_arc)
        ym=yc-minuteHandLength*clock_r*math.cos(mins_arc)
        cairo_move_to(cr,xc,yc)
        cairo_line_to(cr,xm,ym)
        cairo_set_line_cap(cr,CAIRO_LINE_CAP_ROUND)
        cairo_set_line_width(cr,minuteHandWidth)
        cairo_stroke(cr)      
        
    -- Draw seconds hand
        if show_seconds then
            cairo_set_source_rgb (cr, 0.4, 0, 1);      -- colour of the second hand
            xs=xc+secondHandLength*clock_r*math.sin(secs_arc)
            ys=yc-secondHandLength*clock_r*math.cos(secs_arc)
            cairo_move_to(cr,xc,yc)
            cairo_line_to(cr,xs,ys)
            cairo_set_line_width(cr,secondHandWidth)
            cairo_stroke(cr)
            -- draw the circle in centre of clock face
                cairo_arc(cr, xc, yc, 5, 0, math.pi*2);
                cairo_fill(cr);                     
        end                   
                        
end
-----------------------------------------------------------------------------
