use std::error::Error;
use std::fs;

fn main() -> Result<(), Box<dyn Error>> {
    let content = fs::read_to_string("input.txt")?;

    let mut points: Vec<(i64, i64)> = Vec::new();

    for line in content.lines() {
        if line.trim().is_empty() {
            continue;
        }

        let parts: Vec<&str> = line.split(',').collect();
        if parts.len() < 2 {
            continue;
        }

        let x: i64 = parts[0].trim().parse()?;
        let y: i64 = parts[1].trim().parse()?;
        points.push((x, y));
    }

    if points.is_empty() {
        println!("No valid points found.");
        return Ok(());
    }

    let mut max_area_p1: i64 = 0;
    let mut max_area_p2: i64 = 0;
    let n = points.len();

    for i in 0..n {
        for j in i + 1..n {
            let (x1, y1) = points[i];
            let (x2, y2) = points[j];

            let width = (x2 - x1).abs() + 1;
            let height = (y2 - y1).abs() + 1;
            let area = width * height;

            if area > max_area_p1 {
                max_area_p1 = area;
            }

            if area > max_area_p2 {
                let rect_x_min = x1.min(x2);
                let rect_x_max = x1.max(x2);
                let rect_y_min = y1.min(y2);
                let rect_y_max = y1.max(y2);

                if is_valid_rectangle(rect_x_min, rect_x_max, rect_y_min, rect_y_max, &points) {
                    max_area_p2 = area;
                }
            }
        }
    }

    println!("Part 1: {}", max_area_p1);
    println!("Part 2: {}", max_area_p2);

    Ok(())
}

// checking if the area is inside the polygon
fn is_valid_rectangle(
    r_xmin: i64, r_xmax: i64,
    r_ymin: i64, r_ymax: i64,
    poly: &Vec<(i64, i64)>
) -> bool {
    let n = poly.len();

    // checking if an edge intersect the inside the rectangle
    for k in 0..n {
        let p1 = poly[k];
        let p2 = poly[(k + 1) % n];

        if p1.0 == p2.0 {
            // vertical
            let edge_x = p1.0;
            let edge_ymin = p1.1.min(p2.1);
            let edge_ymax = p1.1.max(p2.1);

            if edge_x > r_xmin && edge_x < r_xmax {
                let overlap_min = r_ymin.max(edge_ymin);
                let overlap_max = r_ymax.min(edge_ymax);
                if overlap_min < overlap_max {
                    return false;
                }
            }
        } else {
			// horizontal
            let edge_y = p1.1;
            let edge_xmin = p1.0.min(p2.0);
            let edge_xmax = p1.0.max(p2.0);

            if edge_y > r_ymin && edge_y < r_ymax {
                let overlap_min = r_xmin.max(edge_xmin);
                let overlap_max = r_xmax.min(edge_xmax);
                if overlap_min < overlap_max {
                    return false;
                }
            }
        }
    }

    let test_x = (r_xmin as f64 + r_xmax as f64) / 2.0;
    let test_y = (r_ymin as f64 + r_ymax as f64) / 2.0;

    // Ray Casting Algorithm (i'll be honest i didn't know about this, thanks gemini)
    let mut intersections = 0;
    for k in 0..n {
        let p1 = poly[k];
        let p2 = poly[(k + 1) % n];

        if p1.0 == p2.0 {
            let edge_x = p1.0 as f64;
            let y1 = p1.1 as f64;
            let y2 = p2.1 as f64;

            if edge_x > test_x {
                let min_y = y1.min(y2);
                let max_y = y1.max(y2);
                if test_y >= min_y && test_y < max_y {
                    intersections += 1;
                }
            }
        }
    }

    intersections % 2 == 1
}
