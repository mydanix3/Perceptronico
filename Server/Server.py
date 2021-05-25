#!/usr/bin/env python
# coding: utf-8

# In[ ]:


from pydrive.auth import GoogleAuth
from pydrive.drive import GoogleDrive

gauth = GoogleAuth()           
drive = GoogleDrive(gauth)

import socket
import cv2
import pickle
import struct

FILENAME = 'rebuda.jpg'

HOST = '127.0.0.1'  # Standard loopback interface address (localhost)
PORT = 1432

contador = 0

print("Executant")

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, PORT))
    s.listen()
    conn, addr = s.accept()
    
    
    
    with conn:
        print('Connected by', addr)

        while True:
            
            contador = contador + 1
            
            data = conn.recv(1024)
            #if not data:
            #    break
            
            
            if contador != 300:
                
                conn.sendall(b'0')
                
                continue
                
                
            contador = 0

            file_list = drive.ListFile({'q': "'1OHx22pccBYMK7TF_jeU0-KDboUY6exMT' in parents and trashed=false"}).GetList()

            if len(file_list) != 0:

                conn.sendall(b'1')
                for i, file1 in enumerate(sorted(file_list, key = lambda x: x['title']), start=1):
                    file1.GetContentFile(file1['title'])
                    file1.Delete()

                    with open(file1['title'], 'r') as coords_file:

                        for line in coords_file:

                            for coord in line.split():

                                conn.sendall(bytes(str(coord), encoding='utf8'))



                #conn.sendall(b'1.57')
                print("posicions enviades")

                data = b""
                payload_size = struct.calcsize(">L")

                while len(data) < payload_size:
                    data += conn.recv(4096)

                print("done recieving payload 1")

                packed_msg_size = data[:payload_size]
                data = data[payload_size:]
                msg_size = struct.unpack(">L", packed_msg_size)[0]

                while len(data) < msg_size:
                    data += conn.recv(4096)

                frame_data = data[:msg_size]
                data = data[msg_size:]

                print("Imatge rebuda")

                frame=pickle.loads(frame_data, fix_imports=True, encoding="bytes")
                frame = cv2.imdecode(frame, cv2.IMREAD_COLOR)
                cv2.imwrite(FILENAME, frame)


                gfile = drive.CreateFile({'parents': [{'id': '14HYrCCthhDEGo3z5Dexba_qpzn9tta3B'}]})
                # Read file and set it as the content of this instance.
                gfile.SetContentFile(FILENAME)
                gfile.Upload() # Upload the file.

                print("Imatge guardada")
                
            else:
            
                conn.sendall(b'0')
                    
             

