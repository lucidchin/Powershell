Add-Type -AssemblyName PresentationFramework

#
# Radion Button Events and Enabling/Disabling Controls Example.
# Dower Chin
# 2024-02-16
#


# XAML Data for our UI
# NOTE: I had to remove some of the default data that came with the VS xaml file.
#       I had to remove the following attributes from the Window element:
#           x:Class="WPFStub.MainWindow"    
#           mc:Ignorable="d"
#           xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
#           xmlns:local="clr-namespace:WPFStub"
#       So, taking a raw xaml file from VS and using it in PowerShell will require some cleanup.
#
[xml]$xaml = @"
<Window 
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="RadioButton Triggers" Height="150" Width="300">
    <Grid Width="300">
        <StackPanel x:Name="pnlOptionalItems">
            <Label Content="Optional Items" />
            <StackPanel Orientation="Horizontal">
                <RadioButton GroupName="ShowOptional" Content="Yes" Margin="20,0,0,0" />
                <RadioButton GroupName="ShowOptional" Content="No" Margin="20,0,0,0" IsChecked="True" />
            </StackPanel>
            <StackPanel Orientation="Horizontal" >
                <Label x:Name="lblOption01" Content="Optional Item 1:" IsEnabled="False"/>
                <TextBox x:Name="txtOption01" IsEnabled="False" Text="Something here" Width="120"/>
            </StackPanel>
        </StackPanel>
    </Grid>
</Window>
"@

# Read XAML into our reader variable, and make a Window object out of the data.
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
$Window=[Windows.Markup.XamlReader]::Load( $reader )

#
# Create variables for each named element, adding a prefix to each to make it clearer to use, ex: var_controlname
#
$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach {
    Set-Variable -Name "var_$($_.Name)" -Value $Window.FindName($_.Name) -Scope Script
}

#
# Setup event handler for the radio buttons
#
[System.Windows.RoutedEventHandler]$Script:CheckedEventHandler = {
    #
    # I interrogate the Content of the event source.
    # if you look back at the XAML, you'll see that the Content of the 
    # radio buttons is "Yes" and "No".
    #
    Write-Host $_.source.Content
    if ($_.source.Content -eq "Yes") {
        Write-Host "Enabling..."
        $var_lblOption01.isEnabled = $true
        $var_txtOption01.isEnabled = $true   
    }
    else {
        Write-Host "DIsabling..."
        $var_lblOption01.isEnabled = $false
        $var_txtOption01.isEnabled = $false    
    }
}

#
# Add the event handler to the radio buttons in our Stack Panel, named pnlOptionalItems.
#
$var_pnlOptionalItems.AddHandler([System.Windows.Controls.RadioButton]::CheckedEvent, $CheckedEventHandler)

#
# Display Form
#
$Window.Showdialog() | Out-Null
