# cython: language_level=3

from libmapvxl_h cimport *
from libc.stdlib cimport malloc, realloc

class InvalidTypeException(Exception):
    """The given type is not valid for this call"""
    pass

class InvalidPositionException(Exception):
    """The given XYZ position is invalid"""
    pass

cdef class VoxelMap:
    cdef mapvxl_t _map

    @staticmethod
    def from_file(str path):
        vxl = VoxelMap()
        with open(path, 'rb') as f:
            vxl.load(f.read())
        return vxl

    def __cinit__(self, width = 512, height = 512, depth = 64):
        """Initiate a blank libmapvxl map"""
        mapvxl_create(&self._map, width, height, depth)

    def __dealloc__(self):
        """Free the libmapvxl instance"""
        mapvxl_free(&self._map)

    cpdef void load(self, uint8_t* data):
        """Load a map from a VXL data buffer"""
        mapvxl_read(&self._map, data)

    cpdef bytes dump(self):
        """Output the map as a VXL data buffer"""
        cdef size_t size = self._map.size_x * self._map.size_y * (self._map.size_z // 2) * 8
        cdef uint8_t* data = <uint8_t*> malloc(sizeof(uint8_t) * size)
        size = mapvxl_write(&self._map, data)
        data = <uint8_t*> realloc(data, size)
        return data[:size]

    cpdef void to_file(self, str path):
        """Write the map to a VXL file"""
        data = self.dump()
        with open(path, 'wb') as f:
            f.write(data)

    cdef void _check_is_valid_position(self, tuple position):
        """Check if a position is a valid XYZ position, and is not out of bounds"""
        if not isinstance(position, tuple) or \
           len(position) != 3 or \
           not isinstance(position[0], int) or \
           not isinstance(position[1], int) or \
           not isinstance(position[2], int):
            raise InvalidTypeException('expected position to be an int tuple(x, y, z)')

        x, y, z = position
        if x >= self._map.size_x or \
           y >= self._map.size_y or \
           z >= self._map.size_z or \
           x < 0 or y < 0 or z < 0:
           raise InvalidPositionException('Invalid position')

    cpdef void place(self, tuple position, uint32_t color = 0x674028):
        """Place a block with an optional color"""
        self._check_is_valid_position(position)
        if not isinstance(color, int):
            raise Exception('expected color to be an RRGGBB int')

        x, y, z = position
        mapvxl_set_color(&self._map, x, y, z, color | 0xFF000000)

    cpdef uint32_t get_color(self, tuple position):
        """Get the color of a block"""
        self._check_is_valid_position(position)

        x, y, z = position
        return mapvxl_get_color(&self._map, x, y, z) & 0x00FFFFFF

    cpdef void remove(self, tuple position):
        """Remove a block"""
        self._check_is_valid_position(position)

        x, y, z = position
        mapvxl_set_air(&self._map, x, y, z)

    cpdef bint is_solid(self, tuple position):
        """Check if a block exists"""
        self._check_is_valid_position(position)

        x, y, z = position
        return bool(mapvxl_is_solid(&self._map, x, y, z))

    cpdef bint is_surface(self, tuple position):
        """Check if there is a solid surface"""
        self._check_is_valid_position(position)

        x, y, z = position
        return bool(mapvxl_is_surface(&self._map, x, y, z))

    cpdef uint8_t get_top_block(self, tuple position):
        """Get the top block of the map at the specified (x, y) position"""
        if not isinstance(position, tuple) or \
           len(position) != 2 or \
           not isinstance(position[0], int) or \
           not isinstance(position[1], int):
            raise Exception('expected position to be an int tuple(x, y)')

        x, y = position
        return mapvxl_find_top_block(&self._map, x, y)

    @property
    def size(self):
        return (self._map.size_x, self._map.size_y, self._map.size_z)

    def __repr__(self):
        width, height, depth = self.size
        return f'VoxelMap(width={width}, height={height}, depth={depth})'
