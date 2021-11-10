# Introduction to microbiomics
VirtualBox VM image prepared to be used during Introduction to microbiomics course


## How to download and install VirtualBox VM with the bioinformatics environment necessary to the course

The steps below will guide you to proceed with virtualbox installation and VM setup: The VM was previously set with all softwares necessary for doing the course. 

1-	Download and install VirtualBox from: https://www.virtualbox.org/wiki/Downloads
and select the proper version according to host's OS;

2-	Download and install Oracle VM VirtualBox extension pack from: https://download.virtualbox.org/virtualbox/6.1.28/Oracle_VM_VirtualBox_Extension_Pack-6.1.28.vbox-extpack ;

3-	To import VM image, open VirtualBox, go to **File** menu and select **Import Appliance**. Next, in the following window, keep *Local File System* selected in **Options** drop-down menu and search for VM image you have download from:

 - Zipped version (splitted in 4 files): https://teams.microsoft.com/_#/files/General?groupId=a95c950b-420a-4c67-8a9f-d2b9186e6b84&threadId=19%3AaiOG91ElFqHsvTNGYTBiOgyIQbAEtcbmn-OzDGQ2P- I1%40thread.tacv2&ctx=channel&context=VM_zipped&rootfolder=%252Fsites%252FOmicscourse%252FDocumentos%2520Compartilhados%252FGeneral%252FOmics_Course%252FVM%252FVM_zipped (zipped version splitted into 4 files) or 

 - Single image file version: https://www.dropbox.com/sh/8ziyw3eujn9ic28/AAAF3mgAl2y8ybjneVoSbJm0a?dl=0 ;

4-	 Finally, click in **next** to review VM settings and click in the **import** button;

5-	Alternatively, those ones which has a powerful workstation computer or are running another virtualization environment can download the script in the link below to automatically setup the bioinformatics environment;

https://github.com/jmartinsjrbr/introduction_to_microbiomics/blob/main/setup_vm.sh .

 - Type the following command to run it on linux terminal
```bash
chmod u+x setup_vm.sh
./setup_vm.sh
```
