package sorting

import "core:fmt"
import "core:math/rand"

import rl "vendor:raylib"

SIZE : i32 : 120
DARKEST_GREY : rl.Color = {50, 50, 50, 255}

sort_state :: enum{
    INIT,
    SORTING,
    SORTED,
}

populate_array :: proc(bars : ^[SIZE]i32){
    // populate array linearly, values will be 1 to length of array. No repeating numbers
    for i in 0..<len(bars){
        bars[i] = i32(i + 1)
    }
}

populate_random :: proc(bars : ^[SIZE]i32){
    // populate array randomly with values starting at 1 to length of array. Numbers can repeat
    for i in 0..<len(bars){
        a : i32 = i32(rand.float32() * f32(len(bars)))
        bars[i] = a
    }
}

shuffle :: proc(bars : ^[SIZE]i32) {
    // for 2x the length of the array, choose 2 random indexes and swap them
    for i in 0..=len(bars) * 2 {
        a : int = int(rand.float32() * f32(len(bars)))
        b : int = int(rand.float32() * f32(len(bars)))
        swap := bars[a]
        bars[a] = bars[b]
        bars[b] = swap
    }
}

bubble_sort_step :: proc(bars : ^[SIZE]i32, i : ^int, final_index : ^int) {
    if bars[i^] > bars[i^ + 1]{
        swap := bars[i^]
        bars[i^] = bars[i^ + 1]
        bars[i^ + 1] = swap
    }
    i^ += 1
    if i^ == final_index^ {
        i^ = 0
        final_index^ -= 1
    }
}

main :: proc() {
    
    WIDTH   :: 800
    HEIGHT  :: 600
    FPS     :: 60
    TITLE : cstring : "Basic Bubble Sorting"
    
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(FPS)

    state : sort_state = .INIT

    bars : [SIZE]i32
    
    populate_array(&bars)
    shuffle(&bars)

    current_index : int = 0
    final_index : int = len(bars) - 1

    text : cstring = "Press X to start sorting."
    text_color : rl.Color = DARKEST_GREY

    sort_speed := 3

    for !rl.WindowShouldClose() {
        x : i32 = 100

        if rl.IsKeyPressed(rl.KeyboardKey(.X)) {
            state = .SORTING
            text = "Sorting..."
            text_color = rl.ORANGE
        }

        if rl.IsKeyPressed(rl.KeyboardKey(93)) && state == .SORTING {
            sort_speed += 1
            if sort_speed > 10{
                sort_speed = 10
            }
        }

        if rl.IsKeyPressed(rl.KeyboardKey(91)) && state == .SORTING {
            sort_speed -= 1
            if sort_speed < 1{
                sort_speed = 1
            }
        }

        if rl.IsKeyPressed(rl.KeyboardKey(.R)) && state == .INIT {
            populate_random(&bars)
        }
        if rl.IsKeyPressed(rl.KeyboardKey(.S)) && state == .INIT {
            shuffle(&bars)
        }

        if rl.IsKeyPressed(rl.KeyboardKey(.Q)) && state == .SORTED{
            current_index = 0
            final_index = len(bars) - 1
            text = "Press X to start sorting."
            text_color = DARKEST_GREY
            populate_array(&bars)
            shuffle(&bars)
            state = .INIT
        }

        if final_index == 0 {
            state = .SORTED
            text = "Done sorting"
            text_color = rl.DARKGREEN
        }

        if state == .SORTING{
            for i in 0..<sort_speed {
                bubble_sort_step(&bars, &current_index, &final_index)
            }
        }
        
        rl.BeginDrawing()
        
            rl.ClearBackground(rl.BLACK)

            for i in 0..<len(bars){
                
                rl.DrawRectangle(x, 400 - bars[i] * 2, 3, bars[i] * 2, rl.PURPLE)
                x += 5
            }

            rl.DrawText(text, 100, 450, 30, text_color)

            if state == .INIT {
                rl.DrawText("R to randomize array values", 100, 500, 20, DARKEST_GREY)
                rl.DrawText("S to shuffle current values", 100, 530, 20, DARKEST_GREY)
            }

            if state == .SORTING{
                rl.DrawText("] to sort faster", 100, 500, 20, DARKEST_GREY)
                rl.DrawText("[ to sort slower", 100, 530, 20, DARKEST_GREY)
            }

            if state == .SORTED {
                rl.DrawText("press Q to reset", 100, 500, 20, DARKEST_GREY)
            }
            
        rl.EndDrawing()
    }

    rl.CloseWindow()
}