from setuptools import Extension, setup
from Cython.Build import cythonize

SOURCES = [
    'bindings/libmapvxl.pyx',
]

# define the setuptools extension
extension = Extension('libmapvxl', SOURCES)

setup(
    ext_modules = cythonize([extension]),
)
