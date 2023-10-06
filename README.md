# fluorophore-code
Scripts for processing raw Q2 fluorophore data
This is a script for converting raw Q2 fluorophore data into respiratory rates of leaves. 
1. The script must be run for each Q2 plate wanting to be analysed.
2. A raw data file Data.xls and corresponding metadata Data_metadata.xlsx are provided as examples.
3. Each raw data file corresponding to a plate run must have a completed corresponding metadata file. Name the metadata file as the data file name with 'metadata' appended to the end.
4. In the metadata file are the columns:
5. Sample Name: this is a name corresponding to the sample
6. treatment: A description of the sample treatment if a treatment was applied
7. Well: the Q2 tube position within the plate (e.g. E5). By convention positions A1-B1 are assigned to Nitrogen flushed tubes and C1-D1 are assigned to blank tubes. This is important for slope corrections and the range setting and code must be altered if standards are added to different tube positions. It is also important to list only the wells in use and to add or delete extra psoitions so that raw data and the metadata sheet match in number of samples.
8. Area_cm2: the leaf area placed into tubes in cm2. An area must be specified for each sample position
9. Fresh_Weight_g: The fresh mass of the samples in tubes in grams. If unmeasured leave column blank.
10. Dry_Weight_g: The dry mass of the samples in tubes in grams. If unmeasured leave column blank.
11. Notes: Any notes about each sample can be recorded in this column or otherwise left blank.
12. pressure_kPa: The mean sea level pressure in kPa. This can be optained from the BOM site from the closest weather station to the site of measurement for the day of measurement.
13. 
