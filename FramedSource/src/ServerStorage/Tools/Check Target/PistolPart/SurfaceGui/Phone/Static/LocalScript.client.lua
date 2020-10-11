images = {
	"http://www.roblox.com/asset/?id=12095085",
	"http://www.roblox.com/asset/?id=9470965",
	"http://www.roblox.com/asset/?id=40288979",
	"http://www.roblox.com/asset/?id=76547771",
	"http://www.roblox.com/asset/?id=36169650",
	"http://www.roblox.com/asset/?id=3220503"
}

i = 1

while true do
	wait(0.1)
	if math.random(1, 2) == 2 then
		i = i + math.random(1, 2)
	else
		i = i - math.random(1, 2)
	end
	i = math.abs(i)
	i = (i % (#images)) + 1
	script.Parent.Image = images[i]
end