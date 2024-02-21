Add-Type -AssemblyName PresentationFramework

#
# Custom App Icon Example.
# This script demonstrates how to set a custom icon for your PowerShell GUI application.
#
# Dower Chin
# 2024-02-21
#

#
# XAML Data for our UI
#
[xml]$xaml = @"
<Window 
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="RadioButton Triggers" Height="150" Width="300">
    <Grid Width="300">
        <StackPanel HorizontalAlignment="Center" VerticalAlignment="Center">
            <Label Content="Custom App Icon Demo" />
        </StackPanel>
    </Grid>
</Window>
"@

# Read XAML into our reader variable, and make a Window object out of the data.
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
$Window=[Windows.Markup.XamlReader]::Load( $reader )

#
# Get Local Script Path
#
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

#
# Append our path and image filename together
#
$myIconPath = Join-Path $scriptPath 'logo.ico'

#
# Add a Loaded Event to load our custom icon and set the Icon property of our Window.
#
$Window.add_Loaded({
    $Window.Icon = $myIconPath
})

#
# Display Form
#
$Window.Showdialog() | Out-Null
