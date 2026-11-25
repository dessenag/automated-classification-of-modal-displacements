# Accompanying data: Automated classification of modal displacements

**Authors:** Gabriele Dessena¹, Saray Undiano Echániz¹

¹ Department of Aerospace Engineering, Universidad Carlos III de Madrid, Spain

This repo contains the code for the preprint:

G. Dessena, M. Civera, S. Undiano Echániz, and O. Bonilla-Manrique, "Automated classification of modal displacements," [arXiv:2611.31472](https://doi.org/10.48550/arXiv.2611.31472), 2026. Preprint.

When using this code for your work or research please cite the following:

1. G. Dessena, M. Civera, S. Undiano Echániz, and O. Bonilla-Manrique, "Automated classification of modal displacements," [arXiv:2611.31472](https://doi.org/10.48550/arXiv.2611.31472), 2026. Preprint.
2. G. Dessena, "A dataset for partial in-plane acceleration of the XB-2 wing," Universidad Carlos III de Madrid, 2026, doi: [10.5281/zenodo.24536230](https://doi.org/10.5281/zenodo.24536230).

The code computes four indices of a mode shape from its sensor vectors, namely the bending score $B$, the torsion score $T$, the twist share $\tau$ and the in-plane ratio $\rho$, and it assigns the type of motion with the classification rule of [1]. It reproduces Tables 1, 3 and 4, the code-made figures and the in-text values of the three case studies of [1], and checks the sensor positions of Table 2:

| Case | Script | Items of [1] |
|---|---|---|
| Finite element (FE) model of a tapered cantilever plate | [`Plate/main.m`](/Plate/main.m) | Table 1, Figure 3a-i |
| Ground vibration test of the eXperimental BeaRDS 2 (XB-2) flexible wing | [`XB2/main.m`](/XB2/main.m) | Table 3, Figure 5a-e, the sensor positions of Table 2, the section in-plane ratios of Section 4.1, the rigid-rotation reference values of the Discussion |
| Ambient vibration test of the Sheraton Universal Hotel | [`Sheraton/main.m`](/Sheraton/main.m) | Table 4, Figure 7a-e, the floor ratios and the leave-one-floor-out check of Section 4.2 |

Each script ends by comparing every computed value with the value printed in [1], listed in `src/<case>_paper_values.m`, and prints `M of N published values matched`. A number matches when it agrees to the printed decimals, and a label matches when the strings are equal. Figures 1, 2, 4 and 6 of [1] are drawings and photographs, and they are not produced by the code.

## Repository Structure

| Path | Description |
|---|---|
| [`setup_paths.m`](/setup_paths.m) | Adds the shared functions to the path and returns the folders of a case |
| [`Utilities/identifyMotion.m`](/Utilities/identifyMotion.m) | Bending score and torsion score of a mode from its sensor vectors |
| [`Utilities/twist_share.m`](/Utilities/twist_share.m), [`inplane_ratio.m`](/Utilities/inplane_ratio.m), [`section_ratios.m`](/Utilities/section_ratios.m) | Twist share, in-plane ratio and section ratios |
| [`Utilities/classify_rule.m`](/Utilities/classify_rule.m) | Classification rule of [1] |
| [`Utilities/compare_paper_values.m`](/Utilities/compare_paper_values.m) | Comparison of the computed values with those printed in [1] |
| [`Utilities/download_zenodo.m`](/Utilities/download_zenodo.m), [`zenodo_records.m`](/Utilities/zenodo_records.m), [`file_md5.m`](/Utilities/file_md5.m), [`fetch_ilf.m`](/Utilities/fetch_ilf.m) | Download of the data and of the iLF tutorial on first use, with MD5 check |
| [`Utilities/colourbar_figure.m`](/Utilities/colourbar_figure.m), [`mode_colormap.m`](/Utilities/mode_colormap.m) | Figure helpers |
| [`Utilities/h1_frf.m`](/Utilities/h1_frf.m), [`stabilisation_diagram.m`](/Utilities/stabilisation_diagram.m) | $H_1$ estimator and stabilisation diagram used for the XB-2 identification |
| [`Plate/main.m`](/Plate/main.m) | Plate case; `apdl/` holds the Ansys Mechanical APDL model, `data/sensor_positions.csv` the virtual sensors (mm), and `src/` the sampling at the sensors and the figures |
| [`XB2/main.m`](/XB2/main.m) | XB-2 case; `data/sensor_positions.csv` holds the accelerometers (mm, with the chord and chord fraction of each), and `src/` the transmissibilities, rigid-rotation values and figures |
| [`Sheraton/main.m`](/Sheraton/main.m) | Sheraton Universal Hotel case; `data/sensor_positions.csv` holds the North-South sensor points (m), and `src/fig_to_rigid.m` recovers the floor motion from the published mode figures |

The repository holds code and the three sensor position files only. Each case writes its figures to `Figures/` inside its folder and prints its tables and values in the Command Window.

## Requirements

MATLAB R2025b with the **Signal Processing Toolbox**. The plate case also needs Ansys Mechanical APDL 2026 R1, with the environment variable `ANSYS_EXE` set to its executable. Internet access is needed on the first run of `XB2/main.m` and `Sheraton/main.m`, which download the following:

| Item | Source | Licence | Used by |
|---|---|---|---|
| iLF tutorial (`iLF_id.m`) | [doi:10.5281/zenodo.13863292](https://doi.org/10.5281/zenodo.13863292) | GPL-3.0-or-later | `XB2/main.m` |
| XB-2 time series and transmissibilities | [doi:10.5281/zenodo.24536230](https://doi.org/10.5281/zenodo.24536230) | CC BY 4.0 | `XB2/main.m` |
| Sheraton Universal Hotel mode figures (`SheratonMode1-5.fig`) | [doi:10.5281/zenodo.14975925](https://doi.org/10.5281/zenodo.14975925) | GPL-3.0-or-later | `Sheraton/main.m` |

Each file is checked against its MD5 and downloaded only when it is missing or differs. If the download fails, the script stops and states the URL, the expected MD5 and the folder in which to place a manual copy. The XB-2 data can also be kept elsewhere by setting the environment variable `XB2_DATA_DIR` to their folder.

## Quick start

```matlab
cd XB2
main            % identification of the XB-2 modes, Table 3, Figure 5
cd ../Sheraton
main            % Table 4 and Figure 7
cd ../Plate
main            % FE model, Table 1 and Figure 3 (needs Ansys)
```

In `XB2/main.m`, `SELECTION = 'stored'` uses the modes selected for [1] (model order and pole, listed in the script), and `SELECTION = 'manual'` opens the stabilisation diagram for a selection by hand. `Plate/main.m` runs the FE model in `Plate/results/apdl/` and reuses the mode files found there on later runs.

## Licence

The code in this repository is released under the **MIT licence**, see [LICENSE](/LICENSE). The items downloaded at run time, listed under **Requirements**, keep their own licences and are not bundled in this repository.

## Repository Citation

G. Dessena, M. Civera, S. Undiano Echániz, and O. Bonilla-Manrique, "Automated classification of modal displacements," [arXiv:2611.31472](https://doi.org/10.48550/arXiv.2611.31472), 2026. Preprint.
