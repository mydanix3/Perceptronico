"""perceptronico_controller controller."""

HOST = '127.0.0.1'  # The server's hostname or IP address
PORT = 1432
FILENAME = 'enviada.jpg'

# You may need to import some classes of the controller module. Ex:
#  from controller import Robot, Motor, DistanceSensor
from controller import Robot
from controller import Camera
from controller import Motor

import socket
import pickle
import struct
import cv2
import time

pos_angle = 0.2
pos_increment = 0.02
velocity = 5
# create the Robot instance.
robot = Robot()
camera = Camera("camera")

motor_0 = robot.getDevice('motor_base')
motor_1 = robot.getDevice('motor_brazo_1')
motor_2 = robot.getDevice('motor_brazo_2')


rtd = robot.getDevice('rtd')
rte = robot.getDevice('rte')
eix = robot.getDevice('eix')

timestep = int(robot.getBasicTimeStep())
camera.enable(timestep)




l_ir = robot.getDevice('ir1')
l_ir.enable(timestep)

r_ir = robot.getDevice('ir0')
r_ir.enable(timestep)

rte.setPosition(float('inf'))
rtd.setPosition(float('inf'))

angle_pos = pos_angle
angle_neg = -pos_angle
positive = False


with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
   s.connect((HOST, PORT))
   connection = s.makefile("wb")

   

   while robot.step(timestep) != -1:
       
       #######--------------LINE TRACKER-----------------------------
       l_ir_val = l_ir.getValue()
       r_ir_val = r_ir.getValue()
       if(l_ir_val > r_ir_val) and (75 < l_ir_val < 157):        
           eix.setPosition(angle_pos)
           angle_pos = angle_pos + pos_increment
           angle_neg = -pos_angle
           positive = True
            
       elif(r_ir_val > l_ir_val) and (75< r_ir_val < 157):
           eix.setPosition(angle_neg)
           angle_neg = angle_neg - pos_increment
           angle_pos = pos_angle
           positive = False
            
       else:
           angle_pos = pos_angle
           angle_neg = -pos_angle
            
           if positive:
               eix.setPosition(angle_pos)
           else:
               eix.setPosition(angle_neg)
        
       rte.setVelocity(velocity)
       rtd.setVelocity(velocity)
        
        
  
       #######----------------SERVER------------------------------
       s.sendall(b'a')
       
       param = float(s.recv(1024))
       
       #print(param)
       
       if param == 1:
       
           rte.setVelocity(0)
           rtd.setVelocity(0)
           
           first_motor_angle = s.recv(1024)

           second_motor_angle = s.recv(1024)

           print("Posició motor rebuda")
    # #
           print(float(first_motor_angle))
           print(float(second_motor_angle))
           
           motor_0.setPosition(float(first_motor_angle))
           motor_1.setPosition(float(second_motor_angle))
           motor_2.setPosition(-float(second_motor_angle))
           print("movent robot")
           
           
           i=0
           
           while robot.step(timestep) != -1:
               i = i + 1
               if i==275:
                   break
                  
           
           camera.saveImage(FILENAME, 100)
           img = cv2.imread(FILENAME)
           print("Guardant imatge")
        
           result, frame = cv2.imencode('.jpg', img, [int(cv2.IMWRITE_JPEG_QUALITY), 80])
           data = pickle.dumps(frame, 0)
           size = len(data)
           s.sendall(struct.pack(">L", size) + data)
    # #
           print("Enviant imatge")
           
           rte.setVelocity(velocity)
           rtd.setVelocity(velocity)
# #
   

"""prueba controller."""

# You may need to import some classes of the controller module. Ex:
#  from controller import Robot, Motor, DistanceSensor
