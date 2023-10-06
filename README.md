# fluorophore-code
Scripts for processing raw Q2 fluorophore data
This is a script for converting raw Q2 fluorophore data into respiratory rates of leaves. 
1. The script must be run for each Q2 plate wanting to be analysed.
2. A raw data file Data.xls and corresponding metadata Data_metadata.xlsx are provided as examples.
3. Each raw data file corresponding to a plate run must have a completed corresponding metadata file. Name the metadata file as the data file name with 'metadata' appended to the end.
4. In the metadata file are the columns:
  1. Sample Name: this is a name corresponding to the sample
  2. treatment: A description of the sample treatment if a treatment was applied
  3. Well: the Q2 tube position within the plate (e.g. E5). By convention positions A1-B1 are assigned to Nitrogen flushed tubes and C1-D1 are assigned to blank tubes. This is important for slope corrections and the range setting and code must be altered if standards are added to different tube positions. It is also important to list only the wells in use and to add or delete extra psoitions so that raw data and the metadata sheet match in number of samples.
  4. Area_cm2: the leaf area placed into tubes in cm2. An area must be specified for each sample position
  5. Fresh_Weight_g: The fresh mass of the samples in tubes in grams. If unmeasured leave column blank.
  6. Dry_Weight_g: The dry mass of the samples in tubes in grams. If unmeasured leave column blank.
  7. Notes: Any notes about each sample can be recorded in this column or otherwise left blank.
  8. pressure_kPa: The mean sea level pressure in kPa. This can be optained from the BOM site from the closest weather station to the site of measurement for the day of measurement.
  9. temperature: The measuring temperature set for that temperature bay.
  10. tube_vol_mL: the tube volume used in sampling. Usually a 2 mL tube is used but it could be a 1 mL or 4 mL tube.
  11. liq_vol_mL: any amount of water added to sampling tube given in mL.
  12. leaf_thickness_um: The thickness of the leaf measured. This is set to 200 µm by defalt which corresponds to a standard thickness of a wheat leaf. If known this value can be changed.
  13. density: The density of the leaf in g/cm3. 1.1 is the defalt an corresponds to the density of a wheat leaf. It can be adjusted if required.

6. Set the working directory in the script.
7. Run the script.
8. Follow the prompts to enter data and metadata files and to select the start and end time of the respiratory slopes.
9. An output csv file should be generated that provides respiratory rates.
