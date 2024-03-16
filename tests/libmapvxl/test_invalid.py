from libmapvxl import VoxelMap, InvalidPositionException
from unittest import TestCase

class InvalidCheck(TestCase):
    def test_overflow(self):
        vxl = VoxelMap(512, 512, 64)
        self.assertRaises(InvalidPositionException,
                          vxl.place,
                          512, 0, 0)
