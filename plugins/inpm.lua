do
local function pairsByKeys (t, f)
      local a = {}
      for n in pairs(t) do table.insert(a, n) end
      table.sort(a, f)
      local i = 0      -- iterator variable
      local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
      end
      return iter
    end

local function member_ct(extra, success, result)
    local chat_id = extra.receiver
    local mem_num = '['..result.id..'] '..result.title..'.\n'
                 ..result.members_num..' members.\n\n'
end

local function chat_list(msg)
    local data = load_data(_config.moderation.data)
        local groups = 'groups'
        if not data[tostring(groups)] then
                return 'No groups at the moment'
        end
        local message = 'List of Groups:\n*Use /join (ID) to join*\n\n '
        local chat = {name =
                     {id = {}
  }
}
        local a = l
        for k,v in pairs(data[tostring(groups)]) do
                table.insert(chat, v)                  --local receiver = k
                                                               --local mem_num = chat_info(receiver, members_ct,{receiver=receiver})
                local settings = data[tostring(v)]['settings']
                for m,n in pairs(settings) do
                        if m == 'set_name' then
                             chat_name = n
                             table.insert(chat, chat_name)
                        end
                end
         for i,e in pairsByKeys(chat) do
            print(i, e)
         end

                --message = message .. '👥 '.. e ..' (ID: ' .. i .. ')\n\n '
        end
        local file = io.open("./groups/lists/listed_groups.txt", "w")
        file:write(message)
        file:flush()
        file:close()
        return message
       
end


function run(msg, matches)
  if msg.to.type ~= 'chat' or is_sudo(msg) or is_admin(msg) and is_realm(msg) then
	 local data = load_data(_config.moderation.data)
    if matches[1] == 'join' and data[tostring(matches[2])] then
      if data[tostring(matches[2])]['settings']['public'] == 'no' then
        if is_banned(msg.from.id, matches[2]) then
	    return 'You are banned.'
	 end
      if is_gbanned(msg.from.id) then
            return 'You are globally banned.'
      end
      if data[tostring(matches[2])]['settings']['lock_member'] == 'yes' and not is_owner2(msg.from.id, matches[2]) then
        return 'Group is private.'
      end
          local chat = "chat#id"..matches[2]
          local user = "user#id"..msg.from.id
          chat_add_user(chat, user, ok_cb, false)
        else
          return "Chat not found."
        end
      end
             -- SERVICE MESSAGE IN GROUP
            if msg.action and msg.action.type then
               local action = msg.action.type
               local receiver = 'user#id'..msg.action.user.id
               local group_name = string.gsub(msg.to.print_name, '_', ' ')
             --Check if user from pm joins chat via bot
            if action == "chat_add_user" and msg.action.to == matches[2] and msg.from.id == 0 then
               print ("Added "..msg.action.user.id.." to chat "..msg.to.print_name.." (ID:"..msg.to.id..")")
               savelog(msg.from.print_name.." PM", "Added "..msg.action.user.id.." to chat "..msg.to.print_name.." (ID:"..msg.to.id..")")
               send_large_msg(receiver, "Added you to chat:\n\n"..group_name.." (ID:"..msg.to.id..")")
            end
        end
     if matches[1] == 'chatlist'then
       if is_admin(msg) and msg.to.type == 'chat' then
         chat_list(msg)
         send_document("chat#id"..msg.from.id, "./groups/lists/listed_groups.txt", ok_cb, false)
       elseif msg.to.type == 'user' then
         chat_list(msg)
         send_document("user#id"..msg.from.id, "./groups/lists/listed_groups.txt", ok_cb, false) 
       end
       end
     end
  end
end


return {
    patterns = {
      "^[/!](chatlist)$",
      "^[/!](join) (.*)$",
      "^[/!](kickme) (.*)$",
      "^!!tgservice (chat_add_user)$"
    },
    run = run,
}

