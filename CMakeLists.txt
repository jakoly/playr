cmake_minimum_required(VERSION 3.20)
project(playr LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(APP_ICON_RESOURCE_WINDOWS res/app.rc)
set(CMAKE_PREFIX_PATH "C:/Qt/6.9.1/msvc2022_64")

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick Widgets Multimedia)

qt_policy(SET QTP0001 NEW)
qt_policy(SET QTP0004 NEW)

qt_add_executable(playr WIN32
    main.cpp
    player.cpp
    player.h
    res/app.rc
)

qt_add_qml_module(playr
    URI playr
    VERSION 1.0
    NO_CACHEGEN          # ← behebt den Linker-Fehler
    QML_FILES
        qml/Main.qml
)

target_link_libraries(playr
    PRIVATE
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
        Qt6::Widgets
        Qt6::Multimedia
)

# JSON-Ordner in den Build-Ordner kopieren
add_custom_command(TARGET playr POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${CMAKE_SOURCE_DIR}/json
    $<TARGET_FILE_DIR:playr>/json
)