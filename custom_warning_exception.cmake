macro(qt_custom_warning_exception)
  set(CTEST_CUSTOM_WARNING_EXCEPTION
    ${CTEST_CUSTOM_WARNING_EXCEPTION}
    ".*_autogen.*"
    ".*[\\\\/]include[\\\\/][Qq]t[Cc]ore[\\\\/].*"
    ".*[\\\\/]include[\\\\/][Qq]t[Ww]idgets[\\\\/].*"
    ".*[\\\\/]include[\\\\/][Qq]t[Gg]ui[\\\\/].*"
  )
endmacro()

macro(thirdparty_custom_warning_exception)
  set(CTEST_CUSTOM_WARNING_EXCEPTION
    ${CTEST_CUSTOM_WARNING_EXCEPTION}
    ".*/x86_64-linux-gnu/.*"
    ".*[\\\\/]qwt[\\\\/].*"
    ".*[\\\\/]boost[\\\\/].*"
    ".*[\\\\/]catch2[\\\\/].*"
    ".*extern[\\\\/]json_utils[\\\\/].*"
    ".*extern[\\\\/][Ee]igen[\\\\/].*"
    ".*extern[\\\\/]platform_thirdparty[\\\\/].*"
    ".*extern[\\\\/]proj4[\\\\/].*"
    ".*extern[\\\\/]visualizer_3d[\\\\/].*"
    ".*extern[\\\\/]common_utils[\\\\/].*"
    ".*extern[\\\\/]spectra[\\\\/].*"
    ".*extern[\\\\/]drillhydro[\\\\/].*"
    ".*extern[\\\\/][Hh]ydro[Rr]ing[\\\\/].*"
    ".*extern[\\\\/]gdm_thirdparty[\\\\/].*"
    ".*extern[\\\\/]gdm_common[\\\\/].*"
    ".*extern[\\\\/]geographiclib[\\\\/].*"
    ".*app[\\\\/]witsml_monitoring_server[\\\\/]lib[\\\\/]q_json_web_token[\\\\/].*"
    ".*app[\\\\/]witsml_monitoring_server[\\\\/]lib[\\\\/]qt_web_app[\\\\/].*"
    ".*app[\\\\/]witsml_monitoring_server[\\\\/]lib[\\\\/]cpp-httplib[\\\\/].*"
    ".*CMakeFiles[\\\\/].*"
  )
endmacro()

macro(cppcheck_custom_warning_exception)
  set(CTEST_CUSTOM_WARNING_EXCEPTION
    ${CTEST_CUSTOM_WARNING_EXCEPTION}
  )
endmacro()

macro(clang_tidy_custom_warning_exception)
  set(CTEST_CUSTOM_WARNING_EXCEPTION
    ${CTEST_CUSTOM_WARNING_EXCEPTION}
    ".*include[\\\\/]moc_.*"
  )
endmacro()

macro(clazy_custom_warning_exception)
  set(CTEST_CUSTOM_WARNING_EXCEPTION
    ${CTEST_CUSTOM_WARNING_EXCEPTION}
  )
endmacro()
