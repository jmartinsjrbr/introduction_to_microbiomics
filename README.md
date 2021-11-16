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

6- Please find below login information to enter de VM:
 - **user:** bioinformatica
 - **password:** lnbr@2021

https://github.com/jmartinsjrbr/introduction_to_microbiomics/blob/main/setup_vm.sh .

 - Type the following commands to run it on linux terminal
```bash
chmod u+x setup_vm.sh
./setup_vm.sh
```

At the day of the event, please access the link below to see the practices guidelines:
https://github.com/jmartinsjrbr/introduction_to_microbiomics-practice
