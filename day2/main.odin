package main

import "core:time"
import "core:slice"
import "core:fmt"
import "core:os"
import "core:bytes"
import "core:strings"
import "core:strconv"

sign_of :: proc(a: int) -> int {
	return -1 if a <= 0 else 1
}

is_safe_part2 :: proc(numbers: []string) -> bool {
	for i in 0..<len(numbers) {
		a := slice.concatenate([][]string{numbers[:i], numbers[i+1:]}, context.temp_allocator)

		if is_safe_part1(a) do return true
	}
	return false
}

is_safe :: proc(numbers: []string) -> bool {
	decreasing: bool
	increasing: bool

	for i in 0..<len(numbers)-1 {
		x, _ := strconv.parse_int(numbers[i]  , 10)
		y, _ := strconv.parse_int(numbers[i+1], 10)

		diff := y-x
		if abs(diff) == 0 || abs(diff) > 3 {
			return false
		}

		if   diff <= 0 do decreasing = true
		else           do increasing = true

		if decreasing && increasing do return false

	}
	return true
}

is_safe_part1 :: proc(numbers: []string) -> bool {
	x, _ := strconv.parse_int(numbers[0], 10)
	y, _ := strconv.parse_int(numbers[1], 10)
	sign_should_be := sign_of(y-x)
	if abs(y-x) == 0 || abs(y-x) > 3 {
		return false
	}

	for i in 1..<len(numbers)-1 {
		x, _ = strconv.parse_int(numbers[i]  , 10)
		y, _ = strconv.parse_int(numbers[i+1], 10)

		diff := y-x

		if abs(diff) == 0 || abs(diff) > 3 {
			return false
		}

		if sign_of(diff) != sign_should_be {
			return false
		}
	}

	return true
}

main :: proc() {
	input, ok := os.read_entire_file("./input.txt", context.temp_allocator)
	assert(ok)

	// parsing
	t := time.tick_now()
	total := part1(input)
	duration := time.tick_lap_time(&t)
	fmt.println("Total =", total)
	fmt.println("duration =", duration)

	total = part2(input)
	duration = time.tick_lap_time(&t)
	fmt.println("Total =", total)
	fmt.println("duration =", duration)

}
part2 :: proc(input: []byte) -> (total: int) {
	input := input
	for {
		n := bytes.index_byte(input, '\n')
		if n == -1 do break // End of file

		numbers := strings.split(string(input[:n]), " ", context.temp_allocator)
		if is_safe_part2(numbers) do total += 1
		input = input[n+1:]
	}
	return
}

part1 :: proc(input: []byte) -> (total: int) {
	input := input
	for {
		n := bytes.index_byte(input, '\n')
		if n == -1 do break // End of file

		numbers := strings.split(string(input[:n]), " ", context.temp_allocator)
		if is_safe_part1(numbers) do total += 1
		input = input[n+1:]
	}
	return
}
