                         
      .oPYo. .oPYo.  .oPYo. 
      8.     8       8    8 
      `boo   `Yooo. o8YooP' 
      .P         `8  8      
      8           8  8      
      `YooP' `YooP'  8      

Installing esp is easy to do. Ensure wget is installed, add ~/bin to the local users executable path and download it.


1. Ensure that wget is avaiable on your system: `wget -V`

    if not, then install using `brew install wget`

2. Ensure the current user has ~/bin/ in the executable path using `echo $PATH`

    if not: `echo 'export PATH=$PATH:~/bin'  >> ~/.bash_profile; export PATH=$PATH:~/bin`

3. Once ready to install - `wget -P ~/bin/ —output-document=esp https://raw.github.com/kimlercorey/esp/master/esp.sh; mv ~/bin/esp.sh ~/bin/esp; chmod +x ~/bin/esp;`


