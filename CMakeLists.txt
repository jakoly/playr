cmake_minimum_required(VERSION 3.20)
project(playr LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick)

qt_add_executable(playr
    main.cpp
)

target_link_libraries(playr
    PRIVATE Qt6::Core Qt6::Gui Qt6::Qml Qt6::Quick
)