import bpy
import struct

# FORMAT
# U32: face count, U16: x0, U16: y0, U16: z0, U16: blank, U16: x1, ...

def faceValues(face, mesh, matrix):
    fv = []
    for verti in face.vertices:
        fv.append((matrix @ mesh.vertices[verti].co)[:])
    return fv

def hex2(n):
    return hex (n & 0xffff)

def to_16uint(v):
    return int(v * 0x100) & 0xffff

def faceToLine(face):
    return b''.join([struct.pack('<HHHH', to_16uint(v[1]), to_16uint(v[0]), to_16uint(v[2]), 0) for v in face])

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
    file.write(struct.pack('<I', len(faces)))
    for face in faces:
        file.write(faceToLine(face))
    file.close()
