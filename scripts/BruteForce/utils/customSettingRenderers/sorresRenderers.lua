---@diagnostic disable: missing-fields, redundant-return-value
local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local ipairs = _tl_compat and _tl_compat.ipairs or ipairs; local math = _tl_compat and _tl_compat.math or math; local pairs = _tl_compat and _tl_compat.pairs or pairs; local string = _tl_compat and _tl_compat.string or string; local I = require('openmw.interfaces')
local ui = require('openmw.ui')
local async = require('openmw.async')
local util = require("openmw.util")

local v2 = util.vector2

local function capitalizeText(text)
   local capitalizedText = ""
   local i = 1
   capitalizedText = text:sub(i, i):upper()
   i = i + 1
   while i <= #text do
      local j = text:find(" ", i)
      if j ~= nil then
         capitalizedText = capitalizedText .. text:sub(i, j) .. text:sub(j + 1, j + 1):upper()
         i = j + 2
      else
         break
      end
   end
   capitalizedText = capitalizedText .. text:sub(i, #text)
   return capitalizedText
end









I.Settings.registerRenderer('textset', function(input, set, args)
   if args == nil then args = {} end
   if input == nil then
      input = {}
      set(input)
   end

   local removeText = 'x'
   if args.removeText ~= nil and args.removeText ~= "" then
      removeText = args.removeText
   end

   local header = {
      type = ui.TYPE.Flex,
      props = {
         horizontal = true,
      },
      content = ui.content({}),
      external = {
         stretch = 1,
      },
   }

   local inputText = ''
   header.content:add({
      template = I.MWUI.templates.box,
      content = ui.content({ {
         template = I.MWUI.templates.padding,
         content = ui.content({ {
            template = I.MWUI.templates.textNormal,
            props = {
               text = "Add",
            },
            events = {
               mouseClick = async:callback(function()

                  if inputText == "" then return end
                  if input[inputText] ~= nil then return end
                  if args.keys ~= nil and #args.keys > 1 then
                     local i = 1
                     while i <= #args.keys do
                        if args.keys[i] == inputText then break end
                        i = i + 1
                     end
                     if i > #args.keys then return end
                  end
                  if args.lowercase ~= nil and args.lowercase == true then inputText = inputText:lower() end
                  input[inputText] = true
                  set(input)
               end),
            },
         }, }),
      }, }),
   })
   header.content:add({
      template = I.MWUI.templates.padding,
      external = {
         grow = 1,
      },
   })
   header.content:add({
      template = I.MWUI.templates.box,
      content = ui.content({ {
         template = I.MWUI.templates.padding,
         content = ui.content({ {
            template = I.MWUI.templates.textEditLine,
            events = {
               textChanged = async:callback(function(text)
                  inputText = text
               end),
            }, },
         }), },
      }),
   })

   local body = {
      type = ui.TYPE.Flex,
      content = ui.content({}),
   }

   local function remove(text)
      input[text] = nil
   end

   for text in pairs(input) do
      local display = text
      local alpha = 0.5
      if args.pretty == true then display = capitalizeText(text) end
      if input[text] == true then alpha = 1.0 end
      body.content:add({
         template = I.MWUI.templates.padding,
      })
      body.content:add({
         template = I.MWUI.templates.box,
         content = ui.content({ {
            type = ui.TYPE.Flex,
            props = {
               horizontal = true,
               arrange = ui.ALIGNMENT.Center,
            },
            content = ui.content({
               {
                  template = I.MWUI.templates.padding,
                  content = ui.content({ {
                     template = I.MWUI.templates.textNormal,
                     props = {
                        text = removeText,
                     },
                     events = {
                        mouseClick = async:callback(function()
                           remove(text)
                           set(input)
                        end),
                     },
                  }, }),
               },
               {
                  template = I.MWUI.templates.padding,
                  content = ui.content({ {
                     template = I.MWUI.templates.textNormal,
                     props = {
                        text = '|',
                     },
                  }, }),
               },
               {
                  template = I.MWUI.templates.padding,
                  content = ui.content({ {
                     template = I.MWUI.templates.textNormal,
                     props = {
                        text = display,
                        alpha = alpha,
                     },
                  }, }),
                  events = {
                     mouseClick = async:callback(function()
                        input[text] = input[text] == false
                        set(input)
                     end),
                  },
               },
            }),
         }, }),
      })
   end

   return {
      type = ui.TYPE.Flex,
      content = ui.content({
         header,
         body,
      }),
   }
end)








I.Settings.registerRenderer('multiselect', function(input, set, args)
   if type(input) ~= "table" then input = {} end
   if args == nil then args = {} end
   if args.keys ~= nil then
      for _, text in ipairs(args.keys) do
         if input[text] == nil then
            input[text] = false
         end
      end
   end

   local body = {
      type = ui.TYPE.Flex,
      props = {
         horizontal = false,
         arrange = ui.ALIGNMENT.Start,
      },
      content = ui.content({}),
   }

   for _, text in ipairs(args.keys) do
      local alpha = 0.5
      local display = text
      if args.aliases ~= nil and args.aliases[text] ~= nil then display = args.aliases[text] end
      if input[text] == true then
         alpha = 1.0
      end

      body.content:add({
         template = I.MWUI.templates.padding,
      })
      body.content:add({
         template = I.MWUI.templates.box,
         content = ui.content({ {
            template = I.MWUI.templates.padding,
            content = ui.content({ {
               template = I.MWUI.templates.padding,
               content = ui.content({ {
                  template = I.MWUI.templates.textNormal,
                  props = {
                     text = display,
                     alpha = alpha,
                  },
               }, }),
            }, }),
         }, }),
         events = {
            mouseClick = async:callback(function()
               input[text] = input[text] == false
               set(input)
            end),
         },
      })
   end

   return {
      type = ui.TYPE.Flex,
      content = ui.content({
         body,
      }),
   }
end)








I.Settings.registerRenderer('multinumber', function(input, set, args)
   local lastInput = {}
   if args == nil then args = {} end
   if args.keys ~= nil then
      for _, k in ipairs(args.keys) do
         if input[k] == nil then
            input[k] = 0
         end
      end
   end

   local body = {
      type = ui.TYPE.Flex,
      props = {
         horizontal = false,
         arrange = ui.ALIGNMENT.End,
      },
      content = ui.content({}),
   }

   for _, k in ipairs(args.keys) do
      body.content:add({
         template = I.MWUI.templates.padding,
      })
      body.content:add({
         type = ui.TYPE.Flex,
         props = {
            horizontal = true,
            arrange = ui.ALIGNMENT.Center,
         },
         content = ui.content({
            {
               template = I.MWUI.templates.padding,
               content = ui.content({ {
                  template = I.MWUI.templates.textNormal,
                  props = {
                     text = capitalizeText(k),
                     textAlignV = ui.ALIGNMENT.Center,
                  },
               }, }),
            },
            {
               template = I.MWUI.templates.padding,
               props = {},
            },
            {
               template = I.MWUI.templates.box,
               props = {},
               content = ui.content({ {
                  template = I.MWUI.templates.padding,
                  content = ui.content({ {
                     template = I.MWUI.templates.textEditLine,
                     props = {
                        text = tostring(input[k]),
                        size = v2(80, 0)
                     },
                     events = {
                        textChanged = async:callback(function(text)
                           lastInput[k] = tonumber(text)
                        end),
                        focusLoss = async:callback(function()
                           local num = lastInput[k]
                           if num == nil then
                              input[k] = 0
                              set(input)
                              return
                           end
                           if args.integer == true then
                              num = math.floor(num + 0.5)
                           end
                           if args.min[k] ~= nil and num < args.min[k] then
                              num = args.min[k]
                           elseif args.max[k] ~= nil and num > args.max[k] then
                              num = args.max[k]
                           end
                           input[k] = num
                           set(input)
                        end),
                     },
                  }, }),
               }, }),
            },
         }),
      })
   end

   return {
      type = ui.TYPE.Flex,
      content = ui.content({
         body,
      }),
   }
end)
