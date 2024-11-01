#this program works when run in the ODF directory where all the files have already been unziped (could be added)     
#heasoft and ESAS must also be initialised (could be added later)
#assumes on typhon with calibration file location right (could be chaged later)

#Set the variable cwd to be the curent working directory. The 
cwd = pwd()

#Run Cif builder with nescasary enviroment variables pointing to cwd and calibration files 
withenv("SAS_CCFPATH"=>"/opt/local/XMM/ccf/","SAS_ODF"=>cwd)do
    run(`cifbuild`)
end

#Run odf ingest nescasary enviroment variables
withenv("SAS_CCFPATH"=>"/opt/local/XMM/ccf/","SAS_ODF"=>cwd,"SAS_CCF"=>"$cwd/ccf.cif")do
    run(`odfingest`)
end
#Finds the summary file created by odfingest
SumFile = filter(x -> occursin("SUM.SAS", x), readdir())

#Creates and moves to a new processed directory called PROC 
cd("..")
mkdir("PROC")
cd("PROC")

#Runs the emproc data processing 
withenv("SAS_CCFPATH"=>"/opt/local/XMM/ccf/","SAS_ODF"=>"$cwd/"*SumFile[1],"SAS_CCF"=>"$cwd/ccf.cif",)do
    run(`emproc`)
end
#Runs the epproc data processing. Right now assumes both will waning to be run (can change later)
withenv("SAS_CCFPATH"=>"/opt/local/XMM/ccf/","SAS_ODF"=>"$cwd/"*SumFile[1],"SAS_CCF"=>"$cwd/ccf.cif",)do
    run(`epproc`)
end

#Reads in teh event files created and separates them into the posible multiple
#exposures for each detector 
EvFiles = filter(x -> occursin("Evts", x), readdir())
EMOSEvts = filter(x -> occursin("EMOS", x), EvFiles)
EMOS1Evts = filter(x -> occursin("EMOS1", x), EvFiles)
EMOS2Evts = filter(x -> occursin("EMOS2", x), EvFiles)
EPNEvts = filter(x -> occursin("EPN", x), EvFiles)

#Apply the standard filters to each of the files which are different for EMOS and EPN
for n in eachindex(EMOSEvts);
    EMOS=EMOSEvts[n]
    EMOSSplit = split(EMOS,"_")
    EMOSName=EMOSSplit[3]*"_"*EMOSSplit[4]*"_StdFilt.fits"
    run(`evselect table=$EMOS filtertype=expression filteredset=$EMOSName expression='(PATTERN <= 12) && (PI in [200:12000]) && #XMMEA_EM'`)
end

for n in eachindex(EPNEvts);
    EPN=EPNEvts[n]
    EPNSplit = split(EPN,"_")
    EPNName=EPNSplit[3]*"_"*EPNSplit[4]*"_StdFilt.fits"
    run(`evselect table=$EPN filtertype=expression filteredset=$EPNName expression='(PATTERN <= 4)&&(PI in [200:15000])&&#XMMEA_EP&&(FLAG == 0)'`)
end

#creates a light curve for each of the exposures ready or inspection before filtering on time
FiltFiles = filter(x -> occursin("StdFilt", x), readdir())

for n in eachindex(FiltFiles);
    Filt=FiltFiles[n]
    FiltSplit = split(Filt,"_")
    FiltName=FiltSplit[1]*"_"*FiltSplit[2]*"_LtCrv.fits"
    run(`evselect table=$Filt withrateset=Y rateset=$FiltName maketimecolumn=Y timebinsize=100 makeratecolumn=yes`)
end

#printing some information about the observation here may be usefull. Eg observation ID,
    #Loaction, Name?, number of exposures for each instrument and exposure time
#There must be a better way to do this but this sets some conditiononing on if there is more than
#one exposure per observation (currently just for correct text pluralisation)

if length(EMOS1Evts) == 1;
    plur = ""
    pre = "is"
else;
    plur = "s"
    pre = "are"
end
println("There ",pre," ",string(length(EMOS1Evts))," exposure",plur," on MOS1 in this observation")

if length(EMOS2Evts) == 1;
    plur = ""
    pre = "is"
else;
    plur = "s"
    pre = "are"
end
println("There ",pre," ",string(length(EMOS2Evts))," exposure",plur," on MOS2 in this observation")

if length(EPNEvts) == 1;
    plur = ""
    pre = "is"
else;
    plur = "s"
    pre = "are"
end
println("There ",pre," ",string(length(EPNEvts))," exposure",plur," on PN in this observation")
    #If i want to flesh this out eventualy I could look at suggesting a rate or time interval on which to filter
#this is as far as I can go with the general script for data reduction. as the next steps require 
    #decisions to be made about what is suitable
