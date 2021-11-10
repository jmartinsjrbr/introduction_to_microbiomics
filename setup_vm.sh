#!/bin/bash

###THIS SCRIPT IS FOR INSTALLING THE NECESSARY PROGRAMS FOR OMICS COURSE ###
#@Author: Joaquim Martins Junior ###
#@Last update: 03-11-2021 ###

###OS UBUNTU 20.04 LTS 64bits###
echo "**** UPDATING SYSTEM ****"
sudo apt update && sudo apt list --upgradable && sudo apt upgrade
sudo apt install python3-pip git byobu tmux vim curl libcurl4-openssl-dev libxml2 libxml2-dev
sudo apt install openjdk-11-jdk openjdk-11-jdk-headless openjdk-11-jre-headless

#Install R
echo "**** INSTALLING R ****"
sudo apt install r-base r-base-core r-base-dev

#Set environmental vars
echo "**** SETTING ENV VARS ****"
test -d $HOME/omics_course || mkdir $HOME/omics_course
test -d $HOME/bin || mkdir $HOME/bin
test -d $HOME/omics_course/progs || mkdir $HOME/omics_course/progs
test -d $HOME/omics_course/db || mkdir $HOME/omics_course/db

##add env vars to .bashrc
echo "**** ADD PATHS TO ~/.bashrc ****"
echo "#####BIOINFORMATICS ENV VARIABLES#####" >> $HOME/.bashrc
echo "HOME_BIN=\$HOME/bin" >> $HOME/.bashrc
echo "PATH=\$HOME_BIN:\$PATH" >> $HOME/.bashrc
echo "export PATH" >> $HOME/.bashrc

source ~/.bashrc

echo "$PATH"
echo "$HOME_BIN"

###Intall Anaconda3 version 4.10.3

echo "**** INSTALLING ANACONDA3 ****"
##Dependencies:
sudo apt install libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6

##download anaconda
cd ~/Downloads
wget https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh
chmod u+x Anaconda3-2021.05-Linux-x86_64.sh
./Anaconda3-2021.05-Linux-x86_64.sh

source $HOME/omics_course/anaconda3/bin/activate
conda init
source ~/.bashrc

conda config --set auto_activate_base False
conda deactivate

###Create new anaconda environment "omics_course"
echo "**** CREATING OMICS_COURSE ENV ****"
conda update -n base -c defaults conda
conda create -n omics_course python=3.8.10
eval "$(conda shell.bash hook)"
conda activate omics_course

##install multiqc
echo "**** INSTALLING MULTIQC ****"
conda install -c bioconda -c conda-forge multiqc

##install fastp
echo "**** INSTALLING FASTP ****"
cd ~/Downloads
wget http://opengene.org/fastp/fastp
mv ./fastp ~/bin
chmod a+x ~/bin/fastp

##install sortmerna
echo "**** INSTALLING SORTMERNA ****"
conda config --add channels bioconda
conda install sortmerna

##set sortmerna databases
SORTMERNADB=$HOME/omics_course/db/sortmerna
test -d $SORTMERNADB || mkdir $SORTMERNADB

while true;
do
	read -p "Do you want to install sortmerrna databases [Yes/No]?" yn
	case $yn in
		[Yy]* )
			echo "*****INSTALLING sortmerrna DB"
			cd $SORTMERNADB
			wget https://github.com/biocore/sortmerna/releases/download/v4.3.4/database.tar.gz
			tar -xvf *.tar.gz
			rm *.gz
			cd; break;;
		[Nn]* ) break;;
	esac
done
##Install o kaiju
echo "**** INSTALLING KAIJU ****"
git clone https://github.com/bioinformatics-centre/kaiju.git
cd kaiju/src
make

cd ../../
mv kaiju* $HOME/omics_course/progs
echo -e "\n##KAIJU SETUP" >> ~/.bashrc
echo "export PATH=\$HOME/omics_course/progs/kaiju/bin/:\$PATH" >> ~/.bashrc

##set kaiju databases (nr_euk)
SORTMERNADB=$HOME/omics_course/db/kaiju
test -d $KAIJUDB || mkdir $KAIJUDB
SELECTED_DB='nr_euk'

while true;
do
	read -p "Do you want to install KAIJU nr_euk databases [Yes/No]?" yn
	case $yn in
		[Yy]* )
			echo "*****INSTALLING KAIJU (nr_euk) DB"
			cd $KAIJUDB
			kaiju-makedb -s $SELECTED_DB
			cd; break;;
		[Nn]* ) break;;
	esac
done

##Install KronaTools
echo "**** INSTALLING KRONATOOLS ****"
cd ~/Downloads
wget https://github.com/marbl/Krona/releases/download/v2.8/KronaTools-2.8.tar
mkdir $HOME/omics_course/progs/KronaTools-2.8
tar -xvf KronaTools-2.8.tar
rm -rf KronaTools-2.8.tar
mv KronaTools-2.8 $HOME/omics_course/progs/
cd $HOME/omics_course/progs/KronaTools-2.8
chmod u+x ./install.pl
sudo ./install.pl

##install spades
echo "**** INSTALLING SPADES ****"
conda install -c bioconda spades

##Install kallisto
echo "**** INSTALLING KALLISTO ****"
conda install -c bioconda kallisto
conda deactivate

#Install prokka
echo "**** INSTALLING PROKKA ****"
conda create -n prokka -c conda-forge -c bioconda -c defaults prokka

#Install run_dbcan
echo "**** INSTALLING DBCAN ****"
conda create -n run_dbcan python=3.8 diamond hmmer prodigal -c conda-forge -c bioconda
conda activate run_dbcan
pip3 install run-dbcan==2.0.11
cd $HOME/omics_course/db
test -d dbcan || mkdir $HOME/omics_course/db/dbcan
cd $HOME/omics_course/db/dbcan
wget https://bcb.unl.edu/dbCAN2/download/CAZyDB.09242021.fa && diamond makedb --in CAZyDB.09242021.fa -d CAZy
wget https://bcb.unl.edu/dbCAN2/download/dbCAN-HMMdb-V10.txt && mv dbCAN-HMMdb-V10.txt dbCAN.txt && hmmpress dbCAN.txt
wget http://bcb.unl.edu/dbCAN2/download/Databases/tcdb.fa && diamond makedb --in tcdb.fa -d tcdb
wget http://bcb.unl.edu/dbCAN2/download/Databases/tf-1.hmm && hmmpress tf-1.hmm
wget http://bcb.unl.edu/dbCAN2/download/Databases/tf-2.hmm && hmmpress tf-2.hmm
wget http://bcb.unl.edu/dbCAN2/download/Databases/stp.hmm && hmmpress stp.hmm

conda deactivate

##install metawrap
echo "**** INSTALLING METAWRAP ****"
#download metawrap
cd $HOME/omics_course
test -d progs ||mkdir $HOME/omics_course/progs
cd $HOME/omics_course/progs
git clone https://github.com/bxlab/metaWRAP.git
echo -e "\n##METAWRAP SETUP" >> ~/.bashrc
echo "export PATH=\$HOME/omics_course/progs/metaWRAP/bin/:\$PATH" >> ~/.bashrc

#Create metawrap env
conda create -y -n metawrap-env python=2.7
conda activate metawrap-env

#install dependencies
conda config --add channels defaults
conda config --add channels conda-forge
conda config --add channels bioconda
conda config --add channels ursky
conda install --only-deps -c ursky metawrap-mg

#Set quast databases
quast-download-gridss
quast-download-silva
quast-download-busco

ktUpdateTaxonomy.sh

###Manually download buscodb in case failing in previous attempt
BUSCODBDIR=/home/bioinfo/omics_course/anaconda3/envs/metawrap-env/lib/python2.7/site-packages/quast_libs/busco

while true;
do
	read -p "Do you want to install BUSCO DB for metawrap (Quast) manually [Yes/No]?" yn
	case $yn in
		[Yy]* )
			echo "*****INSTALLING BUSCO DBs (Quast) manually"
			cd $BUSCODBDIR

			echo "*****Downloading bacteria db..."
			wget https://busco.ezlab.org/v2/datasets/bacteria_odb9.tar.gz
			tar -vzxf *.tar.gz

			echo "*****Downloading eukaryota db..."
			wget https://busco.ezlab.org/v2/datasets/eukaryota_odb9.tar.gz
			tar -vzxf eukaryota_odb9.tar.gz

			echo "*****Downloading fungi db..."
			wget https://busco.ezlab.org/v2/datasets/fungi_odb9.tar.gz
			tar -vzxf fungi_odb9.tar.gz
			cd; break;;
		[Nn]* ) break;;
	esac
done

cd

####### INSTALL METAWRAP DATABASES #####

METAWRAP_MAIN_DBDIR=$HOME/omics_course/db/metawrap
CHECKM_FOLDER=$METAWRAP_MAIN_DBDIR/checkm
KRAKEN2DB=$METAWRAP_MAIN_DBDIR/kraken2
NCBI_NT=$METAWRAP_MAIN_DBDIR/ncbi/nt
BMTAGGER=$METAWRAP_MAIN_DBDIR/bmtagger

test -d $METAWRAP_MAIN_DBDIR || mkdir $METAWRAP_MAIN_DBDIR
test -d $CHECKM_FOLDER || mkdir $CHECKM_FOLDER
test -d $KRAKEN2DB || mkdir $KRAKEN2DB
test -d $NCBI_NT || mkdir -p $NCBI_NT
test -d $BMTAGGER || mkdir $BMTAGGER

while true;
do
	read -p "Do you want to install metaWRAP databases [Yes/No]?" yn
	case $yn in
		[Yy]* )
			echo "*****INSTALLING CHECKM DB"
			cd $CHECKM_FOLDER
			wget https://data.ace.uq.edu.au/public/CheckM_databases/checkm_data_2015_01_16.tar.gz
			tar -xvf *.tar.gz
			rm *.gz
			cd ../

			echo "*****INSTALLING KRAKEN2 DB"
			cd $KRAKEN2DB
			kraken2-build --standard --threads 10 --db $KRAKEN2DB
			echo "Do not forget to set the KRAKEN_DB variable in the config-metawrap file! Run which config-metawrap to find it."
			cd ../

			echo "*****INSTALLING NCBI_nt BLAST databases"
			cd $NCBI_NT
			wget "ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.*.tar.gz"
			for a in nt.*.tar.gz; do tar xzf $a; done
			echo "Do not forget to set the BLASTDB variable in the config-metawrap file!"
			cd ../

			echo "*****INSTALLING NCBI TAXONOMY"
			cd $NCBI_NT
			wget ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump.tar.gz
			tar -xvf taxdump.tar.gz
			echo "Do not forget to set the TAXDUMP variable in the config-metawrap file! Run which config-metawrap to find it."
			cd ../

			echo "Access the link below to make host genome index for bmtagger:"
			echo "https://github.com/bxlab/metaWRAP/blob/master/installation/database_installation.md#making-host-genome-index-for-bmtagger"

			cd ; break;;
		[Nn]* ) exit;;
	esac
done

#Install SAMSA2
cd $HOME/omics_course/progs
git clone https://github.com/transcript/samsa2.git

SAMSA2DIR=$HOME/omics_course/progs/samsa2
test -d $SAMSA2DIR || mkdir $SAMSA2DIR

cd $SAMSA2DIR/setup_and_test
chmod u+x package_installation.bash
sed -i 's/install_packages.R/install_packages_R_3.6.R/g' package_installation.bash
./package_installation.bash
