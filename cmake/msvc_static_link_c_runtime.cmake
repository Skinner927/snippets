option(MSVC_STATIC_RUNTIME "Statically link the C runtime" OFF)
if(MSVC_STATIC_RUNTIME)
  set(MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
  add_compile_options("/MT")
  # Brute force
  set(compiler_flags
        CMAKE_C_FLAGS
        CMAKE_C_FLAGS_DEBUG
        CMAKE_C_FLAGS_MINSIZEREL
        CMAKE_C_FLAGS_RELEASE
        CMAKE_C_FLAGS_RELWITHDEBINFO
        CMAKE_CXX_FLAGS
        CMAKE_CXX_FLAGS_DEBUG
        CMAKE_CXX_FLAGS_MINSIZEREL
        CMAKE_CXX_FLAGS_RELEASE
        CMAKE_CXX_FLAGS_RELWITHDEBINFO
  )
  message("Modifying flags for static runtime")
  foreach(flag_name ${compiler_flags})
    if(DEFINED ${flag_name})
      message("  - ${flag_name}: ${${flag_name}}")
      # Delete/replace any current flags
      string(REGEX REPLACE "(^| )/M[DT](d?)( |$)" "\\1/MT\\2\\3"
              ${flag_name} "${${flag_name}}")

      # Do not force a value on non-config variables
      string(REGEX MATCH "_FLAGS$" no_config "${flag_name}")
      if("${no_config}" STREQUAL "")
        # Is this a debug config?
        string(FIND "${flag_name}" "DEB" is_debug)
        if(is_debug LESS 0)
          set(runtime_flag "/MT")
        else()
          set(runtime_flag "/MTd")
        endif()

        set(${flag_name} "${${flag_name}} ${runtime_flag}")
      endif()
      message("  + ${flag_name}: ${${flag_name}}")
    endif()
  endforeach()
endif()
