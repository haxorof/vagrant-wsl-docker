$input = @(Get-Content $PSScriptRoot\docker.params)
# echo "INPUT: $input"
$processedargs = @()
Foreach ($i in $input) {
    if ($i -like '*:\*') {
        # Assume Windows path is detected and do as simplistic convertion, similar to wslpath.
        # DOES NOT HANDLE SPACES IN PATHS!
        $tmpvar = $($i -replace '(\w)\:\\','/mnt/$1/')
        $tmpvar = $($tmpvar -replace '\\','/')
        $processedargs += $tmpvar.Substring(0,$tmpvar.Length-1)
    } else {
        $processedargs += $i.Substring(0,$i.Length-1)
    }
}
# echo "OUTPUT: $processedargs"
wsl docker @processedargs
