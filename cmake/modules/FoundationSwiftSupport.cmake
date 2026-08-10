##===----------------------------------------------------------------------===##
##
## This source file is part of the Swift open source project
##
## Copyright (c) 2024 Apple Inc. and the Swift project authors
## Licensed under Apache License v2.0
##
## See LICENSE.txt for license information
## See CONTRIBUTORS.md for the list of Swift project authors
##
## SPDX-License-Identifier: Apache-2.0
##
##===----------------------------------------------------------------------===##

function(_foundation_install_target module)
  set(swift_os ${SWIFT_SYSTEM_NAME})
  get_target_property(type ${module} TYPE)

  if(type STREQUAL STATIC_LIBRARY)
    set(swift swift_static)
  else()
    set(swift swift)
  endif()

  install(TARGETS ${module}
    ARCHIVE DESTINATION lib/${swift}/${swift_os}
    LIBRARY DESTINATION lib/${swift}/${swift_os}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
  if(type STREQUAL EXECUTABLE)
    return()
  endif()

  get_target_property(module_name ${module} Swift_MODULE_NAME)
  if(NOT module_name)
    set(module_name ${module})
  endif()

  # Under CMP0195 the module is laid down as <module>.swiftmodule/<triple>.*
  set(_cmp0195_status "OLD")
  if(POLICY CMP0195)
    cmake_policy(GET CMP0195 _cmp0195_status)
  endif()
  if(_cmp0195_status STREQUAL "NEW")
    set(_module_src_stem "${module_name}.swiftmodule/${CMAKE_Swift_MODULE_TRIPLE}")
  else()
    set(_module_src_stem "${module_name}")
  endif()

  install(FILES $<TARGET_PROPERTY:${module},Swift_MODULE_DIRECTORY>/${_module_src_stem}.swiftdoc
    DESTINATION lib/${swift}/${swift_os}/${module_name}.swiftmodule
    RENAME ${SwiftFoundation_MODULE_TRIPLE}.swiftdoc)
  install(FILES $<TARGET_PROPERTY:${module},Swift_MODULE_DIRECTORY>/${_module_src_stem}.swiftmodule
    DESTINATION lib/${swift}/${swift_os}/${module_name}.swiftmodule
    RENAME ${SwiftFoundation_MODULE_TRIPLE}.swiftmodule)

endfunction()
