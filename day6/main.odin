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

	info, err := os.stat(file_name, context.temp_allocator)
	assert(err == nil)

	columns := bytes.index_byte(input, '\n')
	assert(columns > -1)
	rows    := int(info.size) / (columns+1)

	UP    := -columns // columns is the size of the row
	RIGHT := +1
	DOWN  := +columns
	LEFT  := -1
	directions := [4]int{UP, RIGHT, DOWN, LEFT}

	line: int
	guard: int
	iterations := rows*columns
	grid := make([]int, rows*columns, context.temp_allocator)
	for i in 0..<len(input) {
		switch input[i] {
			case '\n': line += 1
			case '#' : grid[i-line] = '#'; iterations -= 1
			case '^' : grid[i-line] = '^'; iterations -= 1; guard = i-line
			case: grid[i-line] = '.'
		}
	}

	t := time.tick_now()
	res1 := part1(grid, guard, columns, rows, input, directions)
	duration := time.tick_lap_time(&t)
	fmt.println("Answer   part 1 =", res1)
	fmt.println("Duration part 1 =", duration)

	t = time.tick_now()
	res2 := part2(grid, guard, columns, rows, input, directions, iterations)
	duration = time.tick_lap_time(&t)
	fmt.println("Answer   part 2 =", res2)
	fmt.println("Duration part 2 =", duration)
}

in_bounds :: proc(guard, dir_index, rows, columns: int) -> bool {
	switch dir_index {
		case 0: return guard >= 0
		case 1: return guard % columns > 0
		case 2: return guard / columns < rows
		case 3: return guard % columns != columns-1
	}
	assert(false,"oh shit")
	return true
}

part2 :: proc(grid: []int, guard, columns, rows: int, input: []byte, directions: [4]int, iterations: int) -> (sum: int) {
	guard := guard
	start := guard
	for r := 0; r < rows; r += 1 {
		for c := 0; c < columns; c += 1 {
			idx := c + r*columns
			if grid[idx] == '#' || grid[idx] == '^' do continue
			
			grid[idx] = '#' // Pretend we put an obstacle

			dir_index := 0
			dir_curr := directions[dir_index]

			guard = start

			next := guard + dir_curr
			iter := 0
			exploded: bool
			for in_bounds(next, dir_index, rows, columns) {

				if grid[next] == '#' {
					dir_index = (dir_index+1) % len(directions)
					dir_curr = directions[dir_index]
				}
				else {
					guard = guard + dir_curr
				}
				next = guard + dir_curr


				iter += 1
				if iter > iterations {
					exploded = true
					break
				}
			}
			if exploded {
				sum += 1
				grid[idx] = '0'
			} else do grid[idx] = '.'

		}
	}
	return
}

part1 :: proc(grid: []int, guard: int, columns, rows: int, input: []byte, directions: [4]int) -> int {
	visited := make(map[int]struct{}, context.temp_allocator)

	dir_index := 0

	dir_curr := directions[dir_index]
	guard := guard
	next  := guard + dir_curr
	for in_bounds(next, dir_index, rows, columns) {
		visited[guard] = struct{}{}
		if grid[next] == '#' {
			dir_index = (dir_index+1) % len(directions)
			dir_curr = directions[dir_index]
		} else {
			guard = guard + dir_curr
		}
		next = guard + dir_curr

	}
	visited[guard] = struct{}{}

	return len(visited)
}
