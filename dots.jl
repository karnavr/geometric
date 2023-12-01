using Plots
using LinearAlgebra

# Parameters
N = 80  # Number of dots
width, height = 1920, 1080  # Size of the frame
speed = 3.0  # Constant speed of the dots
proximity_threshold = 100  # Distance threshold for drawing lines

frames = 1000

# Initialize the positions and velocities of the dots
positions = [rand(2) .* [width, height] for _ in 1:N]
velocities = [speed * (rand(2) .- 0.5) for _ in 1:N]
# velocities = [speed * (ones(2)) for _ in 1:N]

# Function to update positions and handle wall collisions
# Update positions in the plot
function update_plot!(plot)
    # Update dot positions
    scatter!(plot, [p[1] for p in positions], [p[2] for p in positions], xlim=(0,width), ylim=(0,height),
             markersize=5, legend=false, axis=false, grid=false, framestyle=:none, size=(width, height))
    # Update proximity lines
    draw_lines(plot)
end

# Function to check proximity and draw lines
function draw_lines(plot)
    for i in 1:N
        for j in i+1:N
            if norm(positions[i] - positions[j]) < proximity_threshold
                plot = plot!([positions[i][1], positions[j][1]], [positions[i][2], positions[j][2]], color=:white, legend = false, lw = 7)
            end
        end
    end
    return plot
end

# Create the animation
anim = @animate for t in 1:frames  # Number of frames
    plot = scatter([p[1] for p in positions], [p[2] for p in positions], xlim=(0,width), ylim=(0,height), markersize=12, legend=false, axis=false, grid=false, framestyle=:none, size=(width, height), color = :white, background_color = :black)
    # plot = plot!([0, width, width, 0, 0], [0, 0, height, height, 0], linecolor=:black, linewidth=12)

    plot = draw_lines(plot)
    update_positions!()
    println("$(t) / $(frames) computed")
end

# Save the animation
@time gif(anim, "dots_animation.gif", fps = 30)
