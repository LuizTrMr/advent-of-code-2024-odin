package main

import "core:time"
import "core:fmt"
import "core:os"
import "core:bytes"
import "core:strings"
import "core:strconv"

main :: proc() {
	input, ok := os.read_entire_file("./input.txt", context.temp_allocator)
	assert(ok)

	input1 := bytes.clone(input, context.temp_allocator)
	t := time.tick_now()
	res1 := part1(input1)
	duration := time.tick_lap_time(&t)
	fmt.println("res1 =", res1)
	fmt.println("duration =", duration)

	input2 := bytes.clone(input, context.temp_allocator)
	t = time.tick_now()
	res2 := part2(input2)
	duration = time.tick_lap_time(&t)
	fmt.println("res2 =", res2)
	fmt.println("duration =", duration)

}
part2 :: proc(input: []byte) -> (sum:int) {
	input := input
	DONT :: "don't()"
	for {
		dont := strings.index(string(input), DONT)
		if dont == -1 {
			sum += part1(input[:])
			break
		} else {
			sum += part1(input[:dont])
			input = input[dont+len(DONT):]
			_do := strings.index(string(input), "do()")
			if _do == -1 do break
			input = input[_do+4:]
		}
	}
	return
}

part1 :: proc(input: []byte) -> (sum:int) {
	input := input
	for {
		mul := strings.index(string(input), "mul(")
		if mul == -1 do break

		input = input[mul+4:]

		comma := strings.index_byte(string(input), ',')
		if comma == -1 do break
		if !(1 <= comma && comma <= 3) do continue

		num1, ok1 := strconv.parse_int(string(input[:comma]), 10)

		input = input[comma+1:]

		paren := strings.index_byte(string(input), ')')
		if paren == -1 do break
		if !(1 <= paren && paren <= 3) do continue

		num2, ok2 := strconv.parse_int(string(input[:paren]), 10)

		if ok1 && ok2 do sum += num1 * num2

		input = input[paren:]
	}
	return
}
