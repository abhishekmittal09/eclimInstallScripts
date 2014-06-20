# Created by Abhishek Mittal

# Installs Eclim and it's dependencies in the system
# Starts the Xvfb server
# Starts the Eclim server

# **************EXECUTION*******************
# no sudo permissions for doing suff in /opt directory and for installing dependencies (openjdk-6-jdk, xvfb, build-essential)
# command 'bash ./installEclim.sh'

# Reference http://eclim.org/install.html

#************REQUIRED CONFIGURATION BEFORE INSTALLING***************
#installDir is the directory where eclipse would be installed
#eclim would be installed inside the eclipse folder of this directory

User="ubuntu"
installDir="/home/$User/EclimTest"
withVim="true"
vimFiles="$installDir/.vim" #needed if withVim is set to true, tells the path of the vim directory
mkdir $installDir
mkdir $installDir/EclimRestAPI
wget -c http://mirror.netcologne.de/eclipse/technology/epp/downloads/release/kepler/SR2/eclipse-standard-kepler-SR2-linux-gtk-x86_64.tar.gz -O $installDir/eclipse-standard-kepler-SR2-linux-gtk-x86_64.tar.gz
#wget http://www.mirrorservice.org/sites/download.eclipse.org/eclipseMirror/technology/epp/downloads/release/kepler/R/eclipse-standard-kepler-R-linux-gtk-x86_64.tar.gz
wget -c http://sourceforge.net/projects/eclim/files/eclim/2.3.4/eclim_2.3.4.jar/download -O $installDir/eclim_2.3.4.jar
echo "Download complete"

#required for Project Creation in Eclim
#assuming c libraries are present in /usr/include
#assuming c++ libraries are present in /usr/include/c++
#assuming ruby interpreter is at /usr/local/bin/ruby

rubyInterpreter="/usr/local/ruby"
cInclude="/usr/include"
cppInclude="/usr/include/c++"
#give full path of the directory where Eclim projects have to be created, this directory should be modifiable without sudo permissions
supportedLanguages="$installDir/eclipse/supportedLanguages"

echo "*****************INSTALLATION BEGINS*******************************"
#reqiured dependencies for eclipse and eclim
sudo apt-get install -y openjdk-6-jdk xvfb build-essential vim

#start the xvfb server, this will result is starting x11 forwarding which would transfer any graphical displays to the system accessing the server
Xvfb :1 -screen 0 1024x768x24 &

#untar the eclipse files to the installation directory
tar -zxf $installDir/eclipse-standard-kepler-SR2-linux-gtk-x86_64.tar.gz -C $installDir

#go to directory where eclipse is installed and install the dependancies

#install eclipse dependancies
#echo "*******************************Installing php"
#DISPLAY=:1 $installDir/eclipse/eclipse -nosplash -consolelog -debug -application org.eclipse.equinox.p2.director -repository http://download.eclipse.org/releases/kepler -installIU org.eclipse.php.feature.group

echo "********************************Installing cdt"
DISPLAY=:1 $installDir/eclipse/eclipse -nosplash -consolelog -debug -application org.eclipse.equinox.p2.director -repository http://download.eclipse.org/releases/kepler -installIU org.eclipse.cdt.feature.group

echo "********************************Installing dltk.core"
DISPLAY=:1 $installDir/eclipse/eclipse -nosplash -consolelog -debug -application org.eclipse.equinox.p2.director -repository http://download.eclipse.org/releases/kepler -installIU org.eclipse.dltk.core.feature.group

echo "********************************Installing dltk.ruby"
DISPLAY=:1 $installDir/eclipse/eclipse -nosplash -consolelog -debug -application org.eclipse.equinox.p2.director -repository http://download.eclipse.org/releases/kepler -installIU org.eclipse.dltk.ruby.feature.group

echo "********************************Installing jdt"
DISPLAY=:1 $installDir/eclipse/eclipse -nosplash -consolelog -debug -application org.eclipse.equinox.p2.director -repository http://download.eclipse.org/releases/kepler -installIU org.eclipse.jdt.feature.group

#echo "*******************************Installing wst"
#DISPLAY=:1 $installDir/eclipse/eclipse -nosplash -consolelog -debug -application org.eclipse.equinox.p2.director -repository http://download.eclipse.org/releases/kepler -installIU org.eclipse.wst.web_ui.feature.feature.group

#echo "*******************************Installing groovy"
#DISPLAY=:1 $installDir/eclipse/eclipse -nosplash -consolelog -debug -application org.eclipse.equinox.p2.director -repository http://dist.springsource.org/release/GRECLIPSE/e4.3/ -installIU org.codehaus.groovy.eclipse.feature.feature.group

echo "*******************************Installing pydev"
DISPLAY=:1 $installDir/eclipse/eclipse -nosplash -consolelog -debug -application org.eclipse.equinox.p2.director -repository http://pydev.org/updates -installIU org.python.pydev.feature.feature.group

#echo "*******************************Installing scala"
#DISPLAY=:1 $installDir/eclipse/eclipse -nosplash -consolelog -debug -application org.eclipse.equinox.p2.director -repository http://download.scala-ide.org/sdk/helium/e38/scala210/stable/site -installIU org.scala-ide.sdt.feature.feature.group

#to integrate eclim with vim run this command and some more configuration of vim might be needed to get the things working.. refer http://eclim.org/install.html
#assuming vim is installed in the home dir
if [ $withVim == "true" ]; then
	echo "Installing with Vim"
	java -Dvim.files=$vimFiles -Declipse.home=$installDir/eclipse -jar $installDir/eclim_2.3.4.jar install
fi
#if vim 
if [ $withVim == "false" ]; then
	echo "Installing without Vim"
	java -Dvim.skip=true -Declipse.home=$installDir/eclipse -jar $installDir/eclim_2.3.4.jar install
fi

echo "*************************Finished Installing*****************************"
