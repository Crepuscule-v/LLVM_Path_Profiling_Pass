# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.16

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/fuzz/Desktop/LLVM_path_profiling_pass

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/fuzz/Desktop/LLVM_path_profiling_pass/build

# Include any dependencies generated for this target.
include lib/instrument/CMakeFiles/pathProfilePass.dir/depend.make

# Include the progress variables for this target.
include lib/instrument/CMakeFiles/pathProfilePass.dir/progress.make

# Include the compile flags for this target's objects.
include lib/instrument/CMakeFiles/pathProfilePass.dir/flags.make

lib/instrument/CMakeFiles/pathProfilePass.dir/PathProfilingPass.cpp.o: lib/instrument/CMakeFiles/pathProfilePass.dir/flags.make
lib/instrument/CMakeFiles/pathProfilePass.dir/PathProfilingPass.cpp.o: ../lib/instrument/PathProfilingPass.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/fuzz/Desktop/LLVM_path_profiling_pass/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object lib/instrument/CMakeFiles/pathProfilePass.dir/PathProfilingPass.cpp.o"
	cd /home/fuzz/Desktop/LLVM_path_profiling_pass/build/lib/instrument && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/pathProfilePass.dir/PathProfilingPass.cpp.o -c /home/fuzz/Desktop/LLVM_path_profiling_pass/lib/instrument/PathProfilingPass.cpp

lib/instrument/CMakeFiles/pathProfilePass.dir/PathProfilingPass.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/pathProfilePass.dir/PathProfilingPass.cpp.i"
	cd /home/fuzz/Desktop/LLVM_path_profiling_pass/build/lib/instrument && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/fuzz/Desktop/LLVM_path_profiling_pass/lib/instrument/PathProfilingPass.cpp > CMakeFiles/pathProfilePass.dir/PathProfilingPass.cpp.i

lib/instrument/CMakeFiles/pathProfilePass.dir/PathProfilingPass.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/pathProfilePass.dir/PathProfilingPass.cpp.s"
	cd /home/fuzz/Desktop/LLVM_path_profiling_pass/build/lib/instrument && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/fuzz/Desktop/LLVM_path_profiling_pass/lib/instrument/PathProfilingPass.cpp -o CMakeFiles/pathProfilePass.dir/PathProfilingPass.cpp.s

# Object files for target pathProfilePass
pathProfilePass_OBJECTS = \
"CMakeFiles/pathProfilePass.dir/PathProfilingPass.cpp.o"

# External object files for target pathProfilePass
pathProfilePass_EXTERNAL_OBJECTS =

lib/instrument/libpathProfilePass.so: lib/instrument/CMakeFiles/pathProfilePass.dir/PathProfilingPass.cpp.o
lib/instrument/libpathProfilePass.so: lib/instrument/CMakeFiles/pathProfilePass.dir/build.make
lib/instrument/libpathProfilePass.so: lib/instrument/CMakeFiles/pathProfilePass.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/fuzz/Desktop/LLVM_path_profiling_pass/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX shared module libpathProfilePass.so"
	cd /home/fuzz/Desktop/LLVM_path_profiling_pass/build/lib/instrument && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/pathProfilePass.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
lib/instrument/CMakeFiles/pathProfilePass.dir/build: lib/instrument/libpathProfilePass.so

.PHONY : lib/instrument/CMakeFiles/pathProfilePass.dir/build

lib/instrument/CMakeFiles/pathProfilePass.dir/clean:
	cd /home/fuzz/Desktop/LLVM_path_profiling_pass/build/lib/instrument && $(CMAKE_COMMAND) -P CMakeFiles/pathProfilePass.dir/cmake_clean.cmake
.PHONY : lib/instrument/CMakeFiles/pathProfilePass.dir/clean

lib/instrument/CMakeFiles/pathProfilePass.dir/depend:
	cd /home/fuzz/Desktop/LLVM_path_profiling_pass/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/fuzz/Desktop/LLVM_path_profiling_pass /home/fuzz/Desktop/LLVM_path_profiling_pass/lib/instrument /home/fuzz/Desktop/LLVM_path_profiling_pass/build /home/fuzz/Desktop/LLVM_path_profiling_pass/build/lib/instrument /home/fuzz/Desktop/LLVM_path_profiling_pass/build/lib/instrument/CMakeFiles/pathProfilePass.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : lib/instrument/CMakeFiles/pathProfilePass.dir/depend
