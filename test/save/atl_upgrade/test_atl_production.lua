include "scripting/coroutine.lua"
include "test/scripting/lunit.lua"

local game = wl.Game()
local map = game.map

local hq = map:get_field(15, 30).immovable
local toolsmithy = map:get_field(11, 31).immovable

run(function ()
  local stock = hq:get_wares("all")

  assert_equal(0, stock.fishing_net, "Fishing net found in stock")
  assert_equal(0, stock.hunting_bow, "Hunting bow found in stock")

  assert_true(toolsmithy.is_stopped, "Toolsmithy was not stopped")

  toolsmithy:toggle_start_stop()

  sleep(2000)

  assert_false(toolsmithy.is_stopped, "Toolsmithy didn't start")

  game.desired_speed = 100 * 1000
  sleep(20 * 60 * 1000)

  stock = hq:get_wares("all")
  assert_true(stock.fishing_net > 3, "Fishing net not produced")
  assert_true(stock.hunting_bow > 3, "Hunting bow not produced")

  print("# All Tests passed.")
  wl.ui.MapView():close()
end)
