# STEMMUS-N

**Public MATLAB code for the article:** *Crop rooting depth acts as a hydraulic lever mediating the fate of deep legacy nitrate*.

This repository contains the public research code associated with the article above. The code is provided to support transparency, reproducibility, academic communication, and further scientific development of the STEMMUS-N model framework.

## Public Code Statement

This repository is made publicly available as the accompanying code archive for the article *Crop rooting depth acts as a hydraulic lever mediating the fate of deep legacy nitrate*.

The purpose of this public release is to allow readers, reviewers, and researchers to inspect the model implementation, reproduce relevant analyses where possible, and build upon the scientific workflow in a responsible way.

Users of this repository are expected to:

- cite or acknowledge the related article and this repository when using the code, model structure, data-processing workflow, or derived results;
- preserve author information, provenance, and repository notices when redistributing or modifying the materials;
- use the code for lawful, ethical, and academically responsible purposes;
- clearly indicate any changes when adapting the code for other studies or applications.

## Repository Overview

STEMMUS-N is a MATLAB-based model code repository developed for the study of soil water, heat, gas, and nitrogen transport processes, with a focus on the role of crop rooting depth in mediating the fate of deep legacy nitrate.

The repository includes MATLAB scripts and functions for model initialization, boundary conditions, soil hydraulic and thermal processes, nitrogen transformation and transport, evapotranspiration calculation, simulation control, and output processing.

Key components include:

- main simulation entry points such as `MainLoop.m` and `STEMMUS_N.m`;
- soil water, heat, air, and nitrogen process modules;
- evapotranspiration and plant-related calculation routines;
- input/output utilities and post-processing scripts;
- example input files and model configuration materials.

## Citation

If you use this repository, please cite both the associated article and this public code repository where appropriate.

### Article Citation

The final article citation will be updated after publication. Before the final journal information is available, please cite the article as:

**APA style**

> [Author(s)]. ([Year]). *Crop rooting depth acts as a hydraulic lever mediating the fate of deep legacy nitrate*. [Journal/Preprint server]. [DOI or URL]

**BibTeX**

```bibtex
@article{stemmus_n_rooting_depth_legacy_nitrate,
  title   = {Crop rooting depth acts as a hydraulic lever mediating the fate of deep legacy nitrate},
  author  = {[Author(s)]},
  journal = {[Journal or preprint server]},
  year    = {[Year]},
  doi     = {[DOI]},
  url     = {[Article URL]}
}
```

### Code Repository Citation

Please also cite this repository when using the MATLAB code directly:

**APA style**

> [Author(s)]. (2026). *STEMMUS-N: Public MATLAB code for "Crop rooting depth acts as a hydraulic lever mediating the fate of deep legacy nitrate"* [Computer software]. GitHub. https://github.com/3100362274/STEMMUS-N

**BibTeX**

```bibtex
@software{stemmus_n_matlab_code_2026,
  title  = {STEMMUS-N: Public MATLAB code for {Crop rooting depth acts as a hydraulic lever mediating the fate of deep legacy nitrate}},
  author = {[Author(s)]},
  year   = {2026},
  url    = {https://github.com/3100362274/STEMMUS-N},
  note   = {MATLAB research code associated with the article Crop rooting depth acts as a hydraulic lever mediating the fate of deep legacy nitrate}
}
```

Please replace `[Author(s)]`, `[Year]`, `[Journal or preprint server]`, `[DOI]`, and `[Article URL]` with the final publication information once available.

## License

This repository is released under the MIT License. See the [`LICENSE`](LICENSE) file for details.

## Notes

This repository is released as research code. It is intended primarily for scientific inspection, reproducibility, and model development rather than as a packaged software product.
