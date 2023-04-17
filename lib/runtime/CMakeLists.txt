add_library(pathProfileRt MODULE
    runtime_function.cpp
)

set_target_properties(pathProfileRt PROPERTIES
    COMPILE_FLAGS "-fno-rtti"
)