# A script to tweak a fresh Windows installation, changing settings and editing registry values.
# By @0x4434

Add-Type -AssemblyName PresentationFramework

$ErrorActionPreference = "SilentlyContinue"
$assetsfolder = "./assets"

function Set-Registry-Tweaks {
    # Restore full right click context menu
    New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Force | Set-Item -Value ""
    # Hide search box
    New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -Value 0 -Type Dword -Force
    # Disable widgets service 
    Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\PolicyManager\default\NewsAndInterests\AllowNewsAndInterests -Name value -Value 0 -Type Dword -Force
    New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Dsh -Force | New-ItemProperty -Name AllowNewsAndInterests -Value 0 -Type Dword -Force
    # Hide task view button
    New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowTaskViewButton -Value 0 -Type Dword -Force
    # Hide taskbar widgets button
    New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarDa -Value 0 -Type Dword -Force
    # Align taskbar to left
    New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarAl -Value 0 -Type Dword -Force
    # Hide chat button
    New-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarMn -Value 0 -Type Dword -Force
    # Hide copilot button
    Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowCopilotButton -Value 0 -Type DWord -Force
    # Hide desktop icons
    New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideIcons -Value 1 -Type Dword -Force
	# More pins in start menu
    New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Start_Layout -Value 1 -Type Dword -Force
    # Disable windows defender tray icon
    taskkill.exe /f /im SecurityHealthSystray.exe
    Remove-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run -Name SecurityHealth -Force
    # Disable lockscreen tips
    New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338387Enabled -Value 0 -Type Dword -Force
    New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name RotatingLockScreenOverlayEnabled -Value 0 -Type Dword -Force
    # Disable suggestion notifications
    New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338389Enabled -Value 0 -Type Dword -Force
    New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SoftLandingEnabled -Value 0 -Type Dword -Force
    # Disable suggested content in settings
    New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338393Enabled -Value 0 -Type Dword -Force
    New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-353694Enabled -Value 0 -Type Dword -Force
    New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-353696Enabled -Value 0 -Type Dword -Force
	# Disable welcome experience screen after updates
	New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-310093Enabled -Value 0 -Type Dword -Force
	# Disable 'ways to finish setup' screen
	New-Item HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement -Force | New-ItemProperty -Name ScoobeSystemSettingEnabled -Value 0 -Type Dword -Force
    # Disable sync provider ads
    New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowSyncProviderNotifications -Value 0 -Type Dword -Force
    # Disable silently installed apps
    New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SilentInstalledAppsEnabled -Value 0 -Type Dword -Force
    # Disable microsoft ads
    Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.Suggested -Name Enabled -Value 0 -Type Dword -Force
    # Disable phone link ads
    New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Mobility -Name OptedIn -Value 0 -Type Dword -Force
    # Remove recommended apps from start menu
	New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Start -Name ShowRecentList -Value 0 -Type Dword -Force
	New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Start -Name ShowFrequentList -Value 0 -Type Dword -Force
	New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Start_TrackDocs -Value 0 -Type Dword -Force
	New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Start_TrackProgs -Value 0 -Type Dword -Force
	New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Start_IrisRecommendations -Value 0 -Type Dword -Force
    # Make shortcut arrows transparent
    Copy-Item "$assetsfolder\blank.ico" -Destination "C:\ProgramData\blank.ico"
    New-Item 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons' -Force | New-ItemProperty -Name 29 -Value C:\ProgramData\blank.ico -PropertyType String 
    # Disable ' - Shortcut' suffix
    New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name Link -PropertyType Binary -Value 0x0, 0x0, 0x0, 0x0 -Force
	# Disable search suggestions
	New-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer -Name DisableSearchBoxSuggestions -Value 1 -Type Dword -Force
    # Disable game dvr
    New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR -Force | New-ItemProperty -Name AllowGameDVR -Value 0 -Type Dword -Force
}

function Disable-Telemetry {
    New-Item -Path HKCU:\Software\Policies\Microsoft\Windows\EdgeUI -Force | New-ItemProperty -Name DisableMFUTracking -Value 1 -Type Dword -Force
    Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name AllowTelemetry -Value 0 -Type Dword -Force
}

function Set-Explorer-Tweaks {
    # Hide redundant drive entries in the navigation pane
    Rename-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}' -NewName "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}D"
    # Hide Gallery folder in the navigation pane
    New-Item -Path 'HKCU:\Software\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd  0212c87c}' -Force | New-ItemProperty -Name System.IsPinnedToNameSpaceTree -Type Dword -Force
    # Hide Home folder in the navigation pane
    Rename-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}' -NewName '{f874310e-b6b7-47dc-bc84-b9e6b38f5903}D'
    # Hide OneDrive in the navigation pane
    Set-ItemProperty 'HKCU:\Software\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}' -Name 'System.IsPinnedToNameSpaceTree' -Value 0
    # Hide Quick Access in the navigation pane
    New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name HubMode -Value 1 -Type Dword -Force
    # Show hidden files, folders, and drives
    New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Hidden -Value 1 -Type Dword -Force
    # Show file extensions
    New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -Value 0 -Type Dword -Force
    # Set default explorer view to This PC
    New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Value 1 -Type Dword -Force
    # Show full path in title bar
    New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState -Name FullPath -Value 1 -Type Dword -Force
    # Use compact view 🤮
    #! Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name UseCompactMode -Value 1 -Type Dword -Force
}

function  Set-Cleanup {
    # Enable dark mode
    $message = [System.Windows.MessageBox]::Show('Enable dark mode?', "Window'D", 'YesNo', 'Question')
    if ($message -eq 'Yes') {
        New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value 0 -Type Dword -Force
        New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0 -Type Dword -Force
    }
	# Enable clipboard history
	$message = [System.Windows.MessageBox]::Show('Enable clipboard history?', "Window'D", 'YesNo', 'Question')
	if ($message -eq 'Yes') {
		New-ItemProperty -Path HKCU:\Software\Microsoft\Clipboard -Name EnableClipboardHistory -Value 1 -Type Dword -Force
	}
    # Set region info to United States
    $message = [System.Windows.MessageBox]::Show('Set region info to United States?', "Window'D", 'YesNo', 'Question')
    if ($message -eq 'Yes') {
        Set-WinSystemLocale -SystemLocale en-US
        Set-WinHomeLocation -GeoId 244
        Set-Culture en-US
    }
    # Clear start menu and taskbar
    $message = [System.Windows.MessageBox]::Show('Clear start menu and taskbar?', "Window'D", 'YesNo', 'Question')
    if ($message -eq 'Yes') {
        # Remove pinned start menu items
        $startmenuTemplate = "$assetsfolder\start2.bin"
        $userStartMenu = "$env:LOCALAPPDATA\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\"
        Copy-Item -Path $startmenuTemplate -Destination $userStartMenu -Force
        # Remove pinned taskbar items
        Remove-Item -Path "$env:AppData\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*" -Force 
        Remove-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband -Force -Recurse
    }
}

Set-Registry-Tweaks
Set-Explorer-Tweaks
Disable-Telemetry
Set-Cleanup

taskkill /f /im explorer.exe
Start-Sleep -Seconds 1
explorer.exe
Start-Sleep -Seconds 1

$message = [System.Windows.MessageBox]::Show('Script finished, enjoy your clean Windows!', "Window'D", 'OK', 'Information')
