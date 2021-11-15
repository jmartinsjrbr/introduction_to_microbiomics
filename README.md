# Introduction to Microbiomics - 18-19/Nov/2021
VirtualBox VM image prepared to be used during Introduction to microbiomics offered by Integrative Omics group at LNBR/CNPEM.

### How to download and install VirtualBox VM with the bioinformatics environment necessary to the course

The steps below will guide you to proceed with virtualbox installation and VM setup: The VM is prepared with all softwares necessary for doing the course. 

1-	Download and install VirtualBox from: https://www.virtualbox.org/wiki/Downloads
and select the proper version according to host's OS;

2-	Download and install Oracle VM VirtualBox extension pack from: https://download.virtualbox.org/virtualbox/6.1.28/Oracle_VM_VirtualBox_Extension_Pack-6.1.28.vbox-extpack ;

3-	To import VM image, open VirtualBox, go to **File** menu and select **Import Appliance**. Next, in the following window, keep *Local File System* selected in **Options** drop-down menu and search for VM image you have download from:

 - Zipped version (splitted in 4 files): https://www.dropbox.com/sh/ey38wcrcuv43wxi/AAC9x3PBn1dMwrHn7hamZIrBa?dl=0 (zipped version splitted into 4 files, that must be unziped before to import it to VirtualBox) or 

 - Single image file version: https://www.dropbox.com/sh/er05qrscv9up2zg/AAA3u_Z4hhyn1DJB2lMcapQba?dl=0 ;

4-	 Finally, click in **next** to review VM settings and click in the **import** button;

5-	Alternatively, those ones which have a powerful workstation computer or are running another virtualization environment can download the script in the link below to automatically setup the bioinformatics environment;

https://github.com/jmartinsjrbr/introduction_to_microbiomics/blob/main/setup_vm.sh .

 - Type the following commands to run it on linux terminal
```bash
chmod u+x setup_vm.sh
./setup_vm.sh
```

## Practices guidelines
In this section you will find a guideline for each practice that will be offered during the course

### Metatranscriptomics: Metatranscriptome analysis using Sequence Annotation (SAMSA2) Pipeline 

![image](https://user-images.githubusercontent.com/11639261/141863319-65a37b17-11a6-4573-a229-d24b0d511537.png)

#### Example Files and Workflow 
For this practical demonstration we are going to use sample files provided with SAMSA 2. These files can be found in the folder: *~/omics_course/progs/samsa2/sample_files_paired-end/1_starting_files*

 - Create and enter a folder named metatranscriptomics 
```
cd omics_course 
mkdir metatranscriptomics 
cd metatranscriptomics 
```
- Copy the sample files to the metatranscriptomics folder  
```
cp -r ~/omics_course/progs/samsa2/sample_files_paired-end/1_starting_files/*.fastq . 
```
#### Setup variables pathways

- Setup pathways
```
#!/bin/bash
Setup pathways 

# VARIABLES - Set pathway for starting_location to location of samsa2  
#0. Set starting location: 
starting_location=~/omics_course/progs/samsa2 

#00. Starting files location 
starting_files_location=~/omics_course/metatranscriptomics 

#1. PEAR 
pear_location=$starting_location/programs/pear-0.9.10-linux-x86_64/bin 

#2. Trimmomatic 
trimmomatic_location=$starting_location/programs/Trimmomatic-0.36 

#3. SortMeRNA 
sortmerna_location=$starting_location/programs/sortmerna-2.1 

#4. DIAMOND 
#diamond_database="$starting_location/full_databases/RefSeq_bac" 
#diamond_subsys_db="$starting_location/full_databases/subsys_db" 
diamond_database="$starting_location/setup_and_test/tiny_databases/RefSeq_bac_TINY_24MB" 
diamond_subsys_db="$starting_location/setup_and_test/tiny_databases/subsys_db_TINY_24MB" 
diamond_location="$starting_location/programs/diamond" 

#5. Aggregation 
python_programs=$starting_location/python_scripts 
#RefSeq_db="$starting_location/full_databases/RefSeq_bac.fa" 
#Subsys_db="$starting_location/full_databases/subsys_db.fa" 
RefSeq_db="$starting_location/setup_and_test/tiny_databases/RefSeq_bac_TINY_24MB.fa" 
Subsys_db="$starting_location/setup_and_test/tiny_databases/subsys_db_TINY_24MB.fa" 

#6. R scripts and paths 
export R_LIBS="$starting_location/R_scripts/packages" 
R_programs=$starting_location/R_scripts 
```
#### Preprocessing 
The first steps in analyzing metatranscriptomics data will be the preprocessing of reads or reads QC to remove low-quality data. In SANSA pipeline, if performed paired-end sequencing, reads must be merged and filtered to remove low-quality reads and adaptor contamination. 

- Paired-end read merging 
If paired-end sequencing was performed, there will be two FASTQ sequence files for each sample provided; Sample names have “R1” and “R2”.  R1 contains the forward reads, while R2 contains the reverse reads.   

One way to merge these two files is using a read merging program, such as PEAR (Paired End reAd mergeR)( https://sco.h-its.org/exelixis/web/software/pear/ ).  
To use PEAR for merging two paired-end reads, run it from the command line, using the following command: 
```
./pear –f forward_reads.fastq –r reverse_reads.fastq  
```
 To see PEAR options, use the following command:  
```
./pear –help | less 
```
- Make a script to run all files 
```
cd $starting_files_location 
for file in $starting_files_location/*R1* 
do 
     file1=$file 
     file2=`echo $file1 | awk -F "R1" '{print $1 "R2" $2}'` 
     out_name=`echo $file | awk -F "R1" '{print $1 "merged"}'` 
     #out_name=`echo ${out_path##*/}` 
     $pear_location/pear -f $file1 -r $file2 -o $out_name 
done 
```
- To organize files create a folder and copy the merged files to the new fold 
```
mkdir $starting_files_location/step_1_output/ 
mv $starting_files_location/*merged* $starting_files_location/step_1_output/ 
```
**Result:** A fastq sequence file with overlapping paired-end reads merged for each sample.  Additionally, separate files are produced for the not combined reads; these may be included as well in the analysis. 

- Removal of adaptor contamination and low-quality reads

Raw sequences may contain low-quality reads, or reads with “contamination” – the adaptor sequences used for the process of sequencing may have been accidentally read as part of the read.  These contaminated and low-quality sequences should be removed to avoid skewing the results of a metatranscriptome analysis. 
There are many programs available for cleaning and removing adaptor sequences from raw sequence files; this pipeline is set up to use Trimmomatic (http://www.usadellab.org/cms/?page=trimmomatic).  This Java application includes primer sequences for Illumina machines, and can be used to filter out adaptor sequences from either single-end or paired-end sequencing. 
The command is structured like so: 
```
java -jar trimmomatic-0.33.jar SE –phred33 $infile $outfile_name SLIDINGWINDOW:4:15 MINLEN:99 
```
Details on these parameters, as well as other commands, can be found in the Trimmomatic manual.  That manual can be accessed here: http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/TrimmomaticManual_V0.32.pdf   
**Result:** A fastq sequence file with low-quality sequences and adaptor contamination removed. 

```
java -jar $trimmomatic_location/trimmomatic-0.36.jar SE -phred33 $starting_files_location/step_1_output/control_1_TINY_merged.assembled.fastq $starting_files_location/step_1_output/control_1_TINY_clean.fastq SLIDINGWINDOW:4:15 MINLEN:99 
```

- Make a script to run all files 
```
for file in $starting_files_location/step_1_output/*.assembled.* 
do 
     name=`echo $file | awk -F "merged" '{print $1 "clean.fastq"}'` 
     java -jar $trimmomatic_location/trimmomatic-0.36.jar SE -phred33 $file $name SLIDINGWINDOW:4:15 MINLEN:99 
done 
```
- To organize files create a folder and copy the merged files to the new fold 
```
mkdir $starting_files_location/step_2_output/ 
mv $starting_files_location/step_1_output/*clean.fastq $starting_files_location/step_2_output/ 
```
- GETTING RAW SEQUENCES COUNTS 
```
for file in $starting_files_location/step_2_output/*clean.fastq 
do 
     python3 $python_programs/raw_read_counter.py -I $file -O $starting_files_location/step_2_output/raw_counts.txt 
done 
```

- Removal of ribosome sequences 
One issue when sequencing extracted RNA is filtering out mRNA from the much more common ribosomal RNA, or rRNA. Although rRNA comprises the majority of all extracted RNA from microbiome communities, it can obscure the more important mRNAs.  For best results, ribodepletion methods should be used on the biological samples after RNA extraction and before sequencing as a quality control step. 

However, biological ribodepletion kits are not completely effective at removing all ribosomes.  Stripping out remaining ribosomal reads will help increase the speed of downstream pipeline steps, by resulting in fewer total reads to be annotated (the slowest and most computationally intensive step) and analyzed. 

SortMeRNA (http://bioinfo.lifl.fr/RNA/sortmerna/) is a robust ribosomal read filtering tool that can incorporate multiple databases (SILVA, GreenGenes, RDP) for rRNA identification.  Note that SortMeRNA was originally designed to select rRNA sequences, rather than to remove them, and so the reads discarded by SortMeRNA are, in fact, the mRNAs needed for metatranscriptome analysis. 
For detailed instructions on using SortMeRNA, be sure to consult the included user manual for version 2.1.   

Note that the “--other" flag MUST be applied when using SortMeRNA!  Without this flag, all reads that do not match the ribosomal RNAs in the reference will be discarded.  These reads are, in fact, the mRNAs, and must be preserved for the following steps in the SAMSA pipeline. 

Example SortMeRNA command (matching against the 16S SILVA bacterial database, included in SortMeRNA download): 
```
sortmerna --refsilva-bac-16s-db --reads $file.fastq --aligned $file.ribosomes --other $file.ribodepleted --fastx --num_alignments 1 --log –v 
```
From this command, two files will be produced; the $file.ribosomes will contain all sequences from the original file identified as rRNA, while the $file.ribodepleted will contain all reads discarded by SortMeRNA (aka not identified as ribosomes, to be used in the next step of the SAMSA pipeline). 

Note that while the identified ribosomal sequences can potentially be used for other analyses, the biological ribodepletion that is strongly recommended for all samples before sequencing will likely skew these results, making them unusable for organism-specific abundance measurements. 

**Result:** A fastq sequence file with ribosomal sequences removed; additionally, a second file is created containing said ribosomal sequences for optional taxonomic profiling. 
```
#REMOVING RIBOSOMAL READS WITH SORTMERNA 
# Note: this step assumes that the SortMeRNA databases are indexed. If not, do that first (see the SortMeRNA user manual for details). 
for file in $starting_files_location/step_2_output/*clean.fastq 
do 
  name=`echo $file | awk -F "clean" '{print $1 "ribodepleted"}'` 
sortmerna_location/sortmerna \ 
--ref $sortmerna_location/rRNA_databases/silva-bac-16s-id90.fasta,$sortmerna_location/index/silva-bac-16s-db \ 
--reads $file \ 
--aligned $file.ribosomes \ 
--other $name \ 
--fastx \ 
--num_alignments 0 \ 
--log -v 
done 

mkdir $starting_files_location/step_3_output/ 

mv $starting_files_location/step_2_output/*ribodepleted* $starting_files_location/step_3_output/ 
```

#### Annotation 
Now that the initial sequences have been merged (if using paired-end sequencing), cleaned, and stripped of adaptor sequence contamination and ribosomal sequences, the next step is to annotate the mRNA reads to their corresponding match in a reference database.  

It can be done using DIAMOND, a superfast BLAST-like aligner tool. This tool can process reads up to 10,000x as fast as BLASTX, with very little loss in accuracy. DIAMOND can also annotate against any provided database, allowing for custom databases to be created and searched against. 

- Creating a DIAMOND-indexed database 
Any database file needs to be indexed by DIAMOND and converted into a binary file before it can be searched against.  DIAMOND will convert any fasta file to a usable database with the following command: 

```
diamond makedb --in $database --db $database 
```

The --in flag specifies the starting fasta file that will be converted to a DIAMOND-searchable database. 

DIAMOND can be given any database file to be indexed. Two databases that should be interesting to microbiome researchers are the NCBI RefSeq database and the SEED Subsystems database.  Maintained by NCBI, RefSeq is one of the most complete databases for general purposes and is generally accepted to contain high-quality annotations.  SEED Subsystems offers the unique ability to sort specific functions into hierarchies, letting similar functions be grouped under a category heading, such as “cellular respiration” or “protein biosynthesis.”  This can be very useful for examining overall functional activity within a metatranscriptome. 

The RefSeq database can be accessed through NCBI’s FTP site, here: ftp://ftp.ncbi.nlm.nih.gov/refseq/release/complete/ .  The simplest approach is to download all non-redundant protein sequence files, use cat on the command line to merge them together into a single gzipped file: 

```
cat file1.gz file2.gz file3.gz > all_files.gz 
```

The SEED Subsystems database can be accessed through their FTP site here: ftp://ftp.theseed.org/subsystems/ 

Note, however, that the SEED Subsystems database is not readily downloadable in a fasta format that can be indexed by DIAMOND.  The different levels of Subsystems hierarchy are maintained in different files.   For merging these files together to create a single, indexable database that contains all hierarchy information, see the relevant Github repository here: https://github.com/transcript/subsystems  

- Annotating a file against a DIAMOND database 
```
For demonstration purpose we will use a TINY version of RefSeq and Subsystems database. 
for file in $starting_files_location/step_3_output/*ribodepleted.fastq 
do 
     name=`echo $file | awk -F "ribodepleted" '{print $1 "RefSeq_annotated"}'` 

     $diamond_location blastx --db $diamond_database -q $file -f 6 -o $name -k 1 --sensitive 
done 

mkdir $starting_files_location/step_4_output/ 
mv $starting_files_location/step_3_output/*annotated* $starting_files_location/step_4_output/ 

diamond blastx --db $diamond_database -q $filename -f 6 -o $diamond_output  -k 1  
```
The resulting data table is ready for step 3 in the SAMSA pipeline: **aggregation**. 

#### Aggregation 

Now that each metatranscriptome file has been annotated, the next step is to reduce the results down into a condensed and simplified format for statistical analysis.  DIAMOND returns the best match for each read in the starting file that meets its parameters for sequence specificity, much like a line-item receipt from a grocery store.  This step converts this large file into a condensed, sorted summary table that returns the total number of hits to each specific organism or function. 

NOTE: This step will create two summary files for each starting metatranscriptome; one file will contain annotations grouped by organism (all Bacteroides reads will be grouped together), while the other file will contain annotations grouped by function (all reads coding for the enzyme lactase will be grouped together).  Later steps will document the steps necessary to perform a search for all functions expressed by a specific organism or group of organisms, or vice versa, all organisms performing a specific function or set of functions. 

This next step uses the Python program “DIAMOND_analysis_counter.py”, and for the RefSeq database, will require access to the original (readable, not DIAMOND-converted) database file. 

To use this program for aggregating all reads by organism: 
```
python DIAMOND_analysis_counter.py –I $infile –D database_file –O 
```
 
And to use this program for aggregating all reads by function: 
```
python DIAMOND_analysis_counter.py –I $infile –D database_file –F 
``` 
The result is a 3 column table, saved in tab-separated values (.tsv) format.  The columns are as follows: 

*(percentage of total reads)		(read count)		(annotated organism or function)*

The resulting files can either be viewed directly, or can be imported into R for further statistical analysis and figure generation. 


-- AGGREGATING WITH ANALYSIS_COUNTER 
```
for file in $starting_files_location/step_4_output/*RefSeq_annotated* 
do 
  python3 $python_programs/standardized_DIAMOND_analysis_counter.py -I $file -D $RefSeq_db -O 
  python3 $python_programs/standardized_DIAMOND_analysis_counter.py -I $file -D $RefSeq_db -F 
done 

mkdir $starting_files_location/step_5_output/ 
mkdir $starting_files_location/step_5_output/RefSeq_results/ 
mkdir $starting_files_location/step_5_output/RefSeq_results/org_results/ 
mkdir $starting_files_location/step_5_output/RefSeq_results/func_results/ 

mv $starting_files_location/step_4_output/*organism.tsv $starting_files_location/step_5_output/RefSeq_results/org_results/ 
mv $starting_files_location/step_4_output/*function.tsv $starting_files_location/step_5_output/RefSeq_results/func_results/ 

```
### Metagenomics: from reads to MAGs
In this hands on practice you will have the opportunity to learn all the steps involved in a standard metagenomics analysis, from pre-processing steps (read trimming, host read removal and reads taxonomic assignment) to Binning steps (Binning, binning refinement, bins reassemble, Bin quantification to address their abundance, Bin classification and functional annotation).

As an example, we will use a reduced version of the metaHIT survey dataset available at .... with metawrap pipeline. (https://github.com/bxlab/metaWRAP)

![image](https://user-images.githubusercontent.com/11639261/141855861-4383c93f-40a0-4d66-bdaa-791b33fddaaf.png)
(https://www.gutmicrobiotaforhealth.com/metahit/).


To run the analysis you can simply run the following script inside the VM environmet you previously prepared as described in sections above.

```
#!/bin/bash

```

