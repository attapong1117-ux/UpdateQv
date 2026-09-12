#requires -version 5.1
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Drawing

# ================================================================
# RESHADE FIX FINAL - PREMIUM ALL IN ONE V2
# No sidebar / full dashboard UI
# ================================================================

$ErrorActionPreference = 'Stop'

$FiveM = Join-Path $env:LOCALAPPDATA 'FiveM\FiveM.app\plugins'
$Shaders = Join-Path $FiveM 'reshade-shaders\Shaders'
$Backup = Join-Path $FiveM 'reshade-shaders_BACKUP'
$QVFile = Join-Path $FiveM 'QuantV.addon'

# CitizenFX Settings downloaded from GitHub
$CitizenFXDir = Join-Path $env:APPDATA 'CitizenFX'
$CitizenFXSettingsFile = Join-Path $CitizenFXDir 'gta5_settings.xml'
$CitizenFXBackupDir = Join-Path $CitizenFXDir 'SETTINGS_BACKUP'
$GTASettingsUrl = 'https://raw.githubusercontent.com/attapong1117-ux/UpdateQv/main/gta5_settings.xml'

# Put your GitHub raw folder here.
$GitHubBase = 'https://raw.githubusercontent.com/attapong1117-ux/UpdateQv/main'

$BrokenGroups = @('CShade','Fubax','METEOR','Pumbo','ReShade_HDR_shaders','Rendepth','ZenteonFX')

# --------------------------- XAML -------------------------------
$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Width="1180" Height="760" WindowStartupLocation="CenterScreen"
        WindowStyle="None" ResizeMode="NoResize" Background="#050914"
        AllowsTransparency="True" ShowInTaskbar="True">

    <Window.Resources>
        <LinearGradientBrush x:Key="BG" StartPoint="0,0" EndPoint="1,1">
            <GradientStop Color="#050914" Offset="0"/>
            <GradientStop Color="#08051A" Offset="0.52"/>
            <GradientStop Color="#030812" Offset="1"/>
        </LinearGradientBrush>
        <LinearGradientBrush x:Key="Accent" StartPoint="0,0" EndPoint="1,0">
            <GradientStop Color="#B026FF" Offset="0"/>
            <GradientStop Color="#7C3AED" Offset="0.48"/>
            <GradientStop Color="#00C8FF" Offset="1"/>
        </LinearGradientBrush>
        <SolidColorBrush x:Key="Panel" Color="#091326"/>
        <SolidColorBrush x:Key="Panel2" Color="#0B1830"/>
        <SolidColorBrush x:Key="Border" Color="#173B72"/>
        <SolidColorBrush x:Key="Text" Color="#EAF2FF"/>
        <SolidColorBrush x:Key="Muted" Color="#8CA4C8"/>
        <SolidColorBrush x:Key="Green" Color="#19E88B"/>
        <SolidColorBrush x:Key="Red" Color="#FF4D6D"/>
        <SolidColorBrush x:Key="Cyan" Color="#00D9FF"/>
        <SolidColorBrush x:Key="Purple" Color="#A855F7"/>

        <Style x:Key="Card" TargetType="Border">
            <Setter Property="Background" Value="{StaticResource Panel}"/>
            <Setter Property="BorderBrush" Value="{StaticResource Border}"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="CornerRadius" Value="16"/>
        </Style>

        <Style x:Key="ActionButton" TargetType="Button">
            <Setter Property="Foreground" Value="#EAF2FF"/>
            <Setter Property="FontFamily" Value="Segoe UI Semibold"/>
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="Background" Value="#0A1830"/>
            <Setter Property="BorderBrush" Value="#1554A8"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="16,0"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="bd" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="1" CornerRadius="10">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="bd" Property="Background" Value="#182B50"/>
                                <Setter TargetName="bd" Property="BorderBrush" Value="#7C3AED"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="bd" Property="Background" Value="#27104A"/>
                            </Trigger>
                            <Trigger Property="IsEnabled" Value="False">
                                <Setter TargetName="bd" Property="Opacity" Value="0.45"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="PrimaryButton" TargetType="Button" BasedOn="{StaticResource ActionButton}">
            <Setter Property="Background" Value="{StaticResource Accent}"/>
            <Setter Property="BorderBrush" Value="#8B5CF6"/>
        </Style>

        <Style x:Key="TitleText" TargetType="TextBlock">
            <Setter Property="Foreground" Value="{StaticResource Text}"/>
            <Setter Property="FontFamily" Value="Segoe UI"/>
        </Style>
    </Window.Resources>

    <Border CornerRadius="18" Background="{StaticResource BG}" BorderBrush="#244A8B" BorderThickness="1">
      <Grid>
        <Grid.RowDefinitions>
          <RowDefinition Height="92"/>
          <RowDefinition Height="1"/>
          <RowDefinition Height="*"/>
          <RowDefinition Height="76"/>
        </Grid.RowDefinitions>

        <!-- HEADER -->
        <Grid x:Name="HeaderArea" Grid.Row="0" Margin="28,0,22,0">
          <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="220"/></Grid.ColumnDefinitions>
          <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
            <Border Width="58" Height="58" CornerRadius="15" Background="#120A2A" BorderBrush="#8B5CF6" BorderThickness="1" Margin="0,0,16,0">
              <TextBlock Text="◈" Foreground="#B96CFF" FontSize="34" HorizontalAlignment="Center" VerticalAlignment="Center" FontWeight="Bold"/>
            </Border>
            <StackPanel VerticalAlignment="Center">
              <TextBlock Text="RESHADE FIX FINAL" Foreground="#F3F7FF" FontSize="27" FontWeight="Bold"/>
              <TextBlock Text="PREMIUM FIVE M GAMING UTILITY" Foreground="#6BA6FF" FontSize="11" FontWeight="SemiBold" Margin="1,2,0,0"/>
            </StackPanel>
          </StackPanel>
          <StackPanel Grid.Column="1" Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Center">
            <Border CornerRadius="15" Background="#06281D" BorderBrush="#0D6B49" BorderThickness="1" Padding="18,9" Margin="0,0,18,0">
              <TextBlock x:Name="ReadyBadge" Text="●  READY" Foreground="#19E88B" FontWeight="Bold" FontSize="13"/>
            </Border>
            <Button x:Name="MinBtn" Content="—" Width="34" Height="34" Background="Transparent" BorderThickness="0" Foreground="#88A7D8" FontSize="18"/>
            <Button x:Name="CloseBtn" Content="×" Width="34" Height="34" Background="Transparent" BorderThickness="0" Foreground="#88A7D8" FontSize="24"/>
          </StackPanel>
        </Grid>
        <Border Grid.Row="1" Background="#174D8A"/>

        <!-- BODY -->
        <Grid Grid.Row="2" Margin="28,22,28,10">
          <Grid.RowDefinitions>
            <RowDefinition Height="108"/>
            <RowDefinition Height="198"/>
            <RowDefinition Height="198"/>
            <RowDefinition Height="*"/>
          </Grid.RowDefinitions>
          <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="*"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>

          <!-- STATUS CARDS -->
          <Border Grid.Row="0" Grid.Column="0" Style="{StaticResource Card}" Margin="0,0,9,0">
            <Grid Margin="18">
              <Grid.ColumnDefinitions><ColumnDefinition Width="58"/><ColumnDefinition Width="*"/><ColumnDefinition Width="80"/></Grid.ColumnDefinitions>
              <Border Width="52" Height="52" CornerRadius="13" Background="#170A31" BorderBrush="#6D28D9" BorderThickness="1">
                <TextBlock Text="F" Foreground="#C27AFF" FontSize="29" FontWeight="Bold" HorizontalAlignment="Center" VerticalAlignment="Center"/>
              </Border>
              <StackPanel Grid.Column="1" Margin="12,0,0,0" VerticalAlignment="Center">
                <TextBlock Text="FIVEM" Foreground="#DDE9FF" FontWeight="Bold" FontSize="16"/>
                <TextBlock Text="FiveM.app / plugins" Foreground="#718CB7" FontSize="10" Margin="0,2,0,8"/>
                <TextBlock x:Name="FiveMStatus" Text="● CHECKING" Foreground="#FFD166" FontWeight="Bold" FontSize="12"/>
              </StackPanel>
              <Border Grid.Column="2" Width="70" Height="30" CornerRadius="15" Background="#06182F" BorderBrush="#1654A8" BorderThickness="1" HorizontalAlignment="Right" VerticalAlignment="Bottom">
                <TextBlock Text="v3258" Foreground="#6CA8FF" HorizontalAlignment="Center" VerticalAlignment="Center" FontWeight="Bold" FontSize="11"/>
              </Border>
            </Grid>
          </Border>

          <Border Grid.Row="0" Grid.Column="1" Style="{StaticResource Card}" Margin="9,0">
            <Grid Margin="18">
              <Grid.ColumnDefinitions><ColumnDefinition Width="58"/><ColumnDefinition Width="*"/><ColumnDefinition Width="80"/></Grid.ColumnDefinitions>
              <Border Width="52" Height="52" CornerRadius="13" Background="#061E31" BorderBrush="#0C8FC4" BorderThickness="1">
                <TextBlock Text="◉" Foreground="#28D9FF" FontSize="27" HorizontalAlignment="Center" VerticalAlignment="Center"/>
              </Border>
              <StackPanel Grid.Column="1" Margin="12,0,0,0" VerticalAlignment="Center">
                <TextBlock Text="RESHADE" Foreground="#DDE9FF" FontWeight="Bold" FontSize="16"/>
                <TextBlock Text="Shader environment" Foreground="#718CB7" FontSize="10" Margin="0,2,0,8"/>
                <TextBlock x:Name="ReShadeStatus" Text="● CHECKING" Foreground="#FFD166" FontWeight="Bold" FontSize="12"/>
              </StackPanel>
              <Border Grid.Column="2" Width="70" Height="30" CornerRadius="15" Background="#06182F" BorderBrush="#1654A8" BorderThickness="1" HorizontalAlignment="Right" VerticalAlignment="Bottom">
                <TextBlock Text="v5.9.2" Foreground="#6CA8FF" HorizontalAlignment="Center" VerticalAlignment="Center" FontWeight="Bold" FontSize="11"/>
              </Border>
            </Grid>
          </Border>

          <Border Grid.Row="0" Grid.Column="2" Style="{StaticResource Card}" Margin="9,0,0,0">
            <Grid Margin="18">
              <Grid.ColumnDefinitions><ColumnDefinition Width="58"/><ColumnDefinition Width="*"/><ColumnDefinition Width="80"/></Grid.ColumnDefinitions>
              <Border Width="52" Height="52" CornerRadius="13" Background="#081631" BorderBrush="#1455C0" BorderThickness="1">
                <TextBlock Text="QV" Foreground="#38C9FF" FontSize="20" FontWeight="Bold" HorizontalAlignment="Center" VerticalAlignment="Center"/>
              </Border>
              <StackPanel Grid.Column="1" Margin="12,0,0,0" VerticalAlignment="Center">
                <TextBlock Text="QUANTV" Foreground="#DDE9FF" FontWeight="Bold" FontSize="16"/>
                <TextBlock Text="QuantV.addon" Foreground="#718CB7" FontSize="10" Margin="0,2,0,8"/>
                <TextBlock x:Name="QVStatus" Text="● CHECKING" Foreground="#FFD166" FontWeight="Bold" FontSize="12"/>
              </StackPanel>
              <Border Grid.Column="2" Width="70" Height="30" CornerRadius="15" Background="#06182F" BorderBrush="#1654A8" BorderThickness="1" HorizontalAlignment="Right" VerticalAlignment="Bottom">
                <TextBlock Text="v2.0" Foreground="#6CA8FF" HorizontalAlignment="Center" VerticalAlignment="Center" FontWeight="Bold" FontSize="11"/>
              </Border>
            </Grid>
          </Border>

          <!-- REPAIR -->
          <Border Grid.Row="1" Grid.Column="0" Grid.ColumnSpan="2" Style="{StaticResource Card}" Margin="0,12,9,0">
            <Grid Margin="22">
              <TextBlock Text="✦  RESHADE SHADER REPAIR" Foreground="#DCEAFF" FontWeight="Bold" FontSize="17"/>
              <TextBlock Text="Backup broken shader groups and repair the shader environment." Foreground="#7793BF" FontSize="11" Margin="0,30,0,0"/>
              <StackPanel Orientation="Horizontal" VerticalAlignment="Bottom" Margin="0,0,0,0">
                <Button x:Name="FixBtn" Style="{StaticResource PrimaryButton}" Width="205" Height="50" Content="🔧   FIX SHADERS" Margin="0,0,12,0"/>
                <Button x:Name="RestoreBtn" Style="{StaticResource ActionButton}" Width="155" Height="50" Content="⟳   RESTORE" Margin="0,0,12,0"/>
                <Button x:Name="OpenBtn" Style="{StaticResource ActionButton}" Width="180" Height="50" Content="▣   OPEN FOLDER"/>
              </StackPanel>
            </Grid>
          </Border>

          <!-- SETTINGS -->
          <Border Grid.Row="1" Grid.Column="2" Style="{StaticResource Card}" Margin="9,12,0,0">
            <Grid Margin="20">
              <TextBlock Text="☁  SETTINGS PACK (GitHub)" Foreground="#DCEAFF" FontWeight="Bold" FontSize="15"/>
              <TextBlock Text="Download and apply CitizenFX settings from GitHub." Foreground="#7793BF" FontSize="10" Margin="0,28,0,0"/>
              <StackPanel Orientation="Horizontal" Margin="0,62,0,0" VerticalAlignment="Top">
                <Button x:Name="LoadBtn" Style="{StaticResource PrimaryButton}" Width="165" Height="48" Content="⇩   LOAD SETTINGS" Margin="0,0,8,0"/>
                <Button x:Name="DeleteSettingsBtn" Style="{StaticResource ActionButton}" Width="105" Height="48" Content="✕  DELETE"/>
                <Button x:Name="ClearCacheBtn" Style="{StaticResource ActionButton}" Width="145" Height="48" Content="⌫  CLEAR CACHE" Margin="8,0,0,0"/>
              </StackPanel>
              <StackPanel Margin="10,120,0,0">
                <TextBlock Text="✓  Backup existing" Foreground="#5FCBFF" FontSize="10"/>
                <TextBlock Text="✓  Download + verify gta5_settings.xml" Foreground="#5FCBFF" FontSize="10" Margin="0,5,0,0"/>
                <TextBlock Text="✓  Install &amp; Apply" Foreground="#5FCBFF" FontSize="10" Margin="0,5,0,0"/>
              </StackPanel>
            </Grid>
          </Border>

          <!-- QUANTV -->
          <Border Grid.Row="2" Grid.Column="0" Grid.ColumnSpan="2" Style="{StaticResource Card}" Margin="0,12,9,0">
            <Grid Margin="22">
              <TextBlock Text="◈  QUANTV ADDON" Foreground="#DCEAFF" FontWeight="Bold" FontSize="17"/>
              <TextBlock Text="Download or remove QuantV.addon" Foreground="#7793BF" FontSize="11" Margin="0,30,0,0"/>
              <StackPanel Orientation="Horizontal" VerticalAlignment="Bottom">
                <Button x:Name="DownloadQVBtn" Style="{StaticResource PrimaryButton}" Width="190" Height="50" Content="☁   DOWNLOAD" Margin="0,0,12,0"/>
                <Button x:Name="DeleteQVBtn" Style="{StaticResource ActionButton}" Width="160" Height="50" Content="▣   DELETE"/>
              </StackPanel>
              <TextBlock Text="QuantV" Foreground="#8B5CF6" FontSize="35" FontWeight="Bold" HorizontalAlignment="Right" VerticalAlignment="Bottom" Opacity="0.12" Margin="0,0,25,5"/>
            </Grid>
          </Border>

          <!-- LOG -->
          <Border Grid.Row="2" Grid.Column="2" Style="{StaticResource Card}" Margin="9,12,0,0">
            <Grid Margin="18">
              <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="100"/></Grid.ColumnDefinitions>
              <TextBlock Text="▤  ACTIVITY LOG" Foreground="#DCEAFF" FontWeight="Bold" FontSize="14"/>
              <Button x:Name="ClearLogBtn" Grid.Column="1" Content="CLEAR LOG" Height="30" Background="#0B1025" BorderBrush="#4C1D95" Foreground="#B98CFF" FontSize="9"/>
              <RichTextBox x:Name="LogBox" Grid.Row="1" Grid.ColumnSpan="2" Margin="0,40,0,0" Background="#030812" BorderBrush="#12335F" Foreground="#9CC7FF" FontFamily="Consolas" FontSize="10" IsReadOnly="True" VerticalScrollBarVisibility="Auto"/>
            </Grid>
          </Border>

          <!-- SYSTEM -->
          <Border Grid.Row="3" Grid.Column="0" Grid.ColumnSpan="3" Style="{StaticResource Card}" Margin="0,12,0,0">
            <Grid Margin="20">
              <Grid.ColumnDefinitions><ColumnDefinition Width="2.2*"/><ColumnDefinition Width="1*"/><ColumnDefinition Width="1*"/><ColumnDefinition Width="1*"/><ColumnDefinition Width="1*"/></Grid.ColumnDefinitions>
              <StackPanel VerticalAlignment="Center" Margin="0,0,25,0">
                <Grid><TextBlock Text="SYSTEM STATUS" Foreground="#8EA9D0" FontWeight="Bold" FontSize="10"/><TextBlock x:Name="ProgressText" Text="100%" HorizontalAlignment="Right" Foreground="#75B8FF" FontSize="10"/></Grid>
                <ProgressBar x:Name="ProgressBar" Height="10" Margin="0,11,0,0" Minimum="0" Maximum="100" Value="100" Background="#081326" Foreground="#8B5CF6" BorderThickness="0"/>
              </StackPanel>
              <Border Grid.Column="1" BorderBrush="#17345F" BorderThickness="1,0,0,0" Padding="20,0,0,0">
                <StackPanel VerticalAlignment="Center"><TextBlock Text="CPU" Foreground="#5D8DCC" FontWeight="Bold" FontSize="10"/><TextBlock x:Name="CpuText" Text="Intel Core i5-13400F" Foreground="#D9E7FF" FontSize="10" Margin="0,4,0,0"/><TextBlock Text="~3.4 GHz" Foreground="#728CB5" FontSize="9"/></StackPanel>
              </Border>
              <Border Grid.Column="2" BorderBrush="#17345F" BorderThickness="1,0,0,0" Padding="20,0,0,0">
                <StackPanel VerticalAlignment="Center"><TextBlock Text="GPU" Foreground="#5D8DCC" FontWeight="Bold" FontSize="10"/><TextBlock x:Name="GpuText" Text="NVIDIA RTX 4060" Foreground="#D9E7FF" FontSize="10" Margin="0,4,0,0"/><TextBlock Text="8 GB" Foreground="#728CB5" FontSize="9"/></StackPanel>
              </Border>
              <Border Grid.Column="3" BorderBrush="#17345F" BorderThickness="1,0,0,0" Padding="20,0,0,0">
                <StackPanel VerticalAlignment="Center"><TextBlock Text="RAM" Foreground="#5D8DCC" FontWeight="Bold" FontSize="10"/><TextBlock Text="32 GB DDR4" Foreground="#D9E7FF" FontSize="10" Margin="0,4,0,0"/><TextBlock Text="3200 MHz" Foreground="#728CB5" FontSize="9"/></StackPanel>
              </Border>
              <Border Grid.Column="4" BorderBrush="#17345F" BorderThickness="1,0,0,0" Padding="20,0,0,0">
                <StackPanel VerticalAlignment="Center"><TextBlock Text="OS" Foreground="#5D8DCC" FontWeight="Bold" FontSize="10"/><TextBlock Text="Windows 10" Foreground="#D9E7FF" FontSize="10" Margin="0,4,0,0"/><TextBlock Text="Gaming PC" Foreground="#728CB5" FontSize="9"/></StackPanel>
              </Border>
            </Grid>
          </Border>
        </Grid>

        <!-- FOOTER -->
        <Grid Grid.Row="3" Margin="30,0,30,0">
          <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
            <TextBlock Text="♛  PREMIUM EDITION" Foreground="#D36CFF" FontWeight="Bold" FontSize="11"/>
            <TextBlock Text="   v1.0.0   •   FIVE M UTILITY" Foreground="#6384B6" FontSize="10" VerticalAlignment="Center"/>
          </StackPanel>
          <TextBlock Text="Better FPS   •   Smoother Gameplay   •   Safe Settings" HorizontalAlignment="Right" VerticalAlignment="Center" Foreground="#8061B5" FontSize="10" FontStyle="Italic"/>
        </Grid>
      </Grid>
    </Border>
</Window>
'@

$reader = New-Object System.Xml.XmlNodeReader ([xml]$xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

# ----------------------- Controls -------------------------------
$FiveMStatus = $window.FindName('FiveMStatus')
$ReShadeStatus = $window.FindName('ReShadeStatus')
$QVStatus = $window.FindName('QVStatus')
$ReadyBadge = $window.FindName('ReadyBadge')
$ProgressBar = $window.FindName('ProgressBar')
$ProgressText = $window.FindName('ProgressText')
$LogBox = $window.FindName('LogBox')
$FixBtn = $window.FindName('FixBtn')
$RestoreBtn = $window.FindName('RestoreBtn')
$OpenBtn = $window.FindName('OpenBtn')
$LoadBtn = $window.FindName('LoadBtn')
$DeleteSettingsBtn = $window.FindName('DeleteSettingsBtn')
$ClearCacheBtn = $window.FindName('ClearCacheBtn')
$DownloadQVBtn = $window.FindName('DownloadQVBtn')
$DeleteQVBtn = $window.FindName('DeleteQVBtn')
$ClearLogBtn = $window.FindName('ClearLogBtn')
$MinBtn = $window.FindName('MinBtn')
$CloseBtn = $window.FindName('CloseBtn')
$HeaderArea = $window.FindName('HeaderArea')

function Set-Status([string]$Text,[string]$Color='Green') {
    $ReadyBadge.Text = "●  $Text"
    switch($Color) {
        'Green'  { $ReadyBadge.Foreground = [Windows.Media.Brushes]::LimeGreen }
        'Yellow' { $ReadyBadge.Foreground = [Windows.Media.Brushes]::Gold }
        'Red'    { $ReadyBadge.Foreground = [Windows.Media.Brushes]::Tomato }
        default  { $ReadyBadge.Foreground = [Windows.Media.Brushes]::White }
    }
}

function Set-Progress([int]$Value) {
    $v = [Math]::Max(0,[Math]::Min(100,$Value))
    $ProgressBar.Value = $v
    $ProgressText.Text = "$v%"
    [System.Windows.Threading.Dispatcher]::CurrentDispatcher.Invoke([action]{},[System.Windows.Threading.DispatcherPriority]::Render)
}

function Log([string]$Text,[string]$Color='Normal') {
    $range = New-Object System.Windows.Documents.TextRange($LogBox.Document.ContentEnd,$LogBox.Document.ContentEnd)
    $range.Text = "[$(Get-Date -Format 'HH:mm:ss')] $Text`r`n"
    switch($Color) {
        'Good' { $range.ApplyPropertyValue([System.Windows.Documents.TextElement]::ForegroundProperty,[Windows.Media.Brushes]::LimeGreen) }
        'Warn' { $range.ApplyPropertyValue([System.Windows.Documents.TextElement]::ForegroundProperty,[Windows.Media.Brushes]::Gold) }
        'Bad'  { $range.ApplyPropertyValue([System.Windows.Documents.TextElement]::ForegroundProperty,[Windows.Media.Brushes]::Tomato) }
        'Blue' { $range.ApplyPropertyValue([System.Windows.Documents.TextElement]::ForegroundProperty,[Windows.Media.Brushes]::DeepSkyBlue) }
        default { $range.ApplyPropertyValue([System.Windows.Documents.TextElement]::ForegroundProperty,[Windows.Media.Brushes]::LightSteelBlue) }
    }
    $LogBox.ScrollToEnd()
}

function Refresh-Status {
    if(Test-Path $FiveM) {
        $FiveMStatus.Text = '●  DETECTED'; $FiveMStatus.Foreground = [Windows.Media.Brushes]::LimeGreen
    } else {
        $FiveMStatus.Text = '●  NOT FOUND'; $FiveMStatus.Foreground = [Windows.Media.Brushes]::Tomato
    }

    $ini = Join-Path $FiveM 'ReShade.ini'
    $log = Join-Path $FiveM 'ReShade.log'
    if((Test-Path $ini) -or (Test-Path $log)) {
        $ReShadeStatus.Text = '●  DETECTED'; $ReShadeStatus.Foreground = [Windows.Media.Brushes]::LimeGreen
    } else {
        $ReShadeStatus.Text = '●  NOT FOUND'; $ReShadeStatus.Foreground = [Windows.Media.Brushes]::Tomato
    }

    if(Test-Path $QVFile) {
        $QVStatus.Text = '●  INSTALLED'; $QVStatus.Foreground = [Windows.Media.Brushes]::LimeGreen
    } else {
        $QVStatus.Text = '●  NOT INSTALLED'; $QVStatus.Foreground = [Windows.Media.Brushes]::Tomato
    }
}

function Fix-Shaders {
    try {
        Set-Status 'FIXING' 'Yellow'; Set-Progress 5
        Log 'Starting ReShade shader repair...' 'Blue'
        if(!(Test-Path $Shaders)) { throw "Shader folder not found: $Shaders" }
        if(!(Test-Path $Backup)) { New-Item -ItemType Directory -Path $Backup -Force | Out-Null; Log 'Backup directory created.' 'Blue' }
        $total = $BrokenGroups.Count; $i = 0; $found = 0
        foreach($group in $BrokenGroups) {
            $i++
            $src = Join-Path $Shaders $group
            $dst = Join-Path $Backup $group
            if(Test-Path $src) {
                if(Test-Path $dst) { Remove-Item $dst -Recurse -Force }
                Move-Item $src $dst -Force
                $found++
                Log "Moved $group to backup." 'Good'
            }
            Set-Progress ([int](($i/$total)*90))
        }
        Set-Progress 100; Set-Status 'COMPLETE' 'Green'
        if($found -eq 0) { Log 'No targeted broken shader groups found.' 'Warn' }
        else { Log "Repair completed. $found shader group(s) processed." 'Good' }
        Refresh-Status
    } catch { Log "ERROR: $($_.Exception.Message)" 'Bad'; Set-Status 'ERROR' 'Red'; Set-Progress 0 }
}

function Restore-Shaders {
    try {
        Set-Status 'RESTORING' 'Yellow'; Set-Progress 5; Log 'Starting shader restore...' 'Blue'
        if(!(Test-Path $Backup)) { Log 'Backup directory not found.' 'Warn'; Set-Status 'READY'; Set-Progress 0; return }
        $items = @(Get-ChildItem $Backup -Directory -ErrorAction SilentlyContinue)
        if($items.Count -eq 0) { Log 'No shader backups found.' 'Warn'; Set-Status 'READY'; Set-Progress 0; return }
        $i=0
        foreach($item in $items) {
            $i++; $dst=Join-Path $Shaders $item.Name
            if(Test-Path $dst) { Log "$($item.Name) already exists. Skipped." 'Warn' }
            else { Move-Item $item.FullName $dst -Force; Log "Restored $($item.Name)." 'Good' }
            Set-Progress ([int](($i/$items.Count)*100))
        }
        Set-Status 'RESTORED' 'Green'; Log 'Restore completed.' 'Good'; Refresh-Status
    } catch { Log "ERROR: $($_.Exception.Message)" 'Bad'; Set-Status 'ERROR' 'Red'; Set-Progress 0 }
}

function Download-QV {
    try {
        Set-Status 'DOWNLOADING' 'Yellow'; Set-Progress 5; Log 'Downloading QuantV addon...' 'Blue'
        if(!(Test-Path $FiveM)) { New-Item -ItemType Directory -Path $FiveM -Force | Out-Null }
        $url = 'https://raw.githubusercontent.com/attapong1117-ux/UpdateQv/main/QuantV.addon'
        $tmp = Join-Path $env:TEMP 'QuantV.addon.download.tmp'
        if(Test-Path $tmp) { Remove-Item $tmp -Force }
        Invoke-WebRequest -Uri $url -OutFile $tmp -UseBasicParsing -ErrorAction Stop
        Set-Progress 65
        if((Get-Item $tmp).Length -lt 1000) { throw 'Downloaded file is unexpectedly small.' }
        if(Test-Path $QVFile) {
            $old = "$QVFile.backup_$(Get-Date -Format yyyyMMdd_HHmmss)"
            Move-Item $QVFile $old -Force
            Log 'Existing QuantV addon backed up.' 'Warn'
        }
        Move-Item $tmp $QVFile -Force
        Set-Progress 100; Set-Status 'COMPLETE' 'Green'; Log 'QuantV.addon installed successfully.' 'Good'; Refresh-Status
    } catch { Log "QuantV ERROR: $($_.Exception.Message)" 'Bad'; Set-Status 'ERROR' 'Red'; Set-Progress 0 }
}

function Clear-CitizenFXCache {
    try {
        Log 'Clearing safe CitizenFX cache...' 'Blue'
        Set-Status 'CLEARING CACHE' 'Warn'
        Set-Progress 10

        if(!(Test-Path $CitizenFXDir)) {
            Log 'CitizenFX folder not found.' 'Warn'
            Set-Status 'READY' 'Good'
            Set-Progress 0
            return
        }

        # Never delete cache while FiveM is running.
        $running = @(Get-Process -Name 'FiveM*' -ErrorAction SilentlyContinue)
        if($running.Count -gt 0) {
            [System.Windows.MessageBox]::Show(
                "FiveM is currently running.`n`nPlease close FiveM, then press CLEAR CACHE again.",
                'FiveM is running',
                'OK',
                'Information'
            ) | Out-Null
            Log 'FiveM is running - cache cleanup skipped.' 'Warn'
            Set-Status 'READY' 'Good'
            Set-Progress 0
            return
        }

        Set-Progress 25

        # Only remove known cache folders; preserve settings, profiles and other user data.
        $cacheNames = @('cache','server-cache','server-cache-priv','nui-storage','crashes')
        foreach($name in $cacheNames) {
            $p = Join-Path $CitizenFXDir $name
            if(Test-Path $p) {
                Remove-Item $p -Recurse -Force -ErrorAction SilentlyContinue
                Log "Cleared $name" 'Good'
            } else {
                Log "$name not found - skipped" 'Muted'
            }
        }

        Set-Progress 100
        Set-Status 'CACHE CLEARED' 'Good'
        Log 'CitizenFX cache cleared. User settings were preserved.' 'Good'
    } catch {
        Log "CACHE ERROR: $($_.Exception.Message)" 'Bad'
        Set-Status 'ERROR' 'Bad'
        Set-Progress 0
    }
}

function Delete-GitHubSettings {
    try {
        $answer = [System.Windows.MessageBox]::Show(
            'Delete the installed gta5_settings.xml from CitizenFX and restore the latest backup if available?',
            'Delete Settings',
            'YesNo',
            'Warning'
        )
        if($answer -ne 'Yes') { return }

        Set-Status 'DELETING SETTINGS' 'Warn'
        Set-Progress 10
        Log 'Removing CitizenFX settings...' 'Blue'

        if(Test-Path $CitizenFXSettingsFile) {
            Remove-Item $CitizenFXSettingsFile -Force
            Log 'gta5_settings.xml removed from CitizenFX.' 'Good'
        } else {
            Log 'gta5_settings.xml not found.' 'Warn'
        }

        $latest = $null
        if(Test-Path $CitizenFXBackupDir) {
            $latest = Get-ChildItem $CitizenFXBackupDir -Filter 'gta5_settings.xml.backup_*' -File -ErrorAction SilentlyContinue |
                Sort-Object LastWriteTime -Descending | Select-Object -First 1
        }

        if($latest) {
            Copy-Item $latest.FullName $CitizenFXSettingsFile -Force
            Log 'Latest CitizenFX settings backup restored.' 'Good'
        } else {
            Log 'No CitizenFX settings backup found.' 'Warn'
        }

        Set-Progress 100
        Set-Status 'READY' 'Good'
    } catch {
        Log "DELETE ERROR: $($_.Exception.Message)" 'Bad'
        Set-Status 'ERROR' 'Bad'
        Set-Progress 0
    }
}

function Load-GitHubSettings {
    try {
        Set-Status 'DOWNLOADING SETTINGS' 'Warn'
        Set-Progress 5
        Log 'Connecting to GitHub settings...' 'Blue'

        if(!(Test-Path $CitizenFXDir)) {
            New-Item -ItemType Directory -Path $CitizenFXDir -Force | Out-Null
        }
        if(!(Test-Path $CitizenFXBackupDir)) {
            New-Item -ItemType Directory -Path $CitizenFXBackupDir -Force | Out-Null
        }

        $tmp = Join-Path $env:TEMP 'gta5_settings.download.tmp'
        if(Test-Path $tmp) { Remove-Item $tmp -Force -ErrorAction SilentlyContinue }

        Set-Progress 20
        Log 'Downloading gta5_settings.xml...' 'Blue'
        Invoke-WebRequest -Uri $GTASettingsUrl -OutFile $tmp -UseBasicParsing -ErrorAction Stop

        if(!(Test-Path $tmp) -or (Get-Item $tmp).Length -lt 20) {
            throw 'Downloaded settings file is empty or invalid.'
        }

        # Validate XML before touching the existing file.
        $xmlText = Get-Content $tmp -Raw -ErrorAction Stop
        $null = [xml]$xmlText
        Set-Progress 45

        if(Test-Path $CitizenFXSettingsFile) {
            $backup = Join-Path $CitizenFXBackupDir ("gta5_settings.xml.backup_$(Get-Date -Format yyyyMMdd_HHmmss)")
            Copy-Item $CitizenFXSettingsFile $backup -Force
            Log 'Current CitizenFX settings backed up.' 'Warn'
        }

        Copy-Item $tmp $CitizenFXSettingsFile -Force
        Remove-Item $tmp -Force -ErrorAction SilentlyContinue
        Set-Progress 80

        # Verify installed file.
        $null = [xml](Get-Content $CitizenFXSettingsFile -Raw -ErrorAction Stop)
        Set-Progress 100
        Set-Status 'SETTINGS INSTALLED' 'Good'
        Log 'gta5_settings.xml installed and verified in CitizenFX.' 'Good'

        # Safe automatic CitizenFX cache cleanup after a successful settings install.
        Log 'Running safe CitizenFX cache cleanup...' 'Blue'
        Clear-CitizenFXCache

        Log 'Restart FiveM/GTA V to apply the settings.' 'Warn'
    } catch {
        Log "SETTINGS ERROR: $($_.Exception.Message)" 'Bad'
        Set-Status 'ERROR' 'Bad'
        Set-Progress 0
        if(Test-Path (Join-Path $env:TEMP 'gta5_settings.download.tmp')) {
            Remove-Item (Join-Path $env:TEMP 'gta5_settings.download.tmp') -Force -ErrorAction SilentlyContinue
        }
    }
}

$FixBtn.Add_Click({ Fix-Shaders })
$RestoreBtn.Add_Click({ Restore-Shaders })
$OpenBtn.Add_Click({
    try {
        if(Test-Path $FiveM) { Start-Process explorer.exe -ArgumentList ('"{0}"' -f $FiveM) }
        else { Log 'FiveM plugins folder not found.' 'Warn' }
    } catch { Log "OPEN ERROR: $($_.Exception.Message)" 'Bad' }
})
$LoadBtn.Add_Click({ Load-GitHubSettings })
$DeleteSettingsBtn.Add_Click({ Delete-GitHubSettings })
$ClearCacheBtn.Add_Click({ Clear-CitizenFXCache })
$DownloadQVBtn.Add_Click({ Download-QV })
$DeleteQVBtn.Add_Click({
    try {
        if(!(Test-Path $QVFile)) { Log 'QuantV.addon is not installed.' 'Warn'; return }
        $answer=[System.Windows.MessageBox]::Show('Delete QuantV.addon?','Confirm Delete','YesNo','Warning')
        if($answer -eq 'Yes'){Remove-Item $QVFile -Force;Log 'QuantV.addon deleted.' 'Good';Refresh-Status;Set-Status 'READY';Set-Progress 100}
    } catch { Log "Delete ERROR: $($_.Exception.Message)" 'Bad' }
})
$ClearLogBtn.Add_Click({ $LogBox.Document.Blocks.Clear(); Log 'Log cleared.' 'Blue' })
$MinBtn.Add_Click({ $window.WindowState='Minimized' })
$CloseBtn.Add_Click({ $window.Close() })
$HeaderArea.Add_MouseLeftButtonDown({ param($s,$e); if($e.ButtonState -eq 'Pressed'){ $window.DragMove() } })

# Startup
Refresh-Status
Log 'Initializing Premium Gaming Utility...' 'Blue'
Log 'Scanning FiveM environment...' 'Normal'
if(Test-Path $FiveM){Log 'FiveM plugins detected.' 'Good'}else{Log 'FiveM plugins folder not found.' 'Bad'}
if(Test-Path (Join-Path $FiveM 'ReShade.log')){Log 'ReShade log detected.' 'Good'}else{Log 'ReShade log not detected.' 'Warn'}
if(Test-Path $QVFile){Log 'QuantV.addon detected.' 'Good'}else{Log 'QuantV.addon not installed.' 'Warn'}
Set-Progress 100
Set-Status 'READY' 'Green'

[void]$window.ShowDialog()
