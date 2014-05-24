# ESP - (E)VERY (S)YSTEM (P)ROGRAM

       .oPYo. .oPYo.  .oPYo.
       8.     8       8    8
       `boo   `Yooo. o8YooP'
       .P         `8  8
       8           8  8
       `YooP' `YooP'  8

## Synopsis

ESP is an OSX terminal convenience script that allows users to easily launch OSX programs from command line without knowing the entire OSX Bundle Identifier Name. It associates user aliases to OSXs kMDItemDisplayName mechanism for an intuitive way to launch programs.  

## Motivaition

When deep into the directory tree, it was annoying to open a program and have to re-navigate down the tree to find the program to modify. Also wanted a way to launch a photoshop by typing 'photshop' or sublime by typing 'sublime' or whatever-the-heck-I-want-to-run by typing 'whatever-part-of-the-program-name-I-know-without-needing-to-have-first-made-an-alias'. For those who consider it more convernient to launch a program from the terminal than to reach for the mouse then go to the Dock or Applications , etc this program might be something which would appeal to you.

## Examples

I should put some examples here soon

## Installation

I'll be changing these installation instruction from this to curl as it is avaiable on the os even without homebrew

Installing esp is easy to do. Ensure wget is installed, add ~/bin to the local users executable path and download it.


 1. Ensure that wget is avaiable on your system: `wget -V`

     if not, then install using `brew install wget`

 2. Ensure the current user has ~/bin/ in the executable path using `echo $PATH`

     if not: `echo 'export PATH=$PATH:~/bin'  >> ~/.bash_profile; export PATH=$PATH:~/bin`

 3. Once ready to install - `wget -P ~/bin/ —output-document=esp https://raw.github.com/kimlercorey/esp/master/esp.sh; mv ~/bin/   esp.sh ~/bin/esp; chmod +x ~/bin/esp;`

## Tests

todo: Add some tests that can be used to verify all features work

## Contributors

The easiest way to get involved is to fork and create a pull request. Also, do add yourself to the authors line or special thanks line too depending on where you prefer to be included. We'll handle inrementing the version on this side. All involvement is always welcome and there is always room for improvement. 

## License

The MIT License (MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
