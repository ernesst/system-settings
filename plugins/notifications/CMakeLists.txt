add_subdirectory(plugin)

SET (CMAKE_AUTOMOC ON)

set(QML_SOURCES
    PageComponent.qml
    ClickAppNotifications.qml
    ClickAppsSoundsNotify.qml
    ClickAppsVibrationsNotify.qml
    )

set(ubuntu_notifications_panel_HDRS
    plugin.h
    general_notification_settings.h
    click_applications_model.h
    click_applications_notify_model.h
    )

set(ubuntu_notifications_panel_SRCS
    plugin.cpp
    general_notification_settings.cpp
    click_applications_model.cpp
    click_applications_notify_model.cpp
    )

add_library(UbuntuNotificationsPanel MODULE ${ubuntu_notifications_panel_HDRS} ${ubuntu_notifications_panel_SRCS} ${QML_SOURCES})

add_definitions(-DQT_NO_KEYWORDS)
include_directories(${GIO_INCLUDE_DIRS})
include_directories(${QTGSETTINGS_INCLUDE_DIRS})

target_link_libraries(UbuntuNotificationsPanel ${GIO_LDFLAGS} ${QTGSETTINGS_LDFLAGS})
qt5_use_modules(UbuntuNotificationsPanel Qml Quick)

set(PLUG_DIR ${PLUGIN_PRIVATE_MODULE_DIR}/Ubuntu/SystemSettings/Notifications)
install(TARGETS UbuntuNotificationsPanel DESTINATION ${PLUG_DIR})
install(FILES qmldir DESTINATION ${PLUG_DIR})
install(FILES ${QML_SOURCES} DESTINATION ${PLUGIN_QML_DIR}/notifications)

install(FILES notifications.settings DESTINATION ${PLUGIN_MANIFEST_DIR})
