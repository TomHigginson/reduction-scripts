# reduction-scripts
## XXM-data-reduction
A simple script created for automating the data reduction of XMM observations on typhon. 
The program must be called in the <code>ODF</code> file containing the uncompressed observation files. It creates a new directory in the observation directory called <code>PROC</code> where all the events files are created. It also creates the filtered events files, according to the standard filters for XMM, and the light curve file for each exposure in the observation. 
The program requires that <code>SAS</code>, and therefore <code>HEASOFT</code>, are initialised before it is called. This program is also meant to be run on the typhon server as it is currently hard coded to look for the calibration files there. 
Be aware, it may take several tens of minutes (10-30) to complete the reduction for a large observations. interruptions may require the files created to be deleted before proceeding again. Creating a copy of the ODF directory is recommended when first using the script. 

This program will likely be expanded in the future to give the user more control on starting it, such as defining the location of calibration files, which detectors' reduction is run and what and where to write the output. There will also be summaries of the process progress and output created as it runs.  

## Requirements
In order to be able pass arguments from the command line when running code you need to have ArgParse in your julia environment. This can be added with
```
Pkg.add("ArgParse")
```
either added globally to your julia module or in your environment.

## Implimentation
The reducition code is run as follows:
```
julia XMM-data-reduction.jl --CCF_Path --ODF_Path --OutDir --OutDirName --EM --EP --Filt --LtCrv --timebinsize
```


| Argument    | Default    |
| --- | --- |
|  CCF_Path   |  "/opt/local/XMM/ccf/"   |
|  ODF_Path   |  pwd()   |
|  OutDirName   |  "PROC   |
|  OutDir   |  ".."   |
|  EM   |  true   |
|  EP   |  true   |
|  filt   |  true   |
|  LtCrv   |  true   |
|  timebinsize   |  100  [time in seconds] |
