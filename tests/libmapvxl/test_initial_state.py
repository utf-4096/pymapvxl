from libmapvxl import VoxelMap
from unittest import TestCase

class InitialStateCheck(TestCase):
    def test_not_solid(self):
        vxl = VoxelMap()
        self.assertFalse(vxl.is_solid((1, 2, 3)))

    def test_top_block(self):
        vxl = VoxelMap(512, 512, 64)
        self.assertEqual(vxl.get_top_block((0, 0)), 0)
