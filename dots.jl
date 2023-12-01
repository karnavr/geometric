using Plots
using LinearAlgebra

# Parameters
N = 30  # Number of dots
width, height = 1200, 800  # Size of the frame
speed = 2.0  # Constant speed of the dots
proximity_threshold = 50  # Distance threshold for drawing lines

# Initialize the positions and velocities of the dots
positions = [rand(2) .* [width, height] for _ in 1:N]
velocities = [speed * (rand(2) .- 0.5) for _ in 1:N]

# Function to update positions and handle wall collisions
function update_positions!()
    for i in 1:N
        positions[i] += velocities[i]
        for j in 1:2
            if positions[i][j] < 0 || positions[i][j] > [width, height][j]
                velocities[i][j] *= -1
                positions[i][j] = max(0, min(positions[i][j], [width, height][j]))
            end
        end
    end
end

# Function to check proximity and draw lines
function draw_lines(plot)
    for i in 1:N
        for j in i+1:N
            if norm(positions[i] - positions[j]) < proximity_threshold
                plot = plot!([positions[i][1], positions[j][1]], [positions[i][2], positions[j][2]], color=:blue)
            end
        end
    end
    return plot
end

# Create the animation
anim = @animate for t in 1:1000  # Number of frames
    plot = scatter([p[1] for p in positions], [p[2] for p in positions], xlim=(0,width), ylim=(0,height), markersize=5)
    plot = draw_lines(plot)
    update_positions!()
end

# Save the animation
gif(anim, "dots_animation.gif", fps = 15)
