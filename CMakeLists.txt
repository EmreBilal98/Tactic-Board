cmake_minimum_required(VERSION 3.16)

project(tactic_board VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Sql)
find_package(Qt6 REQUIRED COMPONENTS Core Sql)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(apptactic_board
    main.cpp
)

qt_add_qml_module(apptactic_board
    URI tactic_board
    VERSION 1.0
    QML_FILES
        Main.qml
        QML_FILES MyBackground.qml
        QML_FILES Footballer.qml
        QML_FILES BasePage.qml
        QML_FILES FormationDelegate.qml
        QML_FILES FormationModel.qml
        QML_FILES DefaultFormation.qml
        SOURCES database.h database.cpp
        QML_FILES MyLogin.qml
        QML_FILES LoginBox.qml
        QML_FILES ChangeBox.qml
        RESOURCES images.qrc
)

qt_add_resources(apptactic_board "icon"
PREFIX "/"
FILES plus.png delete.png competition.png
)


# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(apptactic_board PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.apptactic_board
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(apptactic_board
    PRIVATE Qt6::Quick
    Qt6::Sql
)
target_link_libraries(apptactic_board PRIVATE Qt6::Core)

include(GNUInstallDirs)
install(TARGETS apptactic_board
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

