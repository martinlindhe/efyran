local mq = require("mq")
local log = require("knightlinc/Write")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local broadcast = require 'broadcast/broadcast'
local timer = require("Timer")

local bci = broadCastInterfaceFactory()

local function arrivedAtDestination(xLoc, yLoc, distanceDelta)
    log.Debug('Distance to loc: %d,%d <%d>', (xLoc), (yLoc), mq.TLO.Math.Distance(string.format('%d,%d', (yLoc), (xLoc)))())
    return mq.TLO.Math.Distance(string.format('%d,%d', (yLoc), (xLoc)))() <= distanceDelta
  end

  local function moveToMe()
    local me = mq.TLO.Me
    local xLoc = me.X()
    local yLoc = me.Y()
    local distanceDelta = 10
    if arrivedAtDestination(xLoc, yLoc, distanceDelta) then
      return
    end

    bci.ExecuteAllCommand(string.format("/nav id %d", me.ID()))
  end

  local function moveToLoc(xLoc, yLoc, zLoc, maxTime, arrivalDist)
    if not xLoc or not yLoc then
      log.Debug("Cannot move to unknown location <x:%d> <y:%d>", xLoc, yLoc)
      return false
    end

    if not mq.TLO.Navigation.PathExists(string.format("loc %d %d %d", yLoc, xLoc, zLoc)) then
      log.Debug("Cannot navgiate to location <x:%d> <y:%d>, no path exists.", xLoc, yLoc, zLoc)
      return false
    end

    if mq.TLO.Navigation.Active() then
      mq.cmd("/nav stop")
    end

    if mq.TLO.MoveUtils.Command() ~= "NONE" then
      mq.cmd("/stick off")
      mq.cmd("/moveto off")
    end

    local distanceDelta = arrivalDist or 10
    local maxTryTime = maxTime or 3

    if arrivedAtDestination(xLoc, yLoc, distanceDelta) then
      return true
    end

    if mq.TLO.Me.Casting.ID() and mq.TLO.Me.Class.ShortName() ~= "BRD" then
      mq.cmd("/stopcast")
    end

    local timeOut = timer.new(maxTryTime)

    local navCmd = string.format("/nav loc %d %d %d", yLoc, xLoc, zLoc)
    while not arrivedAtDestination(xLoc, yLoc, distanceDelta) and not timeOut:expired() do
      if not mq.TLO.Navigation.Active() then
        mq.cmd(navCmd)
      end

      mq.delay(maxTryTime * 1000 / 5, function() return arrivedAtDestination(xLoc, yLoc, distanceDelta) end)
    end

    mq.cmd("/nav stop")
    local arrived = arrivedAtDestination(xLoc, yLoc, distanceDelta)
    if arrived then
        broadcast.Success({}, string.format("Arrived at destinaiotn <x:%d> <y:%d>", xLoc, yLoc))
    else
        broadcast.Fail({}, string.format("Could not navigate to destinaiotn <x:%d> <y:%d>", xLoc, yLoc))
    end

    return arrived
  end

  local moveUtils = {
    MoveToLoc = moveToLoc,
    MoveToMe = moveToMe
  }

  return moveUtils
