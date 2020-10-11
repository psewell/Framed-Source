local ods = game:GetService("DataStoreService"):GetOrderedDataStore("Wins")

function comma_value(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

function updateBoard(board, data)
	for k,v in pairs(data) do
		local pos = k
		local name = v.key
		local score = v.value
		local nametextbox = board.SurfaceGui:FindFirstChild("Name" .. pos)
		nametextbox.Text = name
		local scoretextbox = board.SurfaceGui:FindFirstChild("Score" .. pos)
		scoretextbox.Text = comma_value(score)
	end	
end

pcall(function()
	local pages = ods:GetSortedAsync(false, 5)
	local data = pages:GetCurrentPage()
	updateBoard(game.Workspace.LobbyArea.Scoreboard.W1, data)
	if not pages.IsFinished then
		pages:AdvanceToNextPageAsync()
		data = pages:GetCurrentPage()
		updateBoard(game.Workspace.LobbyArea.Scoreboard.W2, data)
	end
	if not pages.IsFinished then
		pages:AdvanceToNextPageAsync()
		data = pages:GetCurrentPage()
		updateBoard(game.Workspace.LobbyArea.Scoreboard.W3, data)
	end
	if not pages.IsFinished then
		pages:AdvanceToNextPageAsync()
		data = pages:GetCurrentPage()
		updateBoard(game.Workspace.LobbyArea.Scoreboard.W4, data)
	end
end)
