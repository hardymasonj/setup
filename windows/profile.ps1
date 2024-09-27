Import-Module PSReadLine

# Ensure PATH variable is loaded with both machine and user defined path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Searching for commands with up/down arrow is really handy.  The
# option "moves to end" is useful if you want the cursor at the end
# of the line while cycling through history like it does w/o searching,
# without that option, the cursor will remain at the position it was
# when you used up arrow, which can be useful if you forget the exact
# string you started the search on.
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# Tabbing to be like zsh rather than bash
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Jump words
Set-PSReadlineKeyHandler -Key Ctrl+LeftArrow BackwardWord
Set-PSReadlineKeyHandler -Key Ctrl+RightArrow ForwardWord

# Wrap demanding commands in an idle event to prevent blocking the prompt
$null = Register-EngineEvent -SourceIdentifier 'PowerShell.OnIdle' -MaxTriggerCount 1 -Action {
    # Configure fzf for reverse history search
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}

#region prompt
# Copy of the robbyrussell theme from Oh My Posh (https://ohmyposh.dev)
function Prompt
{
    $ArrowIcon = [System.Convert]::toInt32("279C",16)
    $ArrowIcon = [System.Char]::ConvertFromUtf32($ArrowIcon)
    $XmarkIcon = [System.Convert]::toInt32("2717",16)
    $XmarkIcon = [System.Char]::ConvertFromUtf32($XmarkIcon)

    if ($?)
    {
        Write-Host $ArrowIcon -NoNewline -ForegroundColor Green
    } else
    {
        Write-Host $ArrowIcon -NoNewline -ForegroundColor Red
    }

    if ($(Split-Path -Path $pwd -Leaf) -eq $(Split-Path -Path $Home -Leaf))
    {
        Write-Host ("  ~") -NoNewline -ForegroundColor Cyan
    } else
    {
        Write-Host ("  " + $(Split-Path -Path $pwd -Leaf)) -NoNewline -ForegroundColor Cyan
    }

    $gitStatus = Get-GitStatus
    if ($gitStatus)
    {
        Write-Host " git:(" -NoNewline -ForegroundColor Blue
        Write-Host "$($gitStatus.Branch)" -NoNewline -ForegroundColor Red
        Write-Host ")" -NoNewline -ForegroundColor Blue

        if ($gitStatus.Working.Length -gt 0)
        {
            Write-Host " $XmarkIcon" -NoNewline -ForegroundColor Yellow
        }
    }

    return " "
}
#endregion

Set-Alias -Name 'btop' btop4win

#region directory movement aliases
function __up_one_dir
{ Set-Location ..; 
}
function __up_two_dir
{ Set-Location ../..; 
}
function __up_three_dir
{ Set-Location ../../..; 
}
function __up_four_dir
{ Set-Location ../../../..; 
}

Set-Alias -Name '..' __up_one_dir
Set-Alias -Name '...' __up_two_dir
Set-Alias -Name '....' __up_three_dir
Set-Alias -Name '.....' __up_four_dir
#endregion

#region eza aliases
function __ls
{ eza -F -gh --group-directories-first --git --git-ignore --icons --color-scale all --hyperlink $args; 
}
function __ll
{ & '__ls' -l @args; 
}
function __la
{ & '__ll' -a @args; 
}
function __l
{ & '__la' -a @args; 
}

Set-Alias -Name 'ls' __ls
Set-Alias -Name 'll' __ll
Set-Alias -Name 'la' __la
Set-Alias -Name 'l'  __l
#endregion

#region git aliases
function __git_add
{ git add $args; 
}
function __git_status
{ git status $args; 
}
function __git_log
{ git log  --abbrev-commit --pretty="%C(red bold)%h%Creset | %C(yellow bold)%d%Creset %s %Cgreen(%cr)%Creset [%an]"; 
}
function __git_log_graph
{ git log --graph  --abbrev-commit --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'; 
}

Set-Alias -Name 'ga' __git_add
Set-Alias -Name 'gst' __git_status
Set-Alias -Name 'gll' __git_log
Set-Alias -Name 'glg' __git_log_graph
#endregion

#region bash-like aliases
function __which($name)
{
    Try
    {
        $info = Get-Command -ErrorAction Stop $name
        $info.Definition
    } Catch
    {
        Write-Host "which: $name not found" -ForegroundColor Red
    }
}

Set-Alias -Name 'which' __which
Set-Alias -Name 'touch' New-Item
#endregion

function mkrs([string] $name)
{
    $ts = get-date -Format 'yyyyMMddHHmm'
    $now = get-date -Format 'yyyy-MM-dd'
    $file = "$ts-$name.sql"

    New-Item $file
    Add-Content -Path $file -Value @"
-- @Date:        $now
-- @Author:      $env:USERNAME
-- @Jira:        TODO
-- @Description: TODO
"@
}

Set-Alias -Name 'tf' terraform
