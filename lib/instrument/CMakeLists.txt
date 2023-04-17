add_library(pathprofilePass
    PathProfilingPass.cpp
)

set_target_properties(pathprofilePass PROPERTIES
    COMPILE_FLAGS "-fno-rtti"
)