using SpectralFitting, Plots, XSPECModels

DATADIR = "/data/typhon2/DariusM/XMM_Data/IRAS13224-3809/0780560101/PROC/prod"
prefix = "EPN_S002_"
spectra = joinpath(DATADIR, prefix*"src_spec.fits")
background = joinpath(DATADIR, prefix*"bkg_spec.fits")
RMF = joinpath(DATADIR, prefix*"src_rmf.fits")
ARF = joinpath(DATADIR, prefix*"src_arf.fits")

data = OGIPDataset(spectra, background=background, response=RMF, ancillary=ARF)
regroup!(data)
normalize!(data)
drop_bad_channels!(data)
mask_energies!(data, 1.0, 10.0)
data
plot(data,xlims=(1.0, 10.0),yscale=:log10,xscale=:log10)

model = BlackBody(kT = FitParam(0.1)) + PowerLaw()
prob = FittingProblem(model => data)
details(prob)

result = fit(prob, LevenbergMarquadt())
update_model!(model, result)

plotresult(data, [result], xlims=(1.0, 10.0),yscale = :log10, xscale = :log10)
