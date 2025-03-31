include "scripting/coroutine.lua"
include "test/scripting/lunit.lua"

local game = wl.Game()
local map = game.map

local hq = map:get_field(15, 30).immovable
local dressmakery1 = map:get_field(16, 32).immovable
local dressmakery2 = map:get_field(17, 30).immovable
local training_glade = map:get_field(12, 29).immovable

run(function ()
  local stock = hq:get_wares("all")

  assert_equal(0, stock.armor_wooden, "Wooden armor found in stock")
  assert_equal(0, stock.helmet_wooden, "Wooden helmet found in stock")
  assert_equal(0, stock.boots_sturdy, "Sturdy boots found in stock")
  assert_equal(0, stock.boots_swift, "Swift boots found in stock")
  assert_equal(0, stock.boots_hero, "Hero boots found in stock")

  assert_equal(hq:get_workers("amazons_soldier"), hq:get_soldiers({0, 0, 0, 0}),
               "Not all soldiers are level 0")

  assert_true(dressmakery1.is_stopped, "Southern dressmakery was not stopped")
  assert_true(dressmakery2.is_stopped, "Eastern dressmakery was not stopped")
  assert_true(training_glade.is_stopped, "Training glade was not stopped")

  dressmakery1:toggle_start_stop()
  dressmakery2:toggle_start_stop()

  sleep(2000)

  assert_false(dressmakery1.is_stopped, "Southern dressmakery didn't start")
  assert_false(dressmakery2.is_stopped, "Eastern dressmakery didn't start")

  game.desired_speed = 100 * 1000
  sleep(40 * 60 * 1000)

  stock = hq:get_wares("all")
  assert_true(stock.armor_wooden > 3, "Wooden armor not produced")
  assert_true(stock.helmet_wooden > 3, "Wooden helmet not produced")
  assert_true(stock.boots_sturdy > 3, "Sturdy boots not produced")
  assert_true(stock.boots_swift > 3, "Swift boots not produced")
  assert_true(stock.boots_hero > 3, "Hero boots not produced")

  training_glade:toggle_start_stop()
  sleep(2000)
  assert_false(training_glade.is_stopped, "Training glade didn't start")

  sleep(20 * 60 * 1000)

  assert_true(hq:get_soldiers({3, 0, 2, 3}) > 3, "Failed to fully train soldiers")

  print("# All Tests passed.")
  wl.ui.MapView():close()
end)
