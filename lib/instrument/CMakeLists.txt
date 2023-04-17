add_library(pathProfilePass MODULE
    PathProfilingPass.cpp
)

set_target_properties(pathProfilePass PROPERTIES
    COMPILE_FLAGS "-fno-rtti"
)