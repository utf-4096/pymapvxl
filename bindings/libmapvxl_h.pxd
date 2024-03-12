from libc.stdint cimport uint8_t, uint16_t, uint32_t

cdef extern from '../extern/libmapvxl/libmapvxl.c':
    ctypedef struct mapvxl_t:
        uint16_t size_x
        uint16_t size_y
        uint16_t size_z

    void mapvxl_create(mapvxl_t* map, uint16_t size_x, uint16_t size_y, uint16_t size_z)
    void mapvxl_free(mapvxl_t* map)
    void mapvxl_read(mapvxl_t* map, uint8_t* src)
    size_t mapvxl_write(mapvxl_t* map, uint8_t* out)
    uint8_t mapvxl_find_top_block(mapvxl_t* map, uint16_t x, uint16_t y)
    void mapvxl_set_color(mapvxl_t* map, uint16_t x, uint16_t y, uint16_t z, uint32_t c)
    uint32_t mapvxl_get_color(mapvxl_t* map, uint16_t x, uint16_t y, uint16_t z)
    void mapvxl_set_air(mapvxl_t* map, uint16_t x, uint16_t y, uint16_t z)
    int mapvxl_is_surface(mapvxl_t* map, uint16_t x, uint16_t y, uint16_t z)
    int mapvxl_is_solid(mapvxl_t* map, uint16_t x, uint16_t y, uint16_t z)
