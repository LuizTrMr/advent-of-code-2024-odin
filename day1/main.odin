package main

import "core:time"
import "core:slice"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

insert_at_correct_position :: proc(list: ^[dynamic]int, item: int) {
	index := len(list)
	for v, i in list {
		if item <= v {
			index = i
			break
		}
	}
	inject_at(list, index, item)
}

main :: proc() {
	input, ok := os.read_entire_file("./input.txt", context.temp_allocator)
	assert(ok)

	lines := strings.split_lines(string(input), context.temp_allocator)
	lines = lines[:len(lines)-1]

	left  := make([dynamic]int, 0, len(lines), context.temp_allocator)
	right := make([dynamic]int, 0, len(lines), context.temp_allocator)

	t := time.tick_now()
	for line in lines {
		values := strings.split(line, "   ", context.temp_allocator)
		left_item  := strconv.atoi(values[0])
		insert_at_correct_position(&left, left_item)
		right_item := strconv.atoi(values[1])
		insert_at_correct_position(&right, right_item)
	}
	duration := time.tick_lap_time(&t)
	fmt.println("Parsing and sorting:", duration)

	p1 := part1(left, right)
	duration = time.tick_lap_time(&t)
	fmt.println("Part 1:", duration)
	fmt.println("Part 1 result =", p1)

	p2 := part2_no_pessimization(left, right)
	duration = time.tick_lap_time(&t)
	fmt.println("Part 2 no pessimization:", duration)
	fmt.println("Part 2 no pessimization result =", p2)
}

part1 :: proc(left, right: [dynamic]int) -> (sum: int) {
	for i in 0..<len(left) {
		sum += abs(left[i] - right[i])
	}
	return
}

part2_no_pessimization :: proc(left, right: [dynamic]int) -> (sum: int) {
	i: int
	j: int
	for i < len(left) && j < len(right) {
		if left[i] < right[j] {
			i += 1
		} else if left[i] == right[j] {
			total: int

			// Without cache
			v := right[j]
			temp := j
			for v == left[i] {
				temp += 1
				v = right[temp]
				total += left[i]
			}

			sum += total
			i += 1

		} else { // left[i] > right[j]
			for j < len(right) && right[j] < left[i] do j += 1
		}
	}
	return
}
