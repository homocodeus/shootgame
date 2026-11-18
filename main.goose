import std;
import math;
import vec;
import gfx;
import ui;

struct Body { x: f32, y: f32, active: bool }
fn main() {
    guard gfx::open("STAR GUARD / Goose", 960, 720) else { abort(gfx::error()); }
    defer gfx::close();
    let canvas = ui::create(20.0);
    defer ui::destroy(canvas);
    var style = ui::style(canvas);
    style.window.fixed_background = ui::style_item_hide();
    ui::set_style(canvas, style);
    var bullets: Body[64];
    var enemies: Body[32];
    var x: f32 = 480.0;
    var health = 3;
    var score = 0;
    var tick: f32 = 0.0;
    var cooldown: f32 = 0.0;
    var spawn: f32 = 0.0;
    var serial = 0;
    var paused = false;
    let cyan = ui::Color { 55, 230, 255, 255 };
    let pink = ui::Color { 255, 75, 125, 255 };
    let white = ui::Color { 220, 235, 255, 255 };
    let clear = ui::Color { 0, 0, 0, 0 };
    while gfx::frame() {
        if gfx::key_pressed("Escape") { break; }
        if gfx::key_pressed("P") { paused = !paused; }
        if gfx::key_pressed("R") {
            health = 3; score = 0; serial = 0; spawn = 0.0; x = 480.0; paused = false;
            for i in 64 { bullets[i].active = false; }
            for i in 32 { enemies[i].active = false; }
        }
        let dt = min(gfx::delta_time() as f32, 0.05);
        if health > 0 && !paused {
            tick += dt; cooldown -= dt; spawn -= dt;
            if gfx::key_down("A") || gfx::key_down("Left") { x -= 420.0 * dt; }
            if gfx::key_down("D") || gfx::key_down("Right") { x += 420.0 * dt; }
            x = max(32.0, min(928.0, x));
            if gfx::key_down("Space") && cooldown <= 0.0 {
                for i in 64 { if !bullets[i].active {
                    bullets[i] = Body { x, 620.0, true }; cooldown = 0.14; break;
                } }
            }
            if spawn <= 0.0 {
                for i in 32 { if !enemies[i].active {
                    enemies[i] = Body { 45.0 + ((serial * 137) % 870) as f32, 85.0, true };
                    serial++; spawn = max(0.16, 0.8 - score as f32 * 0.003); break;
                } }
            }
            for i in 64 { if bullets[i].active {
                bullets[i].y -= 680.0 * dt;
                if bullets[i].y < 75.0 { bullets[i].active = false; }
            } }
            for j in 32 { if enemies[j].active {
                enemies[j].y += (100.0 + score as f32 * 0.7) * dt;
                for i in 64 { if bullets[i].active && enemies[j].active {
                    if abs(bullets[i].x - enemies[j].x) < 25.0 && abs(bullets[i].y - enemies[j].y) < 22.0 {
                        bullets[i].active = false; enemies[j].active = false; score += 10;
                    }
                } }
                if enemies[j].active && enemies[j].y > 610.0 {
                    enemies[j].active = false; health -= 1;
                    if health <= 0 { break; }
                }
            } }
        }
        ui::input_from_gfx(canvas);
        if ui::begin(canvas, "Arena", ui::rect(0, 0, 960, 720), ui::WINDOW_NO_INPUT | ui::WINDOW_NO_SCROLLBAR) {
            for i in 75 {
                let sx = ((i * 193) % 940 + 10) as f32;
                let sy = 85.0 + (((i * 71) % 550) as f32 + tick * 25.0) % 550.0;
                ui::fill_rect(canvas, ui::rect(sx, sy, 2.0, 2.0), 0.0, ui::Color { 70, 100, 145, 255 });
            }
            ui::draw_text(canvas, ui::rect(28, 20, 900, 32), str("STAR GUARD     /     SCORE ", score, "     /     SHIELDS ", health), ui::font(canvas), clear, cyan);
            for i in 64 { if bullets[i].active { ui::fill_rect(canvas, ui::rect(bullets[i].x - 3.0, bullets[i].y, 6.0, 20.0), 3.0, cyan); } }
            for i in 32 { if enemies[i].active {
                ui::fill_rect(canvas, ui::rect(enemies[i].x - 22.0, enemies[i].y - 15.0, 44.0, 30.0), 8.0, pink);
                ui::fill_rect(canvas, ui::rect(enemies[i].x - 12.0, enemies[i].y - 4.0, 24.0, 6.0), 0.0, white);
            } }
            ui::fill_rect(canvas, ui::rect(x - 23.0, 630.0, 46.0, 18.0), 4.0, cyan);
            ui::fill_rect(canvas, ui::rect(x - 7.0, 612.0, 14.0, 34.0), 4.0, white);
            ui::draw_text(canvas, ui::rect(28, 675, 910, 28), "A/D or ARROWS move   SPACE fire   P pause   R restart   ESC quit", ui::font(canvas), clear, white);
            if health <= 0 || paused {
                ui::fill_rect(canvas, ui::rect(220, 290, 520, 105), 12.0, ui::Color { 15, 25, 48, 245 });
                ui::draw_text(canvas, ui::rect(255, 325, 470, 35), if health <= 0 { "MISSION OVER  /  Press R to restart" } else { "PAUSED  /  Press P to resume" }, ui::font(canvas), clear, white);
            }
        }
        ui::end(canvas);
        gfx::begin_screen(float4 { 0.025, 0.04, 0.08, 1.0 });
        gfx::end_pass();
        ui::render(canvas);
    }
}
