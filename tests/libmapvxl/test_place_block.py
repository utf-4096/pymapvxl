from libmapvxl import VoxelMap
from unittest import TestCase

class PlaceBlockCheck(TestCase):
    def test_solid(self):
        vxl = VoxelMap()
        vxl.place(1, 2, 3)
        self.assertTrue(vxl.is_solid(1, 2, 3))

    def test_place_and_destroy_not_solid(self):
        vxl = VoxelMap()
        vxl.place(1, 2, 3)
        vxl.remove(1, 2, 3)
        self.assertFalse(vxl.is_solid(1, 2, 3))

    def test_top_block(self):
        vxl = VoxelMap()
        vxl.place(0, 0, 32)
        self.assertEqual(vxl.get_top_block(0, 0), 32)

    def test_color(self):
        vxl = VoxelMap()
        vxl.place(1, 0, 0, 0xFF0000)
        vxl.place(0, 1, 0, 0x00FF00)
        vxl.place(0, 0, 1, 0x0000FF)

        self.assertEqual(vxl.get_color(1, 0, 0), 0xFF0000)
        self.assertEqual(vxl.get_color(0, 1, 0), 0x00FF00)
        self.assertEqual(vxl.get_color(0, 0, 1), 0x0000FF)
