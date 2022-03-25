extends Node

# Preload all the game assets

enum {GameInitialising, StartScreen, GamePlaying}

# Used to keep track of if the game is actually running.  When false, enemies arent generated etc 
export var gameStatus = GameInitialising
export var gameRunning = false
