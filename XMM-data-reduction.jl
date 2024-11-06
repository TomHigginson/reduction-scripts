

include("XMM-data-reduction-function.jl") 

run_reduction(
    #CCF_Path = "/opt/local/XMM/ccf/", #path to calibration files
    #ODF_Path = pwd(),                 #path to ODF directory
    #OutDir = "..",                    #location he output directory is created
    #OutDirName = "PROC",              #name of output directory
    #EM = true,                        #true or false as to if emproc command is run to process th files for the MOS instruments
    #EP = true,                        #true or false as to if epproc command is run to process th files for the PN instrument
    #Filt = true,                      #true or false as to if the standard filters are aplied to the output events file
    #LtCrv = true,                     #true or false as to if a light curve is created from the output events file
    #timebinsize = 100                 #bin size for the output light curve if created
)