bl_info = {
    "name": "Seoras PSX Mesh (.pxm)",
    "author": "Seoras Macdonald",
    "version": (0, 1, 0),
    "blender": (2, 80, 0),
    "location": "File > Import-Export > PSX Mesh (.pxm) ",
    "description": "Import-Export PSX Mesh",
    "warning": "",
    "category": "Import-Export",
}

if "bpy" in locals():
    import importlib
    if "export_pxm" in locals():
        importlib.reload(export_pxm)
else:
    import bpy

from bpy.props import StringProperty, BoolProperty
from bpy_extras.io_utils import ExportHelper

class PxmExporter(bpy.types.Operator, ExportHelper):
    """Save Raw triangle mesh data"""
    bl_idname = "export_mesh.pxm"
    bl_label = "Export PXM"

    filename_ext = ".pxm"
    filter_glob: StringProperty(default="*.pxm", options={'HIDDEN'})

    def execute(self, context):
        from . import export_pxm
        export_pxm.write(self.filepath)

        return {'FINISHED'}

def menu_export(self, context):
    self.layout.operator(PxmExporter.bl_idname, text="PXS Mesh (.pxm)")

def register():
    bpy.utils.register_class(PxmExporter)

    bpy.types.TOPBAR_MT_file_export.append(menu_export)


def unregister():
    bpy.utils.unregister_class(PxmExporter)

    bpy.types.TOPBAR_MT_file_export.remove(menu_export)

if __name__ == "__main__":
    register()
