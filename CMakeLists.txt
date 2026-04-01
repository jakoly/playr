cmake_minimum_required(VERSION 3.20)
project(playr LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick)

qt_policy(SET QTP0001 NEW)
qt_policy(SET QTP0004 NEW)

qt_add_executable(playr
    main.cpp
    player.cpp
    filehandler.cpp
    filehandler.h
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
)