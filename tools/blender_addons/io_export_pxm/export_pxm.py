import bpy
import struct

def faceValues(face, mesh, matrix):
    fv = []
    for verti in face.vertices:
        fv.append((matrix @ mesh.vertices[verti].co)[:])
    return fv

def hex2(n):
    return hex (n & 0xffff)

def to_16uint(v):
    return int(v[0] * 0x100)

def faceToLine(face):
    return b''.join([struct.pack('<H', to_16uint(v) & 0xffff) for v in face])

def write(filepath,):
    scene = bpy.context.scene

    faces = []
    for obj in bpy.context.selected_objects:
        me = obj.data

        if me is not None:
            matrix = obj.matrix_world.copy()
            for face in me.polygons:
                fv = faceValues(face, me, matrix)
                faces.append(fv)

    # write the faces to a file
    file = open(filepath, "bw")
    for face in faces:
        file.write(faceToLine(face))
    file.close()
