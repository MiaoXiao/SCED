-- Bundled by luabundle {"version":"1.6.0"}
local __bundle_require, __bundle_loaded, __bundle_register, __bundle_modules = (function(superRequire)
	local loadingPlaceholder = {[{}] = true}

	local register
	local modules = {}

	local require
	local loaded = {}

	register = function(name, body)
		if not modules[name] then
			modules[name] = body
		end
	end

	require = function(name)
		local loadedModule = loaded[name]

		if loadedModule then
			if loadedModule == loadingPlaceholder then
				return nil
			end
		else
			if not modules[name] then
				if not superRequire then
					local identifier = type(name) == 'string' and '\"' .. name .. '\"' or tostring(name)
					error('Tried to require ' .. identifier .. ', but no such module has been registered')
				else
					return superRequire(name)
				end
			end

			loaded[name] = loadingPlaceholder
			loadedModule = modules[name](require, loaded, register, modules)
			loaded[name] = loadedModule
		end

		return loadedModule
	end

	return require, loaded, register, modules
end)(nil)
__bundle_register("__root", function(require, _LOADED, __bundle_register, __bundle_modules)
require("playercards/cards/FatherMateoParallel")
end)
__bundle_register("chaosbag/BlessCurseManagerApi", function(require, _LOADED, __bundle_register, __bundle_modules)
do
  local BlessCurseManagerApi = {}
  local GUIDReferenceApi = require("core/GUIDReferenceApi")

  local function getManager()
    return GUIDReferenceApi.getObjectByOwnerAndType("Mythos", "BlessCurseManager")
  end

  -- removes all taken tokens and resets the counts
  function BlessCurseManagerApi.removeTakenTokensAndReset()
    local BlessCurseManager = getManager()
    Wait.time(function() BlessCurseManager.call("removeTakenTokens", "Bless") end, 0.05)
    Wait.time(function() BlessCurseManager.call("removeTakenTokens", "Curse") end, 0.10)
    Wait.time(function() BlessCurseManager.call("doReset", "White") end, 0.15)
  end

  -- updates the internal count (called by cards that seal bless/curse tokens)
  ---@param type string Type of chaos token ("Bless" or "Curse")
  ---@param guid string GUID of the token
  ---@param silent? boolean Whether or not to hide messages
  function BlessCurseManagerApi.sealedToken(type, guid, silent)
    getManager().call("sealedToken", { type = type, guid = guid, silent = silent })
  end

  -- updates the internal count (called by cards that seal bless/curse tokens)
  ---@param type string Type of chaos token ("Bless" or "Curse")
  ---@param guid string GUID of the token
  ---@param fromBag? boolean Whether or not token was just drawn from the chaos bag
  ---@param silent? boolean Whether or not to hide messages
  function BlessCurseManagerApi.releasedToken(type, guid, fromBag, silent)
    getManager().call("releasedToken", { type = type, guid = guid, fromBag = fromBag, silent = silent })
  end

  -- updates the internal count (called by cards that seal bless/curse tokens)
  ---@param type string Type of chaos token ("Bless" or "Curse")
  ---@param guid string GUID of the token
  function BlessCurseManagerApi.returnedToken(type, guid)
    getManager().call("returnedToken", { type = type, guid = guid })
  end

  -- broadcasts the current status for bless/curse tokens
  ---@param playerColor string Color of the player to show the broadcast to
  function BlessCurseManagerApi.broadcastStatus(playerColor)
    getManager().call("broadcastStatus", playerColor)
  end

  -- removes all bless / curse tokens from the chaos bag and play
  ---@param playerColor string Color of the player to show the broadcast to
  function BlessCurseManagerApi.removeAll(playerColor)
    getManager().call("doRemove", playerColor)
  end

  -- adds bless / curse sealing to the hovered card
  ---@param playerColor string Color of the player to show the broadcast to
  ---@param hoveredObject tts__Object Hovered object
  ---@param noCurse? boolean True if just Bless sealing should be added (Parallel Mateo)
  function BlessCurseManagerApi.addBlurseSealingMenu(playerColor, hoveredObject, noCurse)
    getManager().call("addMenuOptions", { playerColor = playerColor, hoveredObject = hoveredObject, noCurse = noCurse })
  end

  -- adds bless / curse to the chaos bag
  ---@param tokenType string Type of chaos token ("Bless" or "Curse")
  ---@param playerColor? string Color of the triggering player
  function BlessCurseManagerApi.addToken(tokenType, playerColor)
    getManager().call("callFunctionFromApi", { tokenType = tokenType, playerColor = playerColor, remove = false })
  end

  -- removes bless / curse from the chaos bag
  ---@param tokenType string Type of chaos token ("Bless" or "Curse")
  ---@param playerColor? string Color of the triggering player
  function BlessCurseManagerApi.removeToken(tokenType, playerColor)
    getManager().call("callFunctionFromApi", { tokenType = tokenType, playerColor = playerColor, remove = true })
  end

  function BlessCurseManagerApi.getBlessCurseInBag()
    return getManager().call("getBlessCurseInBag", {})
  end

  return BlessCurseManagerApi
end
end)
__bundle_register("chaosbag/ChaosBagApi", function(require, _LOADED, __bundle_register, __bundle_modules)
do
  local TableLib    = require("util/TableLib")

  local ChaosBagApi = {}

  -- Respawns the chaos bag with a new state of tokens
  ---@param tokenList table List of chaos token ids
  ---@param disablePrint? boolean True to suppress printing
  function ChaosBagApi.setChaosBagState(tokenList, disablePrint)
    Global.call("setChaosBagState", tokenList)
    if not disablePrint then
      printToAll("Chaos Bag set to chosen difficulty.", "Green")
    end
  end

  -- Returns a list of chaos token ids in the current chaos bag
  function ChaosBagApi.getChaosBagState()
    return TableLib.copy(Global.call("getChaosBagState"))
  end

  -- Returns a reference to the chaos bag (used by a lot of objects!)
  function ChaosBagApi.findChaosBag()
    return Global.call("findChaosBag")
  end

  -- Returns a table of object references to the tokens in play (does not include sealed tokens!)
  function ChaosBagApi.getTokensInPlay()
    return Global.call("getChaosTokensinPlay")
  end

  -- Returns all sealed tokens on cards to the chaos bag
  ---@param playerColor string Color of the player to show the broadcast to
  ---@param filterName? string Name of the token to release
  ---@param silent? boolean Whether or not to hide messages
  function ChaosBagApi.releaseAllSealedTokens(playerColor, filterName, silent)
    Global.call("releaseAllSealedTokens", { playerColor = playerColor, filterName = filterName, silent = silent })
  end

  -- Returns all drawn tokens to the chaos bag
  function ChaosBagApi.returnChaosTokens()
    Global.call("returnChaosTokens")
  end

  -- Removes the specified chaos token from the chaos bag
  ---@param id string ID of the chaos token
  function ChaosBagApi.removeChaosToken(id)
    Global.call("removeChaosToken", id)
  end

  -- Returns a chaos token to the bag and calls all relevant functions
  ---@param token tts__Object Chaos token to return
  ---@param fromBag boolean whether or not the token to return was in the middle of being drawn (true) or elsewhere (false)
  function ChaosBagApi.returnChaosTokenToBag(token, fromBag)
    Global.call("returnChaosTokenToBag", { token = token, fromBag = fromBag })
  end

  -- Spawns the specified chaos token and puts it into the chaos bag
  ---@param id string ID of the chaos token
  function ChaosBagApi.spawnChaosToken(id)
    Global.call("spawnChaosToken", id)
  end

  -- Checks to see if the chaos bag can be manipulated.
  -- This method will broadcast a message to all players if the bag is being searched.
  ---@return any: True if the bag is manipulated, false if it should be blocked.
  function ChaosBagApi.canTouchChaosTokens()
    return Global.call("canTouchChaosTokens")
  end

  -- Function used for manipulation of chaos tokens that are in play, in conjunction with various helpers
  -- e.g. Nkosi Mabati or Ocula Obscura.
  ---@param type string "redraw" or "seal" for what happens after the token is removed from play
  ---@param validTokens? table list of tokens eligible for manipulation
  ---@param invalidTokens? table list of tokens ineligible for manipulation
  ---@param returnToPool? boolean if the token should be removed from the chaos bag (e.g. False Covenant)
  ---@param drawSpecificToken? boolean if upon redrawing, a specific chaos token is drawn (e.g. Nkosi Mabati)
  ---@param triggeringCardGUID? string the GUID of the card triggering the token manipulation
  ---@param playerColor? string the color of the triggering player (useful for functions that require messaging the player)
  function ChaosBagApi.removeTokenFromPlay(type, validTokens, invalidTokens, returnToPool, drawSpecificToken, triggeringCardGUID, playerColor)
    Global.call("removeTokenFromPlay", {
      type               = type,
      validTokens        = validTokens,
      invalidTokens      = invalidTokens,
      returnToPool       = returnToPool,
      drawSpecificToken  = drawSpecificToken,
      triggeringCardGUID = triggeringCardGUID,
      playerColor        = playerColor
    })
  end

  function ChaosBagApi.getReadableTokenName(tokenName)
    return Global.call("getReadableTokenName", tokenName)
  end

  function ChaosBagApi.getChaosTokenName(chosenToken)
    return Global.call("getChaosTokenName", chosenToken)
  end

  -- Draws a chaos token to a playermat
  ---@param mat tts__Object|string Playermat that triggered this (either object or matColor)
  ---@param drawAdditional boolean Controls whether additional tokens should be drawn
  ---@param tokenType? string Name of token (e.g. "Bless") to be drawn from the bag
  ---@param guidToBeResolved? string GUID of the sealed token to be resolved instead of drawing a token from the bag
  ---@param takeParameters? table Position and rotation of the location where the new token should be drawn to, usually to replace a returned token
  ---@return tts__Object: Object reference to the token that was drawn
  function ChaosBagApi.drawChaosToken(mat, drawAdditional, tokenType, guidToBeResolved, takeParameters)
    return Global.call("drawChaosToken", {
      mat              = mat,
      drawAdditional   = drawAdditional,
      tokenType        = tokenType,
      guidToBeResolved = guidToBeResolved,
      takeParameters   = takeParameters
    })
  end

  -- Returns a Table List of chaos token ids in the current chaos bag
  function ChaosBagApi.getIdUrlMap()
    return Global.getTable("ID_URL_MAP")
  end

  return ChaosBagApi
end
end)
__bundle_register("core/GUIDReferenceApi", function(require, _LOADED, __bundle_register, __bundle_modules)
do
  local GUIDReferenceApi = {}

  local function callhandler(functionName, argument)
    return getObjectFromGUID("123456").call(functionName, argument)
  end

  -- General information:
  --- "owner" is a string that describes the parent object
  --- "type" is a string that describes the type of object

  -- Returns the matching object
  function GUIDReferenceApi.getObjectByOwnerAndType(owner, type)
    return callhandler("getObjectByOwnerAndType", { owner = owner, type = type })
  end

  -- Returns all matching objects as a table with references
  function GUIDReferenceApi.getObjectsByType(type)
    return callhandler("getObjectsByType", type)
  end

  -- Returns all matching objects as a table with references
  function GUIDReferenceApi.getObjectsByOwner(owner)
    return callhandler("getObjectsByOwner", owner)
  end

  -- Sends new information to the reference handler to edit the main index (if type/guid are omitted, entry will be removed)
  function GUIDReferenceApi.editIndex(owner, type, guid)
    return callhandler("editIndex", { owner = owner, type = type, guid = guid })
  end

  -- Returns the owner of an object or the object it's located on
  function GUIDReferenceApi.getOwnerOfObject(object)
    return callhandler("getOwnerOfObject", object)
  end

  -- Returns the direct owner and type of an object
  function GUIDReferenceApi.getDirectOwnerAndType(object)
    return callhandler("getDirectOwnerAndType", object)
  end

  function GUIDReferenceApi.removeObjectByOwnerAndType(owner, type)
    return callhandler("removeObjectByOwnerAndType", { owner = owner, type = type })
  end

  return GUIDReferenceApi
end
end)
__bundle_register("playercards/CardsWithHelper", function(require, _LOADED, __bundle_register, __bundle_modules)
--[[ Library for cards that have helpers
This file is used to share code between cards with helpers.
It syncs the visibility of the helper with the option panel and
makes sure the card has the respective tag.
Additionally, it will call 'initialize()' and 'shutOff()'
in the parent file if they are present.

Instructions:
1) Define the global variables before requiring this file:
hasXML          = true  (whether the card has an XML display)
isHelperEnabled = false (default state of the helper, should be 'false')

2) Add "CardWithHelper" tag to .json for the card object itself.

3) Add `if isHelperEnabled then updateDisplay() end` to onLoad()

----------------------------------------------------------]]

-- forces a new state
function setHelperState(newState)
  if doNotTurnOff == true then return end
  isHelperEnabled = newState
  updateSave()
  updateDisplay()
end

-- toggles the current state
function toggleHelper(manual)
  if manual and isHelperEnabled == true then -- do not allow helper to be forced to turn on
    doNotTurnOff = true
  elseif manual and isHelperEnabled == false then -- return to default behavior
    doNotTurnOff = false
  end
  isHelperEnabled = not isHelperEnabled
  updateSave()
  updateDisplay()
end

-- updates the visibility and calls events (after a small delay to allow XML being set)
function updateDisplay()
  Wait.frames(actualDisplayUpdate, 5)
end

function actualDisplayUpdate()
  if isHelperEnabled then
    self.clearContextMenu()
    self.addContextMenuItem("Disable Helper", toggleHelper)
    if hasXML then self.UI.show("Helper") end
    if initialize then initialize() end
  else
    self.clearContextMenu()
    self.addContextMenuItem("Enable Helper", toggleHelper)
    if hasXML then self.UI.hide("Helper") end
    if shutOff then shutOff() end
  end
  if generateContextMenu then generateContextMenu() end
end

function onPickUp()
  setHelperState(false)
end
end)
__bundle_register("playercards/cards/FatherMateoParallel", function(require, _LOADED, __bundle_register, __bundle_modules)
require("playercards/CardsWithHelper")
local BlessCurseManagerApi = require("chaosbag/BlessCurseManagerApi")
local ChaosBagApi          = require("chaosbag/ChaosBagApi")
local GUIDReferenceApi     = require("core/GUIDReferenceApi")
local PlayermatApi         = require("playermat/PlayermatApi")
local TokenArrangerApi     = require("tokens/TokenArrangerApi")

-- intentionally global
hasXML                     = true
isHelperEnabled            = false
local loopId

-- table to store state for matcolors (will hold GUID of sealed token)
local buttonData           = {
  White  = false,
  Orange = false,
  Green  = false,
  Red    = false
}

function updateSave()
  self.script_state = JSON.encode({
    isHelperEnabled = isHelperEnabled,
    buttonData      = buttonData,
    loopId          = loopId
  })
end

function onLoad(savedData)
  if savedData and savedData ~= "" then
    local loadedData = JSON.decode(savedData)
    isHelperEnabled  = loadedData.isHelperEnabled
    buttonData       = loadedData.buttonData
    loopId           = loadedData.loopId
  end
  if isHelperEnabled then updateDisplay() end
  self.addTag("CardThatSeals")
end

function initialize()
  maybeUpdateButtonState()
  loopId = Wait.time(maybeUpdateButtonState, 1, -1)
  self.addContextMenuItem("Release all tokens", releaseAllTokens)
end

function shutOff()
  if loopId then
    Wait.stop(loopId)
    loopId = nil
  end
  self.addContextMenuItem("Release all tokens", releaseAllTokens)
end

function resetSealedTokens()
  buttonData = {
    White  = false,
    Orange = false,
    Green  = false,
    Red    = false
  }
  updateSave()
end

function releaseAllTokensWrapper(params)
  releaseAllTokens(params.playerColor, _, _, params.filterName, params.silent)
end

function releaseAllTokens(playerColor, _, _, filterName, silent)
  if not ChaosBagApi.canTouchChaosTokens() then return end
  if filterName and filterName ~= "Bless" then return end

  local chaosbag = ChaosBagApi.findChaosBag()

  local count = 0
  for buttonId, state in pairs(buttonData) do
    if state then
      local token = getObjectFromGUID(state)
      if token then
        count = count + 1
        chaosbag.putObject(token)
        BlessCurseManagerApi.releasedToken(token.getName(), state, nil, silent)
      end
    end
  end

  buttonData = {
    White  = false,
    Orange = false,
    Green  = false,
    Red    = false
  }
  maybeUpdateButtonState()
  updateSave()

  if count == 0 then
    if not silent then
      printToColor("No tokens to release found!", playerColor)
    end
    return
  end

  if not silent then
    local str = (count == 1) and "token" or "tokens"
    printToColor("Returning " .. count .. " " .. str .. " to the token pool", playerColor)
  end

  TokenArrangerApi.layout()
  Player[playerColor].clearSelectedObjects()
end

-- count tokens in the bag and maybe grey buttons
function maybeUpdateButtonState()
  local numInBag = BlessCurseManagerApi.getBlessCurseInBag()
  noBlessAvailable = (numInBag.Bless == 0)

  local investigatorCards = PlayermatApi.getUsedInvestigatorCards()
  local tableLayoutHeight = 1800

  for buttonId, state in pairs(buttonData) do
    if investigatorCards[buttonId] then
      if noBlessAvailable and state == false then
        self.UI.setAttribute(buttonId, "color", getButtonColor("Inactive"))
        self.UI.setAttribute("Row_" .. buttonId, "active", true)
      else
        local handColor = PlayermatApi.getPlayerColor(buttonId)
        if handColor then
          self.UI.setAttribute(buttonId, "color", getButtonColor(handColor))
          self.UI.setAttribute("Row_" .. buttonId, "active", true)
        else
          self.UI.setAttribute("Row_" .. buttonId, "active", false)
          tableLayoutHeight = tableLayoutHeight - 450
        end
      end
    else
      self.UI.setAttribute("Row_" .. buttonId, "active", false)
      tableLayoutHeight = tableLayoutHeight - 450
    end

    -- update button text (free trigger vs reaction trigger)
    self.UI.setAttribute(buttonId, "text", state and "u" or "v")
  end

  -- update height of table layout
  self.UI.setAttribute("Helper", "height", tableLayoutHeight)
end

function onClick_sidebutton(player, clickType, buttonId)
  if buttonData[buttonId] == false then
    -- nothing sealed yet
    local numInBag = BlessCurseManagerApi.getBlessCurseInBag()
    noBlessAvailable = (numInBag.Bless == 0)

    if noBlessAvailable then
      broadcastToColor("There are no bless tokens available for sealing.", player.color, "Orange")
      return
    end

    if not ChaosBagApi.canTouchChaosTokens() then return end

    local chaosBag = ChaosBagApi.findChaosBag()
    if not chaosBag then return end

    local sealPos = PlayermatApi.transformLocalPosition(Vector(-1.177, 0, 0.002), buttonId)
    local sealRot = PlayermatApi.returnRotation(buttonId)

    for i, obj in ipairs(chaosBag.getObjects()) do
      if obj.name == "Bless" then
        chaosBag.takeObject({
          position = sealPos + Vector(0, 0.5, 0),
          rotation = sealRot,
          index = i - 1,
          smooth = false,
          callback_function = function(token)
            local guid = token.getGUID()
            buttonData[buttonId] = guid

            local handColor = PlayermatApi.getPlayerColor(buttonId)
            broadcastToColor("Sealed bless for " .. handColor, player.color)

            maybeUpdateButtonState()
            updateSave()
            TokenArrangerApi.layout()
            BlessCurseManagerApi.sealedToken("Bless", guid)
          end
        })
        break
      end
    end
  else
    -- bless token was sealed
    local mat = GUIDReferenceApi.getObjectByOwnerAndType(buttonId, "Playermat")
    local drawnToken = ChaosBagApi.drawChaosToken(mat, true, _, buttonData[buttonId])
    if drawnToken then
      buttonData[buttonId] = false
      local handColor = PlayermatApi.getPlayerColor(buttonId)
      broadcastToColor("Resolved sealed bless for " .. Global.call("getColoredName", handColor), player.color)
      maybeUpdateButtonState()
      updateSave()
    else
      broadcastToColor("A different playermat still had tokens, returned them instead.", player.color, "Orange")
    end
  end
end

-- gets a hex color from a string and adds some transparency
function getButtonColor(colorStr)
  if colorStr == "Inactive" then
    return "#353535E6"
  end
  return "#" .. Color.fromString(colorStr):toHex() .. "e6"
end
end)
__bundle_register("playermat/PlayermatApi", function(require, _LOADED, __bundle_register, __bundle_modules)
do
  local PlayermatApi              = {}
  local GUIDReferenceApi          = require("core/GUIDReferenceApi")
  local SearchLib                 = require("util/SearchLib")
  local localInvestigatorPosition = Vector(-1.17, 1, -0.01)

  -- General notes:
  -------------------------------------------------------------------
  -- "matColor" is a string that describes the internal "color" of each mat
  -- (the starting color when the game is first loaded)
  -- Some functions will support the additional "All" pseudo-color to trigger that code for each mat
  -- If a function does not support "All", there will be a comment
  -------------------------------------------------------------------
  -- "playerColor" (or "handColor") is a string that describes the actual color of the seat
  -------------------------------------------------------------------

  -- Convenience function to look up a mat's object by color, or get all mats
  local function getMatForColor(matColor)
    if matColor == "All" then
      return GUIDReferenceApi.getObjectsByType("Playermat") or {}
    else
      return { matColor = GUIDReferenceApi.getObjectByOwnerAndType(matColor, "Playermat") }
    end
  end

  -- Convenience function to call a function on a single mat
  ---@param matColor string Does not support "All"
  ---@param funcName string Name of the function to call
  ---@param params any Parameter for the call
  local function callForSingleMat(matColor, funcName, params)
    for _, mat in pairs(getMatForColor(matColor)) do
      return mat.call(funcName, params)
    end
  end

  -- Returns the color of the closest playermat
  ---@param startPos table Starting position to get the closest mat from
  function PlayermatApi.getMatColorByPosition(startPos)
    local result, smallestDistance
    for matColor, mat in pairs(getMatForColor("All")) do
      local distance = Vector.between(startPos, mat.getPosition()):magnitude()
      if smallestDistance == nil or distance < smallestDistance then
        smallestDistance = distance
        result = matColor
      end
    end
    return result
  end

  -- Returns the color of the player's hand that is seated next to the playermat
  ---@param matColor string Does not support "All"
  function PlayermatApi.getPlayerColor(matColor)
    for _, mat in pairs(getMatForColor(matColor)) do
      return mat.getVar("playerColor")
    end
    return nil
  end

  -- Returns the color of the playermat that owns the playercolor's hand
  ---@param handColor string Color of the playermat
  function PlayermatApi.getMatColor(handColor)
    for matColor, mat in pairs(getMatForColor("All")) do
      if mat.getVar("playerColor") == handColor then
        return matColor
      end
    end
  end

  -- Gets the slot data for the playermat
  ---@param matColor string Does not support "All"
  function PlayermatApi.getSlotData(matColor)
    for _, mat in pairs(getMatForColor(matColor)) do
      return mat.getTable("slotData")
    end
  end

  -- Sets the slot data for the playermat
  ---@param matColor string Does not support "All"
  ---@param newSlotData table New slot data for the playermat
  function PlayermatApi.loadSlotData(matColor, newSlotData)
    return callForSingleMat(matColor, "updateSlotSymbols", newSlotData)
  end

  -- Performs a search of the deck area of the requested playermat and returns the result as table
  ---@param matColor string Does not support "All"
  function PlayermatApi.getDeckAreaObjects(matColor)
    return callForSingleMat(matColor, "getDeckAreaObjects")
  end

  -- Flips the top card of the deck (useful after deck manipulation for Norman Withers)
  ---@param matColor string Does not support "All"
  ---@param additionalDelay? number Additional delay for this function
  function PlayermatApi.flipTopCardFromDeck(matColor, additionalDelay)
    return callForSingleMat(matColor, "flipTopCardFromDeck", additionalDelay)
  end

  -- Returns the position of the discard pile of the requested playermat
  ---@param matColor string Does not support "All"
  function PlayermatApi.getDiscardPosition(matColor)
    return Vector(callForSingleMat(matColor, "returnGlobalDiscardPosition"))
  end

  -- Returns the position of the draw pile of the requested playermat
  ---@param matColor string Does not support "All"
  function PlayermatApi.getDrawPosition(matColor)
    return Vector(callForSingleMat(matColor, "returnGlobalDrawPosition"))
  end

  -- Transforms a local position into a global position
  ---@param localPos table Local position to be transformed
  ---@param matColor string Does not support "All"
  function PlayermatApi.transformLocalPosition(localPos, matColor)
    for _, mat in pairs(getMatForColor(matColor)) do
      return mat.positionToWorld(localPos)
    end
  end

  -- Returns the rotation of the requested playermat
  ---@param matColor string Does not support "All"
  function PlayermatApi.returnRotation(matColor)
    for _, mat in pairs(getMatForColor(matColor)) do
      return mat.getRotation()
    end
  end

  -- Returns a table with spawn data (position and rotation) for a helper object
  ---@param helperName string Name of the helper object
  function PlayermatApi.getHelperSpawnData(matColor, helperName)
    local resultTable = {}
    for color, mat in pairs(getMatForColor(matColor)) do
      local data = mat.call("getHelperSpawnData", helperName)
      resultTable[color] = { position = Vector(data.position), rotation = Vector(data.rotation) }
    end
    return resultTable
  end

  -- Triggers the Upkeep for the requested playermat
  ---@param playerColor string Color of the calling player (for messages)
  function PlayermatApi.doUpkeepFromHotkey(matColor, playerColor)
    for _, mat in pairs(getMatForColor(matColor)) do
      mat.call("doUpkeepFromHotkey", playerColor)
    end
  end

  -- Triggers the Discard One function for the requested playermat
  ---@param playerColor string Color of the calling player (for messages)
  function PlayermatApi.doDiscardOneFromHotkey(matColor, playerColor)
    for _, mat in pairs(getMatForColor(matColor)) do
      mat.call("doDiscardOneFromHotkey", playerColor)
    end
  end

  -- Gets data about the active investigator
  ---@param matColor string Does not support "All"
  function PlayermatApi.getActiveInvestigatorData(matColor)
    return callForSingleMat(matColor, "getActiveInvestigatorData")
  end

  -- Sets data about the active investigator
  ---@param newData table New active investigator data (class and id)
  function PlayermatApi.setActiveInvestigatorData(matColor, newData)
    for _, mat in pairs(getMatForColor(matColor)) do
      mat.call("setActiveInvestigatorData", newData)
    end
  end

  -- Returns the position for encounter card drawing
  ---@param matColor string Does not support "All"
  ---@param stack boolean If true, returns the leftmost position instead of the first empty from the right
  function PlayermatApi.getEncounterCardDrawPosition(matColor, stack)
    return Vector(callForSingleMat(matColor, "getEncounterCardDrawPosition", stack))
  end

  -- Sets the requested playermat's snap points to limit snapping to matching card types or not
  ---@param matchCardTypes boolean Whether snap points should only snap for the matching card types
  function PlayermatApi.setLimitSnapsByType(matchCardTypes, matColor)
    return callForSingleMat(matColor, "setLimitSnapsByType", matchCardTypes)
  end

  -- Sets the requested playermat's draw 1 button to visible
  ---@param isDrawButtonVisible boolean Whether the draw 1 button should be visible or not
  function PlayermatApi.showDrawButton(isDrawButtonVisible, matColor)
    for _, mat in pairs(getMatForColor(matColor)) do
      mat.call("showDrawButton", isDrawButtonVisible)
    end
  end

  -- Updates clue counts to account for clickable clue counters
  ---@param showCounter boolean Whether the clickable counter should be present or not
  function PlayermatApi.clickableClues(showCounter, matColor)
    for _, mat in pairs(getMatForColor(matColor)) do
      mat.call("clickableClues", showCounter)
    end
  end

  -- Toggles the use of class textures for the requested playermat
  ---@param state boolean Whether the class texture should be used or not
  function PlayermatApi.useClassTexture(state, matColor)
    for _, mat in pairs(getMatForColor(matColor)) do
      mat.call("useClassTexture", state)
    end
  end

  -- updates the texture of the playermat
  ---@param overrideName? string Force a specific texture
  function PlayermatApi.updateTexture(matColor, overrideName)
    for _, mat in pairs(getMatForColor(matColor)) do
      mat.call("updateTexture", overrideName)
    end
  end

  -- Removes clues (to the trash for tokens and counters set to 0) for the requested playermat
  ---@param number? number Number of clues to remove (defaults to all)
  function PlayermatApi.removeClues(matColor, number)
    for _, mat in pairs(getMatForColor(matColor)) do
      mat.call("removeClues", number)
    end
  end

  -- Reports the clue count for the requested playermat
  function PlayermatApi.getClueCount(matColor)
    local total       = 0
    local playerClues = {}
    for matColor2, mat in pairs(getMatForColor(matColor)) do
      local count            = (mat.call("getClueCount") or 0)
      total                  = total + count
      playerClues[matColor2] = count
    end
    return total, playerClues
  end

  -- Reports the doom count for the requested playermat
  function PlayermatApi.getDoomCount(matColor)
    local count = 0
    for _, mat in pairs(getMatForColor(matColor)) do
      count = count + (mat.call("getDoomCount") or 0)
    end
    return count
  end

  -- Updates the specified owned counter
  ---@param type string Counter to target
  ---@param newValue number Value to set the counter to
  ---@param modifier number If newValue is not provided, the existing value will be adjusted by this modifier
  function PlayermatApi.updateCounter(matColor, type, newValue, modifier)
    for _, mat in pairs(getMatForColor(matColor)) do
      mat.call("updateCounter", { type = type, newValue = newValue, modifier = modifier })
    end
  end

  -- Triggers the draw function for the specified playermat
  ---@param number number Amount of cards to draw
  function PlayermatApi.drawCardsWithReshuffle(matColor, number, alt)
    for _, mat in pairs(getMatForColor(matColor)) do
      mat.call("drawCardsWithReshuffleWrapper", { numCards = number, fromBottom = alt })
    end
  end

  -- Updates the internal "messageColor" which is used for print/broadcast statements if no player is seated
  ---@param newMessageColor? string Colorstring of player who clicked a button
  function PlayermatApi.updateMessageColor(matColor, newMessageColor)
    for _, mat in pairs(getMatForColor(matColor)) do
      mat.call("updateMessageColor", newMessageColor)
    end
  end

  -- Returns the current message color
  ---@param matColor string Does not support "All"
  function PlayermatApi.getMessageColor(matColor)
    for _, mat in pairs(getMatForColor(matColor)) do
      return mat.call("getMessageColor")
    end
  end

  -- Returns the value of an owned counter (e.g. ResourceCounter, DamageCounter, HorrorCounter)
  ---@param matColor string Does not support "All"
  ---@param type string Counter to target
  function PlayermatApi.getCounterValue(matColor, type)
    return callForSingleMat(matColor, "getCounterValue", type)
  end

  -- Returns a list of mat colors that have an investigator placed
  function PlayermatApi.getUsedMatColors()
    local usedColors = {}
    for matColor, card in pairs(PlayermatApi.getUsedInvestigatorCards()) do
      table.insert(usedColors, matColor)
    end
    return usedColors
  end

  -- Returns a list of investigator card objects
  function PlayermatApi.getUsedInvestigatorCards()
    local usedCards = {}
    for matColor, mat in pairs(getMatForColor("All")) do
      local searchPos = mat.positionToWorld(localInvestigatorPosition)
      local searchResult = SearchLib.atPosition(searchPos, "isCardOrDeck")
      if #searchResult > 0 then
        usedCards[matColor] = searchResult[1]
      end
    end
    return usedCards
  end

  -- Returns investigator name
  ---@param matColor string Does not support "All"
  function PlayermatApi.getInvestigatorName(matColor)
    for _, mat in pairs(getMatForColor(matColor)) do
      local searchPos = mat.positionToWorld(localInvestigatorPosition)
      local searchResult = SearchLib.atPosition(searchPos, "isCardOrDeck")
      if #searchResult == 1 then
        return searchResult[1].getName()
      end
    end
    return ""
  end

  -- Trigger the onCollisionEnter event remotely
  ---@param matColor string Does not support "All"
  function PlayermatApi.onCollisionEnter(matColor, collisionInfo)
    return callForSingleMat(matColor, "onCollisionEnter", collisionInfo)
  end

  -- Finds all objects on the playermat and associated set aside zone and returns a table
  ---@param filter? string Name of the filte function (see util/SearchLib)
  function PlayermatApi.searchAroundPlayermat(matColor, filter)
    local objList = {}
    for _, mat in pairs(getMatForColor(matColor)) do
      for _, obj in ipairs(mat.call("searchAroundSelf", filter)) do
        table.insert(objList, obj)
      end
    end
    return objList
  end

  -- Spawns the regular action tokens
  function PlayermatApi.spawnActionTokens(matColor)
    for _, mat in pairs(getMatForColor(matColor)) do
      mat.call("spawnActionTokens")
    end
  end

  -- Triggers the metadata sync for all playermats
  function PlayermatApi.syncAllCustomizableCards()
    for _, mat in pairs(getMatForColor("All")) do
      mat.call("syncAllCustomizableCards")
    end
  end

  -- Gets the value of an option set in the mat's option panel
  ---@param matColor string Does not support "All"
  ---@param setting string Name of the setting to retrieve
  function PlayermatApi.getOptionPanelSetting(matColor, setting)
    return callForSingleMat(matColor, "getOptionPanelSetting", setting)
  end

  -- Gets the exhaust rotation that's set in the mat's option panel
  ---@param matColor string Does not support "All"
  ---@param convertToGlobal? boolean True if the global (Vector) rotation is requested (otherwise just local Y-rotation)
  function PlayermatApi.getExhaustRotation(matColor, convertToGlobal)
    return callForSingleMat(matColor, "getExhaustRotation", convertToGlobal)
  end

  -- moves + rotates a playermat (and related objects)
  ---@param position? table New position for the playermat
  ---@param rotationY? number New y-rotation for the playermat (X and Z will be 0)
  ---@param positionOffset? table Positional offset for the playermat
  function PlayermatApi.moveAndRotate(matColor, position, rotationY, positionOffset)
    local params = { position = position, rotationY = rotationY, positionOffset = positionOffset }
    return callForSingleMat(matColor, "moveAndRotateSelf", params)
  end

  -- Instructs the playermat to not touch the regular action tokens for the next investigator change
  function PlayermatApi.activateTransformEffect(matColor)
    return callForSingleMat(matColor, "activateTransformEffect")
  end

  return PlayermatApi
end
end)
__bundle_register("tokens/TokenArrangerApi", function(require, _LOADED, __bundle_register, __bundle_modules)
do
  local TokenArrangerApi = {}
  local GUIDReferenceApi = require("core/GUIDReferenceApi")

  -- local function to call the token arranger, if it is on the table
  ---@param functionName string Name of the function to call
  ---@param argument? table Parameter to pass
  local function callIfExistent(functionName, argument)
    local tokenArranger = GUIDReferenceApi.getObjectByOwnerAndType("Mythos", "TokenArranger")
    if tokenArranger ~= nil then
      return tokenArranger.call(functionName, argument)
    end
  end

  -- updates the token modifiers with the provided data
  ---@param fullData table Contains the chaos token metadata
  function TokenArrangerApi.onTokenDataChanged(fullData)
    callIfExistent("onTokenDataChanged", fullData)
  end

  -- deletes already laid out tokens
  function TokenArrangerApi.deleteCopiedTokens()
    callIfExistent("deleteCopiedTokens")
  end

  -- updates the laid out tokens
  function TokenArrangerApi.layout()
    Wait.time(function() callIfExistent("layout") end, 0.1)
  end

  -- get modifier (or precedence value) of specified token
  function TokenArrangerApi.getCurrentModifier(tokenName)
    return callIfExistent("getCurrentModifier", tokenName)
  end

  return TokenArrangerApi
end
end)
__bundle_register("util/SearchLib", function(require, _LOADED, __bundle_register, __bundle_modules)
do
  local SearchLib = {}
  local FILTER_FUNCTIONS = {
    isCard           = function(x) return x.type == "Card" end,
    isDeck           = function(x) return x.type == "Deck" end,
    isCardOrDeck     = function(x) return x.type == "Card" or x.type == "Deck" end,
    isClue           = function(x) return x.memo == "clueDoom" and x.is_face_down == false end,
    isDoom           = function(x) return x.memo == "clueDoom" and x.is_face_down == true end,
    isInteractable   = function(x) return x.interactable end,
    isTileOrToken    = function(x) return not x.Book and (x.type == "Tile" or x.type == "Generic") end,
    isUniversalToken = function(x) return x.getMemo() == "universalActionAbility" end,
  }

  -- performs the actual search and returns a filtered list of object references
  ---@param params table Table with parameters:
  --- pos tts__Vector Global position
  --- rot? tts__Vector Global rotation
  --- size? table Size
  --- filter? string|function Name of the filter function or custom filter function
  --- direction? table Direction (positive is up)
  --- maxDistance? number Distance for the cast
  --- debug? boolean Whether the debug boxes should be shown
  local function performSearch(params)
    if not params or not params.pos then return {} end

    local filterFunc
    if type(params.filter) == "string" then
      filterFunc = FILTER_FUNCTIONS[params.filter]
    elseif type(params.filter) == "function" then
      filterFunc = params.filter
    end

    local searchResult = Physics.cast({
      type         = 3,
      origin       = params.pos,
      orientation  = params.rot or { 0, 0, 0 },
      size         = params.size or { 0.1, 2, 0.1 },
      direction    = params.direction or { 0, 1, 0 },
      max_distance = params.maxDistance or 0,
      debug        = params.debug or false
    })

    local objList = {}
    for _, data in ipairs(searchResult) do
      local o = data.hit_object
      if (not filterFunc or filterFunc(o)) then
        table.insert(objList, o)
      end
    end
    return objList
  end

  -- searches the specified area
  function SearchLib.inArea(pos, rot, size, filter, debug)
    return performSearch({
      pos    = pos,
      rot    = rot,
      size   = size,
      filter = filter,
      debug  = debug
    })
  end

  -- searches the area on an object
  function SearchLib.onObject(obj, filter, scale, debug)
    return performSearch({
      pos    = obj.getPosition() + Vector(0, 1, 0), -- offset by half the cast's height
      size   = obj.getBounds().size:scale(scale or 1):setAt("y", 2),
      filter = filter,
      debug  = debug
    })
  end

  -- searches the area directly below an object
  function SearchLib.belowObject(obj, filter, scale, debug)
    local objPos = obj.getPosition()
    return performSearch({
      pos    = objPos + Vector(0, -objPos.y / 2, 0), -- offset by half the cast's height
      size   = obj.getBounds().size:scale(scale or 1):setAt("y", objPos.y),
      filter = filter,
      debug  = debug
    })
  end

  -- searches the specified position (a single point)
  function SearchLib.atPosition(pos, filter, debug)
    return performSearch({
      pos    = pos,
      filter = filter,
      debug  = debug
    })
  end

  -- searches below the specified position (downwards until y = 0)
  function SearchLib.belowPosition(pos, filter, debug)
    return performSearch({
      pos         = pos,
      filter      = filter,
      direction   = { 0, -1, 0 },
      maxDistance = pos.y,
      debug       = debug
    })
  end

  return SearchLib
end
end)
__bundle_register("util/TableLib", function(require, _LOADED, __bundle_register, __bundle_modules)
do
  local TableLib = {}

  -- Concatenates the array parts of t1 and t2 into a new table
  function TableLib.concat(t1, t2)
    local result = {}
    if type(t1) == "table" then
      for _, v in ipairs(t1) do table.insert(result, v) end
    end
    if type(t2) == "table" then
      for _, v in ipairs(t2) do table.insert(result, v) end
    end
    return result
  end

  -- Checks if a list contains an element
  function TableLib.contains(t, ele)
    if t == nil then return false end
    for k, v in ipairs(t) do
      if v == ele then return true end
    end
    return false
  end

  -- Copies a table (or returns the original if not a table)
  function TableLib.copy(t)
    if type(t) ~= "table" then return t end
    local copy = {}
    for tKey, tValue in next, t, nil do
      copy[TableLib.copy(tKey)] = TableLib.copy(tValue)
    end
    setmetatable(copy, TableLib.copy(getmetatable(t)))
    return copy
  end

  -- Returns a new list containing only elements that satisfy the filter function.
  function TableLib.filter(t, func)
    local result = {}
    if type(t) ~= "table" or type(func) ~= "function" then return result end
    for k, v in ipairs(t) do
      if func(v, k) then
        table.insert(result, v)
      end
    end
    return result
  end

  -- Returns the index of an element
  function TableLib.getElementIndex(t, ele)
    if t == nil then return nil end
    for k, v in ipairs(t) do
      if v == ele then return k end
    end
    return nil
  end

  -- Returns the keys of a table that match filterValue as new table
  function TableLib.getKeys(t, filterValue)
    local keys = {}
    for k, v in pairs(t) do
      if filterValue == nil or v == filterValue then
        table.insert(keys, k)
      end
    end
    return keys
  end

  -- Returns the length of a table
  function TableLib.getLength(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
  end

  -- Checks if a table is empty
  function TableLib.isEmpty(t)
    return next(t) == nil
  end

  -- Returns a map from a list (value = true)
  function TableLib.makeMap(t)
    local m = {}
    for _, v in ipairs(t) do
      m[v] = true
    end
    return m
  end

  -- Merges the contents of two tables into a new table.
  -- If a key exists in both tables, the value from t2 is used.
  function TableLib.merge(t1, t2)
    local result = {}
    for k, v in pairs(t1 or {}) do result[k] = v end
    for k, v in pairs(t2 or {}) do result[k] = v end
    return result
  end

  -- Returns a random list element
  function TableLib.pickRandom(t)
    if TableLib.isEmpty(t) then return nil end
    return t[math.random(#t)]
  end

  -- Returns a copy of a list without duplicates
  function TableLib.removeDuplicates(t)
    local seen   = {}
    local result = {}
    for _, value in ipairs(t) do
      if not seen[value] then
        seen[value] = true
        table.insert(result, value)
      end
    end
    return result
  end

  -- Removes a value from a list (first occurence)
  ---@return boolean: True if something was removed
  function TableLib.removeValue(t, val)
    for i, v in ipairs(t) do
      if v == val then
        table.remove(t, i)
        return true
      end
    end
    return false
  end

  -- Reverses a list in place
  function TableLib.reverse(t)
    local n = #t
    local i = 1
    local j = n

    -- Iterate from the start (i) and the end (j) until they meet in the middle
    while i < j do
      t[i], t[j] = t[j], t[i]
      i = i + 1
      j = j - 1
    end
    return t
  end

  -- Shuffles a list in place (Fisher-Yates-Shuffle)
  -- optionally, only shuffles a specific part of the list
  function TableLib.shuffle(t, startIndex, endIndex)
    if not t or type(t) ~= "table" then return end
    startIndex = math.max(1, startIndex or 1)
    endIndex = math.min(#t, endIndex or #t)
    if startIndex >= endIndex then return end

    for i = endIndex, startIndex + 1, -1 do
      local j = math.random(startIndex, i)
      t[i], t[j] = t[j], t[i]
    end
  end

  return TableLib
end
end)
return __bundle_require("__root")