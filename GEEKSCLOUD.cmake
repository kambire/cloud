# SPDX-FileCopyrightText: 2025 Geeks Cloud
# SPDX-FileCopyrightText: 2017 Nextcloud GmbH and Nextcloud contributors
# SPDX-FileCopyrightText: 2012 ownCloud GmbH
# SPDX-License-Identifier: GPL-2.0-or-later
#
# Geeks Cloud white-label branding for the Nextcloud Desktop Client.
# This file replaces NEXTCLOUD.cmake as the theme/branding definition and is
# included from CMakeLists.txt. Values marked "TODO" should be confirmed by
# Geeks Cloud before producing a production installer.

# Display name may contain a space; the SHORTNAME / EXECUTABLE / ICON_NAME must
# stay filesystem-safe (no spaces) because they are used in paths and filenames.
if(NEXTCLOUD_DEV)
    set( APPLICATION_NAME       "Geeks Cloud Dev" )
    set( APPLICATION_SHORTNAME  "GeeksCloudDev" )
    set( APPLICATION_EXECUTABLE "geeksclouddev" )
    set( APPLICATION_ICON_NAME  "GeeksCloud" )
else()
    set( APPLICATION_NAME       "Geeks Cloud" )
    set( APPLICATION_SHORTNAME  "GeeksCloud" )
    set( APPLICATION_EXECUTABLE "geekscloud" )
    set( APPLICATION_ICON_NAME  "${APPLICATION_SHORTNAME}" )
endif()

set( APPLICATION_CONFIG_NAME "${APPLICATION_EXECUTABLE}" )
set( APPLICATION_DOMAIN     "geekscloud.com" )                               # TODO: confirm company domain
set( APPLICATION_VENDOR     "Geeks Cloud" )                                  # TODO: confirm legal company name
# Must be NON-empty: config.h's #cmakedefine only defines the APPLICATION_UPDATE_URL
# macro when this is set, and theme.cpp (updateCheckUrl) references it unconditionally.
# The updater itself is disabled (BUILD_UPDATER OFF), so this URL is not actually used.
set( APPLICATION_UPDATE_URL "https://geekscloud.com/desktopclient/" )  # TODO: real update server if you enable BUILD_UPDATER (plain set() so it overrides any cached empty value)
set( APPLICATION_HELP_URL   "https://geekscloud.com/soporte" CACHE STRING "URL for the help menu" ) # TODO: confirm support URL

set( APPLICATION_ICON_SET   "SVG" )
# Pre-fill (and optionally lock) the server the client connects to.
# Built-in, ordered list of Geeks Cloud servers (JSON array of {name,url}).
# The client shows these as the only options (ENFORCE ON locks them). With the
# custom auto-failover, the app tries them in order and connects to the first
# one that is reachable. TODO: confirm the real hostnames with your infra.
# Plain set() (not CACHE) so it reliably overrides any previously cached value.
set( APPLICATION_SERVER_URL "[{\"name\":\"Geeks Cloud\",\"url\":\"https://cloud.geeks.com.py\"}]" )
# To add backup servers later for auto-failover, just append more entries, e.g.:
# set( APPLICATION_SERVER_URL "[{\"name\":\"Geeks Cloud\",\"url\":\"https://cloud.geeks.com.py\"},{\"name\":\"Respaldo 2\",\"url\":\"https://cloud2.geeks.com.py\"}]" )
set( APPLICATION_SERVER_URL_ENFORCE ON ) # Lock clients to the servers above
set( APPLICATION_REV_DOMAIN "com.geekscloud.desktopclient" )
set( APPLICATION_REV_DOMAIN_DBUS "desktopclient.geekscloud.com" )
set( DEVELOPMENT_TEAM "" CACHE STRING "Apple Development Team ID" )          # macOS code-signing only
set( APPLICATION_VIRTUALFILE_SUFFIX "geekscloud" CACHE STRING "Virtual file suffix (not including the .)")
set( APPLICATION_OCSP_STAPLING_ENABLED OFF )
set( APPLICATION_FORBID_BAD_SSL OFF )

set( LINUX_PACKAGE_SHORTNAME "geekscloud" )
set( LINUX_APPLICATION_ID "${APPLICATION_REV_DOMAIN}.${LINUX_PACKAGE_SHORTNAME}")

set( THEME_CLASS            "NextcloudTheme" )  # Generic branded theme implementation; driven by the values above
set( WIN_SETUP_BITMAP_PATH  "${CMAKE_SOURCE_DIR}/admin/win/nsi" )

set( MAC_INSTALLER_BACKGROUND_FILE "${CMAKE_SOURCE_DIR}/admin/osx/installer-background.png" CACHE STRING "The MacOSX installer background image")

# set( THEME_INCLUDE          "${OEM_THEME_DIR}/mytheme.h" )
# set( APPLICATION_LICENSE    "${OEM_THEME_DIR}/license.txt )

## Updater options
option( BUILD_UPDATER "Build updater" OFF )   # No Geeks Cloud update server yet; keep OFF until APPLICATION_UPDATE_URL is set

option( WITH_PROVIDERS "Build with providers list" OFF )  # Hide the "get a provider" list (Nextcloud-specific signup)

option( ENFORCE_VIRTUAL_FILES_SYNC_FOLDER "Enforce use of virtual files sync folder when available" OFF )
option( DISABLE_VIRTUAL_FILES_SYNC_FOLDER "Disable use of virtual files sync folder even when available" OFF )

option(ENFORCE_SINGLE_ACCOUNT "Enforce use of a single account in desktop client" OFF)

option( DO_NOT_USE_PROXY "Do not use system wide proxy, instead always do a direct connection to server" OFF )

option( WIN_DISABLE_USERNAME_PREFILL "Do not prefill the Windows user name when creating a new account" OFF )

## Theming options
# Geeks Cloud primary color. Used as a background WITH white text/icons on top,
# so it must have strong contrast against white. Brand purple #6F4899 gives ~7.5:1
# (passes WCAG AA); brand cyan #1CBFD8 would fail (~2:1), so cyan is kept as an accent.
set(NEXTCLOUD_BACKGROUND_COLOR "#6F4899" CACHE STRING "Default Geeks Cloud background color")
set( APPLICATION_WIZARD_HEADER_BACKGROUND_COLOR ${NEXTCLOUD_BACKGROUND_COLOR} CACHE STRING "Hex color of the wizard header background")
set( APPLICATION_WIZARD_HEADER_TITLE_COLOR "#ffffff" CACHE STRING "Hex color of the text in the wizard header")
option( APPLICATION_WIZARD_USE_CUSTOM_LOGO "Use the logo from ':/client/theme/colored/wizard_logo.(png|svg)' else the default application icon is used" ON )

#
## Windows Shell Extensions & MSI - Fresh GUIDs generated for the Geeks Cloud build (do NOT reuse Nextcloud's)
#
if(WIN32)
    # Context Menu
    set( WIN_SHELLEXT_CONTEXT_MENU_GUID      "{1EE2BC0A-1918-495D-9731-08BD9B2C33B9}" )

    # Overlays
    set( WIN_SHELLEXT_OVERLAY_GUID_ERROR     "{E6248C09-D10D-432A-92C8-1FF85561889A}" )
    set( WIN_SHELLEXT_OVERLAY_GUID_OK        "{F8935516-6822-44B5-A148-B4505C31512D}" )
    set( WIN_SHELLEXT_OVERLAY_GUID_OK_SHARED "{C44EE244-AAF8-4ADB-AFDA-375E3B94D5C9}" )
    set( WIN_SHELLEXT_OVERLAY_GUID_SYNC      "{A3CBF703-C43E-4777-BD6A-36A6E226DA7E}" )
    set( WIN_SHELLEXT_OVERLAY_GUID_WARNING   "{AFFD384D-3C20-4D90-86F5-156D6F794A8B}" )

    # MSI Upgrade Code (without brackets)
    set( WIN_MSI_UPGRADE_CODE                "9CD8E1A2-EEC9-475B-9E6B-01625BD072E4" )

    # Windows build options
    option( BUILD_WIN_MSI "Build MSI scripts and helper DLL" OFF )
    option( BUILD_WIN_TOOLS "Build Win32 migration tools" OFF )
endif()

if (APPLE AND CMAKE_OSX_DEPLOYMENT_TARGET VERSION_GREATER_EQUAL 11.0)
    option( BUILD_FILE_PROVIDER_MODULE "Build the macOS virtual files File Provider module" OFF )
endif()
