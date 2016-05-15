module("luci.controller.srun", package.seeall)

function index()
  entry({"admin","network","srun"},cbi("srun"),"SRUN CMU",05).dependent=false
end
