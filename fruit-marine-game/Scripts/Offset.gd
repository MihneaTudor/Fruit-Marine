extends Node

var counter: int = 1  # Integer to keep track of

func set_counter(value: float):
	counter=value

func increase_int():
	counter += 0.15
	print("Counter increased to:", counter)

func get_counter() -> int:
	return counter
