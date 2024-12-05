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
	
	n := bytes.index_byte(input, '\n') + 1

	t := time.tick_now()
	count := part1(input, n)
	duration := time.tick_lap_time(&t)
	fmt.println("Part1:")
	fmt.println("Count =", count)
	fmt.println("Duration =", duration)

	t = time.tick_now()
	count = part2(input, n)
	duration = time.tick_lap_time(&t)
	fmt.println("Part2:")
	fmt.println("Count =", count)
	fmt.println("Duration =", duration)

}

part2 :: proc(input: []byte, n: int) -> (count: int) {
	i: int
	for i < len(input) {
		if input[i] == 'M' {
			if i + 2*n + 2 < len(input) && input[i+n+1] == 'A' && input[i+2*n+2] == 'S' {
				if input[i + 2] == 'M' {
					j := i + 2
					if input[j + n -1] == 'A' && input[j + 2*n -2] == 'S' do count += 1

				} else if input[i + 2] == 'S' {
					j := i + 2
					if input[j + n -1] == 'A' && input[j + 2*n -2] == 'M' do count += 1
				}
			}
		} else if input[i] == 'S' {
			if i + 2*n + 2 < len(input) && input[i+n+1] == 'A' && input[i+2*n+2] == 'M' {
				if input[i + 2] == 'M' {
					j := i + 2
					if input[j + n -1] == 'A' && input[j + 2*n -2] == 'S' do count += 1

				} else if input[i + 2] == 'S' {
					j := i + 2
					if input[j + n -1] == 'A' && input[j + 2*n -2] == 'M' do count += 1
				}
			}
		}
		i += 1
	}
	return
}

part1 :: proc(input: []byte, n: int) -> (count: int) {
	i: int
	for i < len(input) {
		if input[i] == 'X' {

			if i + 3 < len(input) && input[i+1] == 'M' && input[i+2] == 'A' && input[i+3]  == 'S' do count += 1

			if i + 3*n < len(input) && input[i+n]   == 'M' && input[i+2*n]   == 'A' && input[i+3*n]   == 'S' do count += 1 // baixo

			if i + 3 * n + 3 < len(input) && input[i+n+1] == 'M' && input[i+2*n+2] == 'A' && input[i+3*n+3] == 'S' do count += 1 // diagonal baixo e direita

			if i + 3 * n - 3 < len(input) && input[i+n-1] == 'M' && input[i+2*n-2] == 'A' && input[i+3*n-3] == 'S' do count += 1 // diagonal baixo e esquerda

		} else if input[i] == 'S' {
			if i + 3 < len(input) && input[i+1] == 'A' && input[i+2] == 'M' && input[i+3]  == 'X' do count += 1

			if i + 3*n < len(input) && input[i+n]   == 'A' && input[i+2*n]   == 'M' && input[i+3*n]   == 'X' do count += 1 // baixo

			if i + 3 * n + 3 < len(input) && input[i+n+1] == 'A' && input[i+2*n+2] == 'M' && input[i+3*n+3] == 'X' do count += 1 // diagonal baixo e direita

			if i + 3 * n - 3 < len(input) && input[i+n-1] == 'A' && input[i+2*n-2] == 'M' && input[i+3*n-3] == 'X' do count += 1 // diagonal baixo e esquerda
		}
		
		i += 1
	}
	return
}
