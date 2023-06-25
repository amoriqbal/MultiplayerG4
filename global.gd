extends Node


var spawnPosNext:Vector2 = Vector2.ZERO
const spawnIncr:Vector2 = Vector2(50,50)

func getSpawnPos()->Vector2:
	spawnPosNext += spawnIncr
	print(spawnPosNext)
	return spawnPosNext
