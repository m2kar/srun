--srun_send.lua
--Author: still-night@163.com
--srun lua openwrt core
--depends: +uci +nixio  
--2016-5-9 release 2
--release log 
--2016-5-9 
--  add get mac_addr
--  change srun_send() to nixio depended function
--


--get the stu_id from network.wan.username
function get_id()  
  local uci=require "uci"
  local x=uci.cursor()
  ppp_id=x:get("network","wan","username")
  user=string.gsub(string.sub(ppp_id,8),"(.)",function(x)
    return (string.char(string.byte(x)-4)) end)
  print(os.date("%c  "),"get_id",ppp_id,user)
  return user
end

--get the wan mac addr from sys use nixio.getifaddrs
function get_mac() 
  local uci=require("uci")
  local nxo=require("nixio")
  local u=uci.cursor()
  local iname=u:get("network","wan","ifname") or u:get("network","wan","_orig_ifname")
  local t=nxo.getifaddrs()
  local n,i,hw
  for n,i in ipairs(t) do
    if i.name==iname then
      hw=i.addr 
    end
  end
  de='00:00:00:00:00:00'
  hw=hw or de 
  print(os.date("%c"),"get_mac() hw=",hw)
  return hw  
end

--generate message from user an hw
function message(user,hw)
  str1=user .. string.rep("\000",(0x20-#user))
  str2=hw .. string.rep("\000",(0x18-#hw))
  str=str1 .. str2
  print(os.date("%c  "),"message(user=" .. user,",hw=" .. hw,") ")
  return str
end

--send message s to srun server 192.168.100.10:3338
--s:the message want to send
function srun_send(s)
  local nxo=require("nixio")
  local udp=nixio.socket("inet","dgram")
  local address="192.168.100.10"
  local port=3338
  udp:sendto(s , address , port)
  print(os.date("%c  "),"send udp",s)
  udp:close()
end



srun_send(message(get_id(),get_mac()))
