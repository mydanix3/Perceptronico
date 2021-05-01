"""perceptronico_controller controller."""

# You may need to import some classes of the controller module. Ex:
#  from controller import Robot, Motor, DistanceSensor
from controller import Robot
from controller import Camera

# create the Robot instance.
robot = Robot()
camera = Camera("camera")



# get the time step of the current world.
timestep = int(robot.getBasicTimeStep())
camera.enable(timestep)

# You should insert a getDevice-like function in order to get the
# instance of a device of the robot. Something like:

motor_1 = robot.getDevice('motor_brazo_1')
motor_2 = robot.getDevice('motor_brazo_2')
#  ds = robot.getDistanceSensor('dsname')
#  ds.enable(timestep)

# Main loop:
# - perform simulation steps until Webots is stopping the controller
while robot.step(timestep) != -1:
    # Read the sensors:
    # Enter here functions to read sensor data, like:
    #  val = ds.getValue()

    # Process sensor data here.

    # Enter here functions to send actuator commands, like:
    #  motor.setPosition(10.0)
    motor_1.setPosition(5)
    motor_2.setPosition(5)
    #pass

# Enter here exit cleanup code.
