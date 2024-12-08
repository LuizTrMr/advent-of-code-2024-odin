package main

import "core:time"
import "core:fmt"
import "core:os"
import "core:bytes"
import "core:strings"
import "core:strconv"
import "core:slice"


part1 :: proc(input: []byte) -> (sum: int) {
	input := input

	Op :: enum {
		add,
		mul,
	}

	for len(input) > 0 {
		idx := bytes.index_byte(input, ':')
		if idx == -1 do break
		num, num_ok := strconv.parse_int(string(input[:idx]), 10)
		assert(num_ok)

		line := bytes.index_byte(input, '\n')
		if line == -1 do break
		nums := strings.split(string(input[idx:line]), " ")
		nums = nums[1:]
		
		values := slice.mapper(nums[:],
							   proc(s: string) -> int {
								   n, ok := strconv.parse_int(s, 10)
								   assert(ok)
								   return n
							   },
							   context.temp_allocator)


		ops := make([]Op, len(values)-1, context.temp_allocator)

		for {
			total := values[0]
			for i in 1..<len(values) {
				if total > num do break

				v  := values[i]
				op := ops[i-1]
				switch op {
					case .add   : total += v
					case .mul   : total *= v
					// case .concat:
					// 	buf: [100]byte
					// 	total_s := strconv.itoa(buf[:], total)
					// 	s := strings.concatenate({total_s, nums[i]}, context.temp_allocator)
						
					// 	res, ok := strconv.parse_int(s, 10)
					// 	assert(ok)
					// 	total = res
				}
			}

			if total == num {
				sum += num
				break
			}

			i := len(ops) - 1
			for i >= 0 {
				value := cast(int)ops[i] + 1
				ops[i] = cast(Op) value

				if value < 2 do break

				zero: Op
				ops[i] = zero
				i -= 1
			}

			if i < 0 do break
		}

		input = input[line+1:]
	}
	return
}

part2 :: proc(input: []byte) -> (sum: int) {
	input := input

	Op :: enum {
		add,
		mul,
		concat,
	}

	for len(input) > 0 {
		idx := bytes.index_byte(input, ':')
		if idx == -1 do break
		num, num_ok := strconv.parse_int(string(input[:idx]), 10)
		assert(num_ok)

		line := bytes.index_byte(input, '\n')
		if line == -1 do break
		nums := strings.split(string(input[idx:line]), " ")
		nums = nums[1:]
		
		values := slice.mapper(nums[:],
							   proc(s: string) -> int {
								   n, ok := strconv.parse_int(s, 10)
								   assert(ok)
								   return n
							   },
							   context.temp_allocator)


		ops := make([]Op, len(values)-1, context.temp_allocator)

		for {
			total := values[0]
			for i in 1..<len(values) {
				if total > num do break

				v  := values[i]
				op := ops[i-1]
				switch op {
					case .add   : total += v
					case .mul   : total *= v
					case .concat:
						buf: [18]byte
						total_s := strconv.itoa(buf[:], total)
						s := strings.concatenate({total_s, nums[i]}, context.temp_allocator)
						
						res, _ := strconv.parse_int(s, 10)
						total = res
				}
			}

			if total == num {
				sum += num
				break
			}

			i := len(ops) - 1
			for i >= 0 {
				value := cast(int)ops[i] + 1
				ops[i] = cast(Op) value

				if value < 3 do break

				zero: Op
				ops[i] = zero
				i -= 1
			}

			if i < 0 do break
		}

		input = input[line+1:]
	}
	return
}

main :: proc() {
	file_name := os.args[1]
	input, ok := os.read_entire_file(file_name, context.temp_allocator)
	assert(ok)

	input1 := make([]byte, len(input), context.temp_allocator)
	copy(input1[:], input[:])
	t := time.tick_now()
	sum := part1(input1)
	duration := time.tick_lap_time(&t)
	fmt.println("Answer part 1 =", sum)
	fmt.println("Duration part 1 =", duration)

	input2 := make([]byte, len(input), context.temp_allocator)
	copy(input2[:], input[:])
	t = time.tick_now()
	sum = part2(input2)
	duration = time.tick_lap_time(&t)
	fmt.println("Answer part 2 =", sum)
	fmt.println("Duration part 2 =", duration)
}
