# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#PredictedRMSE = (-1.18808+ 0.322101*T^1.2964)NumberOfGames^(0.186474*D^0.086981*(1-3.3364/(T^0.778216*G^0.077255)))  #formula from research conducted by Jacob Bernard, Kyle Shelton, Daniel Grube
 
cConstant = -1.18808
cNumPlayersCoefficient = 0.322101
cNumPlayersExponent = 1.2964
bDisparityCoefficient = .186474
bDisparityExponent = .086981
bNumerator = 3.3364
bNumPlayersExponent = .778261
bNumPlayersPerGameExponent = .077255



window.onload = () -> (   
   setupForMultiplayerElements() 
   attachListeners()
)

setupForMultiplayerElements = () -> (
   matchTypeSelector = getMatchTypeSelector()
   totalMatchesDiv = getTotalMatchesDiv()
   disparityDiv = getDisparityDiv()
   if matchTypeSelector.value == "multiplayer game"
    disparityDiv.removeAttribute("hidden")
    totalMatchesDiv.removeAttribute("hidden")
   else
    disparityDiv.setAttribute("hidden", true) 
    totalMatchesDiv.setAttribute("hidden", true)
)

getDisparityDiv = () -> (
   disparityInput = getDisparityInput()
   if disparityInput != null
    disparityInputFather = disparityInput.parentNode
)

getDisparityInput = () -> (
   disparityInput = document.getElementById("tournament_expected_disparity")
)

getTotalMatchesDiv = () -> (
   totalMatchesInput = getTotalMatchesInput()
   if totalMatchesInput != null
    totalMatchesFather = totalMatchesInput.parentNode
)

getTotalMatchesInput = () -> (
   totalMatchesInput = document.getElementById("tournament_total_matches")
)

getMatchTypeSelector = () -> (
   document.getElementById('tournament_tournament_type')
)

getNumberOfPlayers = () -> (
   playerNumberHolder =  document.getElementById('rightValues')
   #playerNumberHolder.length 
   return 100
)

RMSEConditionChange = () -> (
  getDisparity()
  getNumberOfPlayers()
  totalMatchesChange() 
)

totalMatchesChange = () -> (
  totalMatchesInput = getTotalMatchesInput()
  totalMatchesRaw = totalMatchesInput.value
  totalMatches = computeTotalMatchesFromRawInput(totalMatchesRaw)
  totalTime = calculateMaxTimeFromNumMatches(totalMatches)
  console.log(totalTime)  
  RMSE = calculateRMSE(totalMatches)
  console.log(RMSE)
  totalMatches = Math.floor(totalMatches)
  totalMatchesInput.value = totalMatches
  console.log(totalMatchesInput.value) 
)

computeTotalMatchesFromRawInput = (rawMatches) -> (
  preppedMatches = setupTotalMatchesForLog(rawMatches)
  totalMatches = Math.pow(preppedMatches, 10)
)

setupTotalMatchesForLog = (rawMatches) -> (
  preppedMatches = rawMatches/100
  return preppedMatches
)
  

getNumberOfPlayersPerGame = () -> (
  numPlayersPerGame = playersPerGame ##retreived from the associated HTML file
  numPlayers = getNumberOfPlayers()
  if numPlayersPerGame >= numPlayers
    numPlayersPerGame = numPlayers
  return numPlayersPerGame
)

getDisparity = () -> ( 
  #WARNING: disparity is currently being calculated as if players were evenly distributed amongst a range of skills, while the formula to calculate RMSE assumes normal distribution
  #values generated using an ELO calculator                  
  numPlayers = getNumberOfPlayers()
  disparityInput = getDisparityInput()
  disparityString = disparityInput.value
  if disparityString == "Very small"
    eloDifferenceBetweenConsecutivePlayers = 14
  else if disparityString == "Small"
    eloDifferenceBetweenConsecutivePlayers = 35
  else if disparityString == "Medium small"
    eloDifferenceBetweenConsecutivePlayers = 108
  else if disparityString == "Medium"
    eloDifferenceBetweenConsecutivePlayers = 191 
  else if disparityString == "Medium large"
    eloDifferenceBetweenConsecutivePlayers = 301
  else if disparityString == "Large"
    eloDifferenceBetweenConsecutivePlayers = 512
  else if disparityString == "Very large"
    eloDifferenceBetweenConsecutivePlayers = 798
  else
    eloDifferenceBetweenConsecutivePlayers = 0
  disparityRange = eloDifferenceBetweenConsecutivePlayers*(numPlayers-1)
  if disparityRange <= 0
    disparityRange = 0
  return disparityRange
)

calculateNumberOfMatchesToPlay = (RMSE) -> ( 
  #PredictedRMSE = (-1.18808+ 0.322101*T^1.2964)NumberOfGames^(0.186474*D^0.086981*(1-3.3364/(T^0.778216*G^0.077255)))  #formula from research conducted by Jacob Bernard, Kyle Shelton, Daniel Grube
  disparity = getDisparity()
  numberOfPlayers = getNumberOfPlayers()
  numberOfPlayersPerGame = getNumberOfPlayersPerGame()
  firstPartOfTheTerm = bDisparityCoefficient*Math.pow(disparity, bDisparityExponent)
  secondPartOfTheTerm = bNumerator/(Math.pow(numberOfPlayers, bNumPlayersExponent)*Math.pow(numberOfPlayersPerGame, bNumPlayersPerGameExponent))
  b = -(firstPartOfTheTerm*(1-secondPartOfTheTerm))
  c = cConstant + cNumPlayersCoefficient*(Math.pow(numberOfPlayers, cNumPlayersExponent))
  numMatchesToPlay = Math.pow((RMSE/c),1/b)
  if numMachesToPlay <= 0
    return 0
  return numMatchesToPlay
)

calculateMaxTimeFromNumMatches = (numMatches) -> (
  predictedTimePerMatch = maxTimePerMatch
  return numMatches*predictedTimePerMatch
)

calculateRMSE = (numMatchesToPlay) -> (
  disparity = getDisparity()
  if disparity == 0 
    return 0  
  numberOfPlayers = getNumberOfPlayers()
  numberOfPlayersPerGame = getNumberOfPlayersPerGame()
  firstPartOfTheTerm = bDisparityCoefficient*Math.pow(disparity, bDisparityExponent)
  secondPartOfTheTerm = bNumerator/(Math.pow(numberOfPlayers, bNumPlayersExponent)*Math.pow(numberOfPlayersPerGame, bNumPlayersPerGameExponent))
  b = -1*(firstPartOfTheTerm*(1-secondPartOfTheTerm))
  c = cConstant + cNumPlayersCoefficient*(Math.pow(numberOfPlayers, cNumPlayersExponent))
  RMSE = c*Math.pow(numMatchesToPlay, b)
  if RMSE <= 0
    return 0
  return RMSE
)

attachListeners = () -> (
   matchType = getMatchTypeSelector()
   matchType.addEventListener('click', setupForMultiplayerElements)
   totalMatchesInput = getTotalMatchesInput()
   totalMatchesInput.addEventListener('click', totalMatchesChange)
   disparityInput = getDisparityInput()
   disparityInput.addEventListener('click', RMSEConditionChange)
   rightButton = document.getElementById('btnRight')
   leftButton  = document.getElementById('btnLeft')
   rightButton.addEventListener('click', RMSEConditionChange)
   leftButton.addEventListener('click', RMSEConditionChange)
)
