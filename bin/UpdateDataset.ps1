﻿function update-dataset {
    [CmdletBinding(DefaultParameterSetName='ByUserName')]
    param(
         [Parameter (
            mandatory=$True,
            valueFromPipeline=$True,
            valueFromPipelineByPropertyName=$True)]
         [string] $projectpath,
         [string] $datasetname = "Backup2016.dps"
    )
    $addedval= $false
    $dataset= New-object System.collections.arraylist
    read-Reports -array $dataset -path $projectpath/data/$datasetname
    $files = New-Object System.Collections.ArrayList
    $txtfiles = New-Object System.Collections.ArrayList
    foreach ($file in $dataset."file"){
        if($files -notcontains $file){
            #$report
            [void]$files.add($file)
        }
    }
    $txtlist= dir -recurse $projectpath/dpsreports/*txt
    $txtlist= $txtlist.name
    $val=0
    foreach($txt in $txtlist){
        if($files -notcontains $txt){
            write-verbose "Adding $txt"
            $addedval= $true
            $temp = parseReports2 -option 4 -projectpath $projectpath -file $txt -generateDataset -dataset $datasetname -append -suppress -verbose
            $val += $temp
            
        }
    }
    if(-not $addedVal){
        write-verbose "Dataset is already up-to-date"
        return 0
    }
    if($val -gt 0){
        return 1
    }
}