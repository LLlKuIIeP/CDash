include(${CMAKE_CURRENT_LIST_DIR}/current_variables.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/custom_error_exception.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/custom_warning_exception.cmake)


macro(copy_ctest_files)

if (("${CDASH_PROJECT}" STRGREATER "") AND ("${CDASH_TOKEN}" STRGREATER ""))
get_filename_component(CMAKE_SOURCE_DIR_ABSOLUTE ${CMAKE_SOURCE_DIR} ABSOLUTE)
get_filename_component(CMAKE_BINARY_DIR_ABSOLUTE ${CMAKE_BINARY_DIR} ABSOLUTE)
get_filename_component(PROJECT_ROOT_PATH ${ROOT_PATH} ABSOLUTE)

if (${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION} VERSION_LESS "3.19")
  if (NOT WIN32)
    string(ASCII 27 Esc)
    set(ColourReset "${Esc}[m")
    set(ColourBold  "${Esc}[1m")
    set(Red         "${Esc}[31m")
    set(Green       "${Esc}[32m")
    set(Yellow      "${Esc}[33m")
    set(Blue        "${Esc}[34m")
    set(Magenta     "${Esc}[35m")
    set(Cyan        "${Esc}[36m")
    set(White       "${Esc}[37m")
    set(BoldRed     "${Esc}[1;31m")
    set(BoldGreen   "${Esc}[1;32m")
    set(BoldYellow  "${Esc}[1;33m")
    set(BoldBlue    "${Esc}[1;34m")
    set(BoldMagenta "${Esc}[1;35m")
    set(BoldCyan    "${Esc}[1;36m")
    set(BoldWhite   "${Esc}[1;37m")
    message(FATAL_ERROR "${Red}Current CMake is ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION} and need not less 3.19${ColourReset}\n")
  elseif ()
    message(FATAL_ERROR "Current CMake is ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION} and need not less 3.19\n")
  endif ()
endif ()

### --- Generate CTestConfig.cmake
configure_file(${ABSOLUTE_PATH_CMAKE_UTILS}/CTestConfig.cmake.in ${CMAKE_SOURCE_DIR}/CTestConfig.cmake NEWLINE_STYLE UNIX)


set(CTEST_BUILD_NAME "${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}-${CMAKE_CXX_COMPILER_ID}")
## -- Build name and generator
### --- MSVC
if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
  if (${MSVC_TOOLSET_VERSION} EQUAL 141)
    set(CTEST_BUILD_NAME "${CTEST_BUILD_NAME}-2017")
    set(CTEST_CMAKE_GENERATOR "Visual Studio 15 2017 Win64")
  elseif (${MSVC_TOOLSET_VERSION} EQUAL 142)
    set(CTEST_BUILD_NAME "${CTEST_BUILD_NAME}-2019")
    set(CTEST_CMAKE_GENERATOR "Visual Studio 16 2019")
    set(CMAKE_GENERATOR_PLATFORM "x64")
  endif()
### --- GNU or Clang
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
  set(CTEST_CMAKE_GENERATOR "Unix Makefiles")
  set(CTEST_BUILD_NAME "${CTEST_BUILD_NAME}-${CMAKE_CXX_COMPILER_VERSION}")
### --- Intel
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Intel")
  set(CTEST_CMAKE_GENERATOR "Unix Makefiles")
endif ()

### --- STATIC ANALYZER
### --- CppCheck
if (CMAKE_CXX_CPPCHECK)
  set(CTEST_BUILD_NAME "${CTEST_BUILD_NAME}-CppCheck")
### --- Clang-tidy
elseif (CMAKE_CXX_CLANG_TIDY)
  set(CTEST_BUILD_NAME "${CTEST_BUILD_NAME}-Clang-tidy")
  set(CLANG_TIDY_CHECKS
    "-*,"
    "bugprone-*,"
    "clang-analyzer-core.uninitialized.CapturedBlockVariable,"
    "clang-analyzer-cplusplus.InnerPointer,"
    "clang-analyzer-nullability.NullableReturnedFromNonnull,"
    "clang-analyzer-optin.osx.OSObjectCStyleCast,"
    "clang-analyzer-optin.performance.Padding,"
    "concurrency-mt-unsafe,"
    "cppcoreguidelines-avoid-goto,"
    "cppcoreguidelines-avoid-non-const-global-variables,"
    "cppcoreguidelines-init-variables,"
    "cppcoreguidelines-interfaces-global-init,"
    "cppcoreguidelines-macro-usage,"
    "cppcoreguidelines-narrowing-conversions,"
    "cppcoreguidelines-no-malloc,"
    "cppcoreguidelines-pro-type-const-cast,"
    "cppcoreguidelines-pro-type-cstyle-cast,"
    "cppcoreguidelines-pro-type-member-init,"
    "cppcoreguidelines-pro-type-union-access,"
    "cppcoreguidelines-slicing,"
    "cppcoreguidelines-special-member-functions,"
    "darwin-*,"
    "fuchsia-trailing-return,"
    "google-build-explicit-make-pair,"
    "google-build-using-namespace,"
    "google-explicit-constructor,"
    "google-global-names-in-headers,"
    "google-readability-casting,"
    "google-runtime-operator,"
    "hicpp-multiway-paths-covered,"
    "hicpp-no-assemblyr,"
    "hicpp-signed-bitwise,"
    "llvm-include-order,"
    "llvm-namespace-comment,"
    "misc-definitions-in-headers,"
    "misc-misplaced-const,"
    "misc-new-delete-overloads,"
    "misc-redundant-expression,"
    "misc-throw-by-value-catch-by-reference,"
    "misc-unconventional-assign-operator,"
    "misc-uniqueptr-reset-release,"
    "misc-unused-alias-decls,"
    "misc-unused-parameters,"
    "performance-faster-string-find,"
    "performance-for-range-copy,"
    "performance-inefficient-string-concatenation,"
    "performance-implicit-conversion-in-loop,"
    "performance-inefficient-algorithm,"
    "performance-inefficient-vector-operation,"
    "performance-move-const-arg,"
    "performance-no-automatic-move,"
    "performance-no-int-to-ptr,"
    "performance-noexcept-move-constructor,"
    "performance-trivially-destructible,"
    "performance-type-promotion-in-math-fn,"
    "performance-unnecessary-copy-initialization,"
    "performance-unnecessary-value-param,"
    "readability-avoid-const-params-in-decls,"
    "readability-const-return-type,"
    "readability-container-size-empty,"
    "readability-convert-member-functions-to-static,"
    "readability-delete-null-pointer,"
    "readability-deleted-default,"
    "readability-else-after-return,"
    "readability-implicit-bool-conversion,"
    "readability-inconsistent-declaration-parameter-name,"
    "readability-isolate-declaration,"
    "readability-make-member-function-const,"
    "readability-misleading-indentation,"
    "readability-misplaced-array-index,"
    "readability-named-parameter,"
    "readability-non-const-parameter,"
    "readability-qualified-auto,"
    "readability-redundant-access-specifiers,"
    "readability-redundant-control-flow,"
    "readability-redundant-declaration,"
    "readability-redundant-function-ptr-dereference,"
    "readability-redundant-member-init,"
    "readability-redundant-preprocessor,"
    "readability-redundant-smartptr-get,"
    "readability-redundant-string-cstr,"
    "readability-redundant-string-init,"
    "readability-static-definition-in-anonymous-namespace,"
    "readability-string-compare,"
    "readability-uniqueptr-delete-release,"
    "cert-dcl21-cpp,"
    "cert-dcl50-cpp,"
    "cert-dcl58-cpp,"
    "cert-err34-c,"
    "cert-err52-cpp,"
    "cert-err58-cpp,"
    "cert-oop58-cpp"
  )
  ### --- лайфак, чтобы собрать все строки в одну
  string(REPLACE "" "" CLANG_TIDY_CHECKS ${CLANG_TIDY_CHECKS})

  set(CMAKE_CXX_CLANG_TIDY "${CMAKE_CXX_CLANG_TIDY};-checks=${CLANG_TIDY_CHECKS};-header-filter='${PROJECT_ROOT_PATH}/*'")
### --- IWYU
elseif (CMAKE_CXX_INCLUDE_WHAT_YOU_USE)
  set(CTEST_BUILD_NAME "${CTEST_BUILD_NAME}-iwyu")
### --- LWYU
elseif (CMAKE_LINK_WHAT_YOU_USE)
  set(CTEST_BUILD_NAME "${CTEST_BUILD_NAME}-lwyu")
### --- Clazy
elseif (CMAKE_CXX_COMPILER MATCHES "clazy")
  set(CTEST_BUILD_NAME "${CTEST_BUILD_NAME}-clazy")
  set(CMAKE_EXPORT_COMPILE_COMMANDS "level1;no-clazy-qproperty-without-notify;no-clazy-qcolor-from-literal,no-clazy-non-pod-global-static")
### --- Clang Analyzer
elseif (CLANG_ANALYZER)
  set(CTEST_BUILD_NAME "${CTEST_BUILD_NAME}-Analyzer")
endif ()


### --- Custom Error Exception
qt_custom_error_exception()
thirdparty_custom_error_exception()
### --- CppCheck
if (CMAKE_CXX_CPPCHECK)
  cppcheck_custom_error_exception()
### --- Clang-tidy
elseif (CMAKE_CXX_CLANG_TIDY)
  clang_tidy_custom_error_exception()
### --- Clazy
elseif (CMAKE_CXX_COMPILER MATCHES "clazy")
  clazy_custom_error_exception()
endif ()
string(REPLACE ";" "\"\n  \"" CTEST_CUSTOM_ERROR_EXCEPTION "${CTEST_CUSTOM_ERROR_EXCEPTION}")
### --- баг с (.*) https://gitlab.kitware.com/cmake/cmake/-/issues/18884
string(REGEX REPLACE "^(.+)$" "\"\\1\"" CTEST_CUSTOM_ERROR_EXCEPTION "${CTEST_CUSTOM_ERROR_EXCEPTION}")

### --- Custom Warning Exception
qt_custom_warning_exception()
thirdparty_custom_warning_exception()
### --- CppCheck
if (CMAKE_CXX_CPPCHECK)
  cppcheck_custom_warning_exception()
### --- Clang-tidy
elseif (CMAKE_CXX_CLANG_TIDY)
  clang_tidy_custom_warning_exception()
### --- Clazy
elseif (CMAKE_CXX_COMPILER MATCHES "clazy")
  clazy_custom_warning_exception()
endif ()
string(REPLACE ";" "\"\n  \"" CTEST_CUSTOM_WARNING_EXCEPTION "${CTEST_CUSTOM_WARNING_EXCEPTION}")
string(REGEX REPLACE "^(.+)$" "\"\\1\"" CTEST_CUSTOM_WARNING_EXCEPTION "${CTEST_CUSTOM_WARNING_EXCEPTION}")


### --- Generate CTestCustom.cmake
configure_file(${ABSOLUTE_PATH_CMAKE_UTILS}/CTestCustom.cmake.in ${CMAKE_BINARY_DIR}/CTestCustom.cmake NEWLINE_STYLE UNIX)


### --- вытащить hash коммита
find_package(Git)
if (GIT_FOUND)
  message("git found: ${GIT_EXECUTABLE}")
  execute_process(COMMAND "${GIT_EXECUTABLE}" rev-parse --short HEAD
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_SHORT_HASH
    RESULT_VARIABLE GIT_SHORT_HASH_RES
  ERROR_QUIET)
  execute_process(COMMAND "${GIT_EXECUTABLE}" branch --show-current
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_BRANCH_NAME
    RESULT_VARIABLE GIT_BRANCH_NAME_RES
  ERROR_QUIET)
  if (WIN32)
    ### -- branch name
    string(REPLACE "\n" "" GIT_BRANCH_NAME ${GIT_BRANCH_NAME})
    string(REPLACE "\r" "" GIT_BRANCH_NAME ${GIT_BRANCH_NAME})
    ### --- hash commit
    string(REPLACE "\n" "" GIT_SHORT_HASH ${GIT_SHORT_HASH})
    string(REPLACE "\r" "" GIT_SHORT_HASH ${GIT_SHORT_HASH})
  elseif (UNIX)
    ### -- branch name
    string(REPLACE "\n" "" GIT_BRANCH_NAME ${GIT_BRANCH_NAME})
    ### --- hash commit
    string(REPLACE "\n" "" GIT_SHORT_HASH ${GIT_SHORT_HASH})
  endif ()
endif ()


### --- Generate CTestDashboard.cmake
if (SANITIZE)
  if (SANITIZE STREQUAL "address")
    set(CTEST_MEMORYCHECK_TYPE "AddressSanitizer")
  elseif (SANITIZE STREQUAL "thread")
    set(CTEST_MEMORYCHECK_TYPE "ThreadSanitizer")
  elseif (SANITIZE STREQUAL "memory")
    set(CTEST_MEMORYCHECK_TYPE "MemorySanitizer")
  elseif (SANITIZE STREQUAL "undefined")
    set(CTEST_MEMORYCHECK_TYPE "UndefinedBehaviorSanitizer")
  elseif (SANITIZE STREQUAL "leak")
    set(CTEST_MEMORYCHECK_TYPE "LeakSanitizer")
  endif ()

  set(CTEST_BUILD_NAME "${CTEST_BUILD_NAME}-${GIT_BRANCH_NAME}-${CTEST_MEMORYCHECK_TYPE}-${GIT_SHORT_HASH}")
  configure_file(${ABSOLUTE_PATH_CMAKE_UTILS}/CTestDashboardSanitizer.cmake.in ${CMAKE_BINARY_DIR}/CTestDashboard.cmake @ONLY NEWLINE_STYLE UNIX)
else ()
  set(CTEST_BUILD_NAME "${CTEST_BUILD_NAME}-${GIT_BRANCH_NAME}-${GIT_SHORT_HASH}")
  configure_file(${ABSOLUTE_PATH_CMAKE_UTILS}/CTestDashboard.cmake.in ${CMAKE_BINARY_DIR}/CTestDashboard.cmake @ONLY NEWLINE_STYLE UNIX)
endif ()


enable_testing()
include(CTest)
endif ()

endmacro()
