include( ${CMAKE_CURRENT_LIST_DIR}/../../../../TomahawkAddPlugin.cmake )

file(GLOB SUBDIRECTORIES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "*")
foreach(SUBDIRECTORY ${SUBDIRECTORIES})
  if(IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${SUBDIRECTORY}" AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${SUBDIRECTORY}/CMakeLists.txt")
    if(SUBDIRECTORY STREQUAL "telepathy")
        if( TelepathyQt_FOUND )
            add_subdirectory( telepathy )
        endif()
    else()
        add_subdirectory(${SUBDIRECTORY})
    endif()
  endif()
endforeach()
