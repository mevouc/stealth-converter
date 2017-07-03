find_package(PkgConfig)
include(FindPackageHandleStandardArgs)

function(libav_find_component component)
  string(TOLOWER ${component} component_lower)

  set(COMPONENT_PACKAGE_NAME "AV${component}")
  set(COMPONENT_FULL_NAME "av${component_lower}")
  set(COMPONENT_LIBRARY "lib${COMPONENT_FULL_NAME}")
  set(COMPONENT_SUFFIX "lib${COMPONENT_FULL_NAME}")
  set(COMPONENT_HEADER_NAME "${COMPONENT_FULL_NAME}.h")

  if (PKG_CONFIG_FOUND)
    pkg_check_modules(PC_${COMPONENT_PACKAGE_NAME} ${COMPONENT_LIBRARY})
  endif (PKG_CONFIG_FOUND)

  find_path(${COMPONENT_PACKAGE_NAME}_INCLUDE_DIR
    NAMES ${COMPONENT_SUFFIX}/${COMPONENT_HEADER_NAME}
    HINTS ${${COMPONENT_PACKAGE_NAME}_INCLUDE_DIRS} ${PC_${COMPONENT_PACKAGE_NAME}_INCLUDE_DIRS}
    NO_DEFAULT_PATH
  )

  if (${${COMPONENT_PACKAGE_NAME}_INCLUDE_DIR} STREQUAL ${COMPONENT_PACKAGE_NAME}_INCLUDE_DIR-NOTFOUND)
    find_path(${COMPONENT_PACKAGE_NAME}_INCLUDE_DIR
      NAMES ${COMPONENT_SUFFIX}/${COMPONENT_HEADER_NAME}
    )
  endif()

  list(APPEND ${COMPONENT_PACKAGE_NAME}_INCLUDE_DIRS ${${COMPONENT_PACKAGE_NAME}_INCLUDE_DIR} )

  find_library(${COMPONENT_PACKAGE_NAME}_LIBRARY
    NAMES ${COMPONENT_FULL_NAME} ${COMPONENT_LIBRARY}
    HINTS ${${COMPONENT_PACKAGE_NAME}_LIBRARY_DIRS}
  )
  list(APPEND ${COMPONENT_PACKAGE_NAME}_LIBRARIES ${${COMPONENT_PACKAGE_NAME}_LIBRARY})

  set(${COMPONENT_PACKAGE_NAME}_INCLUDE_DIRS ${${COMPONENT_PACKAGE_NAME}_INCLUDE_DIRS} PARENT_SCOPE)
  set(${COMPONENT_PACKAGE_NAME}_LIBRARIES ${${COMPONENT_PACKAGE_NAME}_LIBRARIES} PARENT_SCOPE)
endfunction(libav_find_component)
