#
# This module looks for lucene++ support
# It will define the following values
#
# LUCENEPP_INCLUDE_DIRS = LUCENEPP_INCLUDE_DIR + LUCENEPP_LIBRARY_DIR
# LUCENEPP_INCLUDE_DIR  = where lucene++/Lucene.h can be found
# LUCENEPP_LIBRARY_DIR  = where liblucene++.so can be found
# LUCENEPP_LIBRARIES    = the libraries to link against lucene++
# LUCENEPP_VERSION      = The lucene++ version string
# LUCENEPP_FOUND        = set to 1 if lucene++ is found
#

INCLUDE(CheckSymbolExists)
INCLUDE(FindLibraryWithDebug)

IF(LUCENEPP_FIND_VERSION)
  SET(LUCENEPP_MIN_VERSION ${LUCENEPP_FIND_VERSION})
ELSEIF()
  SET(LUCENEPP_MIN_VERSION "3.0.0")
ENDIF(LUCENEPP_FIND_VERSION)

SET(TRIAL_LIBRARY_PATHS
  $ENV{LUCENEPP_HOME}/lib${LIB_SUFFIX}
  ${CMAKE_INSTALL_PREFIX}/lib${LIB_SUFFIX}
  /usr/local/lib${LIB_SUFFIX}
  /usr/lib${LIB_SUFFIX}
  /sw/lib${LIB_SUFFIX}
  /usr/pkg/lib${LIB_SUFFIX}
  /usr/lib64
  /usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}
  )
SET(TRIAL_INCLUDE_PATHS
  $ENV{LUCENEPP_HOME}/include
  ${CMAKE_INSTALL_PREFIX}/include
  /usr/local/include
  /usr/include
  /sw/include
  /usr/pkg/include
  )
FIND_LIBRARY_WITH_DEBUG(LUCENEPP_CORE_LIBRARY
  WIN32_DEBUG_POSTFIX d
  NAMES lucene++
  PATHS ${TRIAL_LIBRARY_PATHS})
IF (LUCENEPP_CORE_LIBRARY)
  MESSAGE(STATUS "Found Lucene++ core library: ${LUCENEPP_CORE_LIBRARY}")
ENDIF (LUCENEPP_CORE_LIBRARY)
FIND_LIBRARY_WITH_DEBUG(LUCENEPP_SHARED_LIBRARY
  WIN32_DEBUG_POSTFIX d
  NAMES lucene++-contrib
  PATHS ${TRIAL_LIBRARY_PATHS})
IF (LUCENEPP_SHARED_LIBRARY)
  MESSAGE(STATUS "Found Lucene++ contrib library: ${LUCENEPP_SHARED_LIBRARY}")
ENDIF (LUCENEPP_SHARED_LIBRARY)

IF(LUCENEPP_CORE_LIBRARY AND LUCENEPP_SHARED_LIBRARY)
  SET(LUCENEPP_LIBRARIES ${LUCENEPP_CORE_LIBRARY} ${LUCENEPP_SHARED_LIBRARY} boost_system)
ENDIF(LUCENEPP_CORE_LIBRARY AND LUCENEPP_SHARED_LIBRARY)

FIND_PATH(LUCENEPP_INCLUDE_DIR
  NAMES lucene++/Lucene.h
  PATHS ${TRIAL_INCLUDE_PATHS})

IF (LUCENEPP_INCLUDE_DIR)
  MESSAGE(STATUS "Found Lucene++ include dir: ${LUCENEPP_INCLUDE_DIR}")
ENDIF (LUCENEPP_INCLUDE_DIR)

IF(WIN32)
  SET(TRIAL_LIBRARY_PATHS ${LUCENEPP_INCLUDE_DIR})
ENDIF(WIN32)

SET(LUCENEPP_GOOD_VERSION TRUE)

FIND_PATH(LUCENEPP_LIBRARY_DIR
	NAMES liblucene++.dylib liblucene++.so liblucene++.dll
       	PATHS ${TRIAL_LIBRARY_PATHS} ${TRIAL_INCLUDE_PATHS} NO_DEFAULT_PATH)
IF (LUCENEPP_LIBRARY_DIR)
  MESSAGE(STATUS "Found Lucene++ library dir: ${LUCENEPP_LIBRARY_DIR}")

  IF (LUCENEPP_VERSION STRLESS "${LUCENEPP_MIN_VERSION}")
    MESSAGE(ERROR " Lucene++ version ${LUCENEPP_VERSION} is less than the required minimum ${LUCENEPP_MIN_VERSION}")
    SET(LUCENEPP_GOOD_VERSION FALSE)
  ENDIF (LUCENEPP_VERSION STRLESS "${LUCENEPP_MIN_VERSION}")
ENDIF (LUCENEPP_LIBRARY_DIR)

IF(LUCENEPP_INCLUDE_DIR AND LUCENEPP_LIBRARIES AND LUCENEPP_LIBRARY_DIR AND LUCENEPP_GOOD_VERSION)
  SET(LUCENEPP_FOUND TRUE)
  SET(LUCENEPP_INCLUDE_DIRS ${LUCENEPP_LIBRARY_DIR} ${LUCENEPP_INCLUDE_DIR})
ENDIF(LUCENEPP_INCLUDE_DIR AND LUCENEPP_LIBRARIES AND LUCENEPP_LIBRARY_DIR AND LUCENEPP_GOOD_VERSION)

IF(LUCENEPP_FOUND)
  IF(NOT LUCENEPP_FIND_QUIETLY)
    MESSAGE(STATUS "Found Lucene++: ${LUCENEPP_LIBRARIES} version ${LUCENEPP_VERSION}")
  ENDIF(NOT LUCENEPP_FIND_QUIETLY)
ELSE(LUCENEPP_FOUND)
  IF(LUCENEPP_FIND_REQUIRED)
    MESSAGE(FATAL_ERROR "Could not find Lucene++.")
  ENDIF(LUCENEPP_FIND_REQUIRED)
ENDIF(LUCENEPP_FOUND)

MARK_AS_ADVANCED(
  LUCENEPP_INCLUDE_DIRS
  LUCENEPP_INCLUDE_DIR
  LUCENEPP_LIBRARY_DIR
  LUCENEPP_LIBRARIES
  )
