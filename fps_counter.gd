extends Label

@export var update_interval: float = 0.1
@export var sample_window_seconds: float = 2.0

var time_passed: float = 0.0
var frame_times: Array[float] = []

func _process(delta: float) -> void:
	if delta <= 0.0:
		return
		
	frame_times.append(delta)
	
	var max_frames_to_keep = int(sample_window_seconds / delta)
	while frame_times.size() > max_frames_to_keep:
		frame_times.remove_at(0)

	time_passed += delta
	if time_passed >= update_interval:
		_update_fps_display()
		time_passed = 0.0

func _update_fps_display() -> void:
	if frame_times.is_empty():
		return
		
	# Avg FPS
	var total_time: float = 0.0
	for f_time in frame_times:
		total_time += f_time
		
	var avg_delta: float = total_time / frame_times.size()
	var avg_fps: float = 1.0 / avg_delta
	
	# 1% Lows
	var sorted_frames = frame_times.duplicate()
	sorted_frames.sort()
	
	var one_percent_count: int = max(1, int(sorted_frames.size() * 0.01))
	var worst_one_percent_total_time: float = 0.0
	for i in range(sorted_frames.size() - one_percent_count, sorted_frames.size()):
		worst_one_percent_total_time += sorted_frames[i]
		
	var low_1_percent_delta: float = worst_one_percent_total_time / one_percent_count
	var low_1_percent_fps: float = 1.0 / low_1_percent_delta
	
	text = "FPS: " + str(snapped(1.0 / frame_times.back(), 1)) + \
		   "\nAVG: " + str(snapped(avg_fps, 1)) + \
		   "\n1% LOW: " + str(snapped(low_1_percent_fps, 1))
