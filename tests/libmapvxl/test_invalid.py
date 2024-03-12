from libmapvxl import VoxelMap, InvalidPositionException, InvalidTypeException
from unittest import TestCase

class InvalidCheck(TestCase):
    def test_overflow(self):
        vxl = VoxelMap(512, 512, 64)
        self.assertRaises(InvalidPositionException,
                          vxl.place,
                          (512, 0, 0))

    def test_underflow(self):
        vxl = VoxelMap(512, 512, 64)
        self.assertRaises(InvalidPositionException,
                          vxl.place,
                          (-1, 0, 0))

    def test_bad_type(self):
        vxl = VoxelMap()
        self.assertRaises(InvalidTypeException,
                          vxl.place,
                          None)

    def test_bad_size(self):
        vxl = VoxelMap()
        self.assertRaises(InvalidTypeException,
                          vxl.place,
                          (1, 1))
