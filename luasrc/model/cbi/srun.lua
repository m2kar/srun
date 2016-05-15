function get_encode(id)
  s=string.gsub(id,"(.)",function(x)
      return string.char(string.byte(x)+4) end)
  return "{SRUN2}" .. s
end

iter=1

function write_log(logs)
  f=io.open("/tmp/log/srun.log","a")
  iter=iter+1
  f:write(os.date("%c cbi/srun.lua ") .. iter .. "\t".. logs .. "\n")
  f:close()
  return 0
end

m=Map("srun","SRUN Client Control Panel",translate("CMU Srun route client control panel"))
s = m:section(TypedSection, "user", "USER")
s.addremove = false
s.anonymous = true
n = s:option(Value,"username",translate("username"),translate("Please input your student ID "))
n.optional=false
p= s:option(Value,"password",translate("password"))
p.optional=false
p.anonymous=true

dhcp=Map("dhcp","","")
network=Map("network","","")

wireless=Map("wireless","wifi","wifi control panel")                     
wifi=wireless:section(TypedSection,"wifi-iface","wifi")             
wifi.addremove=false                                                
wifi.anonymous=true                                                 
ssid=wifi:option(Value,"ssid","wifi-name","name of your wlan")      
ssid.optional=false                                                 
key=wifi:option(Value,"key","wifi-password","password of your wlan")
key.optional=false    
key.datetype="wpakey"



function m.on_before_save()
  write_log( "  on_before_save ")
  local u=m.uci:get("srun","cmu_wifi","username")
  local p=m.uci:get("srun","cmu_wifi","password")

end

function network.on_before_save()
  write_log( "  network.on_before_save ")
  --network set
  local u=m.uci:get("srun","cmu_wifi","username")
  local p=m.uci:get("srun","cmu_wifi","password")
  dhcp.uci:set("dchp","lan","ra_management","1")
  network.uci:set("network","lan","dns","180.76.76.76 119.29.29.29 218.30.118.6 114.114.114.114 8.8.8.8")
  network.uci:set("network","wan","proto","pppoe")
  network.uci:set("network","wan","ipv6","auto")
  network.uci:set("network","wan","mtu","1250")
  network.uci:set("network","wan","username",get_encode(u))
  network.uci:set("network","wan","password",p)

end

function wireless.on_before_save()
  write_log( "  wireless.on_before_save ")
  wireless.uci:foreach("wireless","wifi-iface",function(s) 
    if(s['.index']==1) then
      wireless.uci:set("wireless",s['.name'],"encryption","psk2")
      wireless.uci:set("wireless",s['.name'],"wds","0")
    end
  end)

end


function network.on_before_apply()
  write_log( " network.on_after_apply ")
  write_log("\n-----------------uci show start ------------")
  local mes=luci.sys.exec("uci show network.wan ; uci show network.lan.dns")
  write_log( "\n " .. mes )
   mes=luci.sys.exec("uci show wireless")
  write_log( "\n" .. mes)
  mes=luci.sys.exec("uci show srun")
  write_log( "\n" .. mes)
  write_log("\n-----------------uci show end  ----------")
  
  luci.sys.call("/etc/init.d/network restart")
  write_log( "init.d/network restart ")
  luci.sys.call("/etc/init.d/dnsmasq restart")
  write_log( "init.d/dnsmasq restart ")
end


return m,network,wireless,dhcp
