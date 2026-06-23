extends Node

signal score_changed(new_score: int)

const FIRST_NETTLE_POINTS := 5
const NEW_NETTLE_POINTS := 1

var score: int = 0


func reset_score() -> void:
	score = 0
	score_changed.emit(score)


func add_points(amount: int) -> void:
	if amount <= 0:
		return
	
	score += amount
	score_changed.emit(score)


func can_afford(cost: int) -> bool:
	return score >= cost


func spend_points(cost: int) -> bool:
	if cost <= 0:
		return true
	
	if score < cost:
		return false
	
	score -= cost
	score_changed.emit(score)
	return true
