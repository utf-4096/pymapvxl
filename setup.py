from setuptools import Extension, setup
from Cython.Build import cythonize

SOURCES = [
    'bindings/libmapvxl.pyx',
]

# define the setuptools extension
extension = Extension('libmapvxl', SOURCES)

setup(
    name='pymapvxl',
    version='0.1.0',
    description='Python wrapper for libmapvxl',
    author='utf',
    ext_modules = cythonize([extension]),
)
