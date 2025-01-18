package main

import "core:time"
import "core:fmt"
import "core:os"
import "core:bytes"
import "core:strings"
import "core:strconv"
import "core:slice"

main :: proc() {
	file_name := os.args[1]
	input, ok := os.read_entire_file(file_name, context.temp_allocator)
	assert(ok)

	width: int
	for c, i in input {
		if c == '\n' {
			width = i
			break
		}
	}
	height := len(input) / (width+1)

	lines := strings.split_lines(string(input), context.temp_allocator)
	good_input := make([dynamic]u8, 0, len(input), context.temp_allocator)
	for line in lines {
		for b in transmute([]u8)line do append(&good_input, b)
	}

	t := time.tick_now()
	res1 := part1(good_input[:], width, height)
	duration := time.tick_lap_time(&t)
	fmt.println("Answer   part 1 =", res1)
	fmt.println("Duration part 1 =", duration)

	t = time.tick_now()
	res2 := part2(good_input[:], width, height)
	duration = time.tick_lap_time(&t)
	fmt.println("Answer   part 2 =", res2)
	fmt.println("Duration part 2 =", duration)
}

append_if_unique :: proc(list: ^[dynamic][2]int, pos: [2]int) {
	// linear search poggers
	for p in list {
		if p == pos do return
	}
	append(list, pos)
}

in_bounds :: proc(pos: [2]int, width: int, height: int) -> bool {
	return pos.x >= 0 && pos.x < width && pos.y >= 0 && pos.y < height
}

pos_to_index :: proc(pos: [2]int, width: int) -> int {
	return pos.y * width + pos.x
}

part1 :: proc(input: []u8, width, height: int) -> int {
	unique_entries := make([dynamic][2]int)
	for c, i in input {
		if c != '.' {
			currently_checking := c
			currently_checking_pos := [2]int{i % width, i / width}
			for j := i+1; j < len(input); j += 1 {
				match := input[j]
				if match == currently_checking {
					match_pos := [2]int{j % width, j / width}
					dist := currently_checking_pos - match_pos

					anti_node0_pos := currently_checking_pos + dist
					anti_node1_pos := match_pos - dist

					if in_bounds(anti_node0_pos, width, height) {
						append_if_unique(&unique_entries, anti_node0_pos)
					}

					if in_bounds(anti_node1_pos, width, height) {
						append_if_unique(&unique_entries, anti_node1_pos)
					}
				}
			}
		}
	}

	return len(unique_entries)
}

part2 :: proc(input: []u8, width, height: int) -> int {
	unique_entries := make([dynamic][2]int)
	for c, i in input {
		if c != '.' {
			currently_checking := c
			currently_checking_pos := [2]int{i % width, i / width}
			for j := i+1; j < len(input); j += 1 {
				match := input[j]
				if match == currently_checking {
					match_pos := [2]int{j % width, j / width}
					dist := currently_checking_pos - match_pos

					curr0 := currently_checking_pos + dist
					for in_bounds(curr0, width, height) {
						append_if_unique(&unique_entries, curr0)
						curr0 += dist
					}

					curr1 := currently_checking_pos
					for in_bounds(curr1, width, height) {
						append_if_unique(&unique_entries, curr1)
						curr1 -= dist
					}
				}
			}
		}
	}

	return len(unique_entries)
}
