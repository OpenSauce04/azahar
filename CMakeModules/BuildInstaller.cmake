# To use this as a script, make sure you pass in the variables BASE_DIR, SRC_DIR, BUILD_DIR, and TARGET_FILE
cmake_minimum_required(VERSION 3.15)

if(WIN32)
    set(PLATFORM "windows")
elseif(APPLE)
    set(PLATFORM "mac")
elseif(UNIX)
    set(PLATFORM "linux")
else()
    message(FATAL_ERROR "Cannot build installer for this unsupported platform")
endif()

list(APPEND CMAKE_MODULE_PATH "${BASE_DIR}/CMakeModules")
include(DownloadExternals)
download_qt(tools_ifw)
get_external_prefix(qt QT_PREFIX)

file(GLOB_RECURSE INSTALLER_BASE "${QT_PREFIX}/**/installerbase*")
file(GLOB_RECURSE BINARY_CREATOR "${QT_PREFIX}/**/binarycreator*")

set(CONFIG_FILE "${SRC_DIR}/config/config_${PLATFORM}.xml")

set(PACKAGES_DIR "${BUILD_DIR}/packages")
set(LIME_PACKAGE_DIR "${PACKAGES_DIR}/io.github.lime3ds.Lime3DS")
set(LIME_PACKAGE_DATA_DIR "${LIME_PACKAGE_DIR}/data")
set(LIME_PACKAGE_META_DIR "${LIME_PACKAGE_DIR}/meta")
set(LIME_BINARY_DIR "${BUILD_DIR}/../bin/Release")
file(GLOB LIME_BINARIES "${LIME_BINARY_DIR}/*")

file(MAKE_DIRECTORY ${PACKAGES_DIR} ${LIME_PACKAGE_DIR} ${LIME_PACKAGE_DATA_DIR} ${LIME_PACKAGE_META_DIR})
file(COPY ${LIME_BINARIES} DESTINATION ${LIME_PACKAGE_DATA_DIR})
file(COPY "${SRC_DIR}/config/package.xml" "${SRC_DIR}/config/installscript.qs" DESTINATION ${LIME_PACKAGE_META_DIR})

execute_process(COMMAND ${BINARY_CREATOR} -t ${INSTALLER_BASE} -f -c ${CONFIG_FILE} -p ${PACKAGES_DIR} ${TARGET_FILE})
