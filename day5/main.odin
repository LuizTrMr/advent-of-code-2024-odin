package main

import "core:time"
import "core:fmt"
import "core:os"
import "core:bytes"
import "core:strings"
import "core:strconv"
import "core:slice"

main :: proc() {
	input, ok := os.read_entire_file("./input.txt", context.temp_allocator)
	assert(ok)
	
	t := time.tick_now()
	rules := make(map[string][dynamic]string, context.temp_allocator)
	i: int
	for i < len(input) {
		num1 := string(input[i:i+2])
		num2 := string(input[i+3:i+5])
		
		if !(num2 in rules) {
			rules[num2] = make([dynamic]string, context.temp_allocator)
		}
		append(&rules[num2], num1)

		i += 6
		if input[i] == '\n' do break
	}
	i += 1
	duration := time.tick_lap_time(&t)
	fmt.println("Duration for parsing rules:", duration)

	updates := make([]byte, len(input[i:]))
	n := copy(updates[:], input[i:])
	assert(n > 0)
	t = time.tick_now()
	res1 := part1(updates, rules)
	duration = time.tick_lap_time(&t)
	fmt.println("Part 1 answer =", res1)
	fmt.println("Duration for part1 =", duration)

	n = copy(updates[:], input[i:])
	assert(n > 0)
	t = time.tick_now()
	res2 := part2(updates, rules)
	duration = time.tick_lap_time(&t)
	fmt.println("Part 2 answer =", res2)
	fmt.println("Duration for part2 =", duration)
}

part1 :: proc(updates: []byte, rules: map[string][dynamic]string) -> (sum: int) {
	is_valid :: proc(rules: map[string][dynamic]string, values: []string) -> bool {
		for i in 0..<len(values) {
			for j in i+1..<len(values) {
				left  := values[i]
				right := values[j]
				if slice.contains(rules[left][:], right) do return false
			}
		}
		return true
	}

	updates := updates
	for len(updates) > 0 {
		line := bytes.index_byte(updates, '\n')
		if line == -1 do break

		values := strings.split(string(updates[:line]), ",")

		if is_valid(rules, values) {
			mid, _ := strconv.parse_int(values[len(values)/2], 10)
			sum += mid
		}
		updates = updates[line+1:]
	}
	return
}

part2 :: proc(updates: []byte, rules: map[string][dynamic]string) -> (sum: int) {
	is_valid_and_correction :: proc(rules: map[string][dynamic]string, values: []string) -> (ok: bool) {
		ok = true
		for i in 0..<len(values) {
			for j in i+1..<len(values) {
				left  := values[i]
				right := values[j]
				if slice.contains(rules[left][:], right) {
					values[i], values[j] = values[j], values[i]

					ok = false
				}
			}
		}
		return
	}

	updates := updates
	for len(updates) > 0 {
		line := bytes.index_byte(updates, '\n')
		if line == -1 do break

		values := strings.split(string(updates[:line]), ",")

		if !is_valid_and_correction(rules, values) {
			mid, _ := strconv.parse_int(values[len(values)/2], 10)
			sum += mid
		}
		updates = updates[line+1:]
	}
	return
}
