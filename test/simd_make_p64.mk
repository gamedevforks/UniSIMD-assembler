
INC_PATH =                              \
        -I../core/

SRC_LIST =                              \
        simd_test.cpp

LIB_PATH =

LIB_LIST =                              \
        -lm


build: simd_test_p64_32 simd_test_p64f32 simd_test_p64f64

strip:
	powerpc64le-linux-gnu-strip simd_test.p64*

clean:
	rm simd_test.p64*


simd_test_p64_32:
	powerpc64le-linux-gnu-g++ -O2 -g -static \
        -DRT_LINUX -DRT_P64 -DRT_128=2 -DRT_DEBUG=0 \
        -DRT_POINTER=64 -DRT_ADDRESS=32 -DRT_ELEMENT=32 -DRT_ENDIAN=0 \
        ${INC_PATH} ${SRC_LIST} ${LIB_PATH} ${LIB_LIST} -o simd_test.p64_32

simd_test_p64f32:
	powerpc64le-linux-gnu-g++ -O2 -g -static \
        -DRT_LINUX -DRT_P64 -DRT_128=2 -DRT_DEBUG=0 \
        -DRT_POINTER=64 -DRT_ADDRESS=64 -DRT_ELEMENT=32 -DRT_ENDIAN=0 \
        ${INC_PATH} ${SRC_LIST} ${LIB_PATH} ${LIB_LIST} -o simd_test.p64f32

simd_test_p64f64:
	powerpc64le-linux-gnu-g++ -O2 -g -static \
        -DRT_LINUX -DRT_P64 -DRT_128=2 -DRT_DEBUG=0 \
        -DRT_POINTER=64 -DRT_ADDRESS=64 -DRT_ELEMENT=64 -DRT_ENDIAN=0 \
        ${INC_PATH} ${SRC_LIST} ${LIB_PATH} ${LIB_LIST} -o simd_test.p64f64


# On Ubuntu 16.04 Live CD add "universe multiverse" to "main restricted"
# in /etc/apt/sources.list (sudo gedit /etc/apt/sources.list) then run:
# sudo apt-get update (ignoring the old database errors in the end)
#
# Prerequisites for the build:
# (cross-)compiler for 64-bit Power is installed and in the PATH variable.
# sudo apt-get install g++-powerpc64le-linux-gnu
# (recent g++-5-powerpc64le series target POWER8 and don't work well with -O3)
#
# Prerequisites for emulation:
# recent QEMU(-2.5) is installed or built from source and in the PATH variable.
# sudo apt-get install qemu
#
# Building/running SIMD test:
# make -f simd_make_p64.mk
# qemu-ppc64le -cpu POWER8 simd_test.p64f32

# For big-endian 64-bit POWER(7,7+,8) VSX target use (replace):
# powerpc64-linux-gnu-g++ -DRT_ENDIAN=1
# (enable RT_SIMD_COMPAT_I64 in core/rtarch.h for POWER7 64-bit SIMD)
# qemu-ppc64 -cpu POWER7 simd_test.p64f32

# 64/32-bit (ptr/adr) hybrid mode compatible with native 64-bit ABI
# is available for the original pure 32-bit ISA using 64-bit pointers,
# use (replace): RT_ADDRESS=32, rename the binary to simd_test.p64_32

# 64-bit packed SIMD mode (fp64/int64) is supported on 64-bit targets,
# but currently requires addresses to be 64-bit as well (RT_ADDRESS=64),
# use (replace): RT_ELEMENT=64, rename the binary to simd_test.p64f64
