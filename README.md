# Introduction to Microbiomics - 18-19/Nov/2021
VirtualBox VM image prepared to be used during Introduction to microbiomics course offered by Integrative Omics group at LNBR/CNPEM.

### How to download and install VirtualBox VM with the bioinformatics environment necessary for the course

The steps below will guide you to proceed with virtualbox installation and VM setup: The VM is prepared with all softwares necessary for the course. 

1-	Download and install VirtualBox from: https://www.virtualbox.org/wiki/Downloads
and select the proper version according to host's OS;

2-	Download and install Oracle VM VirtualBox extension pack from: https://download.virtualbox.org/virtualbox/6.1.28/Oracle_VM_VirtualBox_Extension_Pack-6.1.28.vbox-extpack ;

3-	Download the pre-configured VM:
It can download one of the two options:

 - Single image file version: 
   - option 1: https://filesender.rnp.br/?s=download&token=88db7919-98f2-4ae2-a514-f3804d9ab1a1; (.ova file, can be imported directly into VirtualBox)
   - option 2: https://drive.google.com/file/d/1xavSAk7ux2EGgKl8F-FFh4DyLML_b9GU/view?usp=sharing (.gz file, must be decompressed before importing into VirtualBox).
   - option 3: https://cnpemcamp.sharepoint.com/:f:/s/microbiomics_course/Et7X1YupDVRFj_yaMXlkQoEBPLifqUToD-Qr3_63uraM1Q?e=khq3Zq (Four .zip files, that must be decompressed before importing the VM into VirtualBox)

4 - To import VM image, open VirtualBox, go to **File** menu and select **Import Appliance**. Next, in the following window, keep *Local File System* selected in **Options** drop-down menu and search for VM image you can download. 

5-	 Finally, click in **next** to review VM settings and click in the **import** button;

6-	Alternatively, it is possible to configure the same environment in your physical computer (Linux) or on another virtualization environment by downloading the script in the link below to automatically setup the bioinformatics environment;

https://github.com/jmartinsjrbr/introduction_to_microbiomics/blob/main/setup_vm.sh .

 - Type the following commands to run it on linux terminal
```bash
chmod u+x setup_vm.sh
./setup_vm.sh
```

7- Please find below login information to sign in the VM:
 - **user:** bioinformatica
 - **password:** lnbr@2021
